---
argument-hint: [google doc url]
description: Export a Google Doc to a clean Markdown file. Use when the user says "convert this google doc", "export google doc to markdown", or provides a Google Docs URL to convert. Requires Chromium running with --remote-debugging-port=9222 and the Chrome DevTools MCP plugin.
---

Convert a Google Doc to Markdown, saving it as a folder with `index.md`, images, and per-tab files.

## Input

The argument is a Google Docs URL: `$ARGUMENTS`

If no URL is provided, get it from the currently active tab using `evaluate_script` to read `window.location.href`. Confirm it's a Google Docs URL before proceeding.

## Steps

### 1. Extract the document ID

Parse the doc ID from the URL pattern: `docs.google.com/document/d/{DOC_ID}/...`

### 2. Open the doc in the browser and discover tabs

Tab discovery requires the doc to be open in the browser so we can read the sidebar DOM.

1. Use `list_pages` to check if the doc is already open (match by doc ID in the URL).
2. If not open, use `navigate_page` to open it in a new tab.
3. Use `select_page` to select the doc's page.
4. Query the DOM for tabs:

```js
async () => {
  const items = document.querySelectorAll('.chapter-item [role="treeitem"]');
  const tabs = [];
  for (let i = 0; i < items.length; i++) {
    const el = items[i];
    const name = el.getAttribute('aria-label')?.replace(/\.\s*\d+\s*comments?$/, '').trim();
    el.click();
    await new Promise(r => setTimeout(r, 500));
    const tabMatch = window.location.href.match(/tab=(t\.[^&#]+)/);
    tabs.push({ name, tabId: tabMatch ? tabMatch[1] : 't.0' });
  }
  if (items.length > 0) items[0].click();
  return tabs;
}
```

This returns an array of `{ name, tabId }` objects. If the doc has only one tab, the array has one entry.

### 3. Fetch document title and HTML for each tab

Use `evaluate_script` to fetch the HTML export for each tab. Run from any page with Google cookies (e.g. the doc page itself).

For the title, fetch the doc page and extract `<title>`:

```js
async () => {
  const docId = 'THE_DOC_ID';
  const metaResp = await fetch(`https://docs.google.com/document/d/${docId}`, { credentials: 'include' });
  const meta = await metaResp.text();
  const titleMatch = meta.match(/<title>([^<]+)<\/title>/);
  return titleMatch ? titleMatch[1].replace(' - Google Docs', '').trim() : null;
}
```

For each tab's HTML, fetch the export endpoint with the tab parameter:

```js
async () => {
  const docId = 'THE_DOC_ID';
  const tabId = 'THE_TAB_ID'; // e.g. 't.t37ywmmt7ifj'
  const resp = await fetch(
    `https://docs.google.com/document/d/${docId}/export?format=html&tab=${tabId}`,
    { credentials: 'include' }
  );
  const html = await resp.text();
  window.__gdocHtml = html;
  return { status: resp.status, length: html.length };
}
```

If the response is too large for a single `evaluate_script` return, store it on `window.__gdocHtml` and retrieve the body in chunks via `window.__gdocHtml.substring(start, end)`.

If the fetch fails (status != 200), tell the user. Common causes: not logged in, doc not shared with them, or Chromium not running with debug port.

### 4. Convert HTML to Markdown

Parse the HTML and produce clean Markdown. The Google Docs HTML export has specific patterns:

- **Headings**: `<h1>` through `<h6>` map to `#` through `######`
- **Bold**: `<span>` with class containing `font-weight:700` in the stylesheet
- **Italic**: `<span>` with class containing `font-style:italic`
- **Inline code**: `<span>` with font-family containing "Mono" (e.g. "Roboto Mono")
- **Links**: `<a>` tags, but URLs are wrapped in Google redirects like `https://www.google.com/url?q=ACTUAL_URL&sa=D&...`, extract the real URL from the `q` parameter
- **Unordered lists**: `<ul>` with `<li>` children. Nesting level is encoded in CSS class names like `lst-kix_xxx-0` (level 0), `lst-kix_xxx-1` (level 1), etc.
- **Ordered lists**: `<ol>` with `<li>` children
- **Blockquotes**: Paragraphs with significant `margin-left` in their CSS class (e.g. 30pt+), render as `>`
- **Horizontal rules**: `<hr>` maps to `---`
- **Empty paragraphs**: `<p>` with only empty `<span>` children, skip these
- **Code blocks**: Consecutive paragraphs in monospace font, group them into fenced code blocks

#### Image extraction

Images in Google Docs HTML exports are embedded as base64 data URIs:

```html
<img src="data:image/png;base64,iVBOR..." style="width: 558px; height: 520px; ...">
```

For each `<img>` tag with a `data:image/{type};base64,{data}` src:

1. Assign a sequential filename: `image-1.png`, `image-2.png`, etc. (use the mime type for the extension)
2. Collect the base64 data for later saving
3. Replace the `<img>` tag in the markdown with `![](images/image-N.ext)`

Use `evaluate_script` to extract images separately since base64 data can be very large:

```js
() => {
  const html = window.__gdocHtml;
  const imgs = [...html.matchAll(/<img[^>]*src="data:image\/(\w+);base64,([^"]+)"[^>]*>/gi)];
  window.__gdocImages = imgs.map((m, i) => ({
    filename: `image-${i + 1}.${m[1]}`,
    base64: m[2]
  }));
  return { count: imgs.length, filenames: window.__gdocImages.map(i => i.filename) };
}
```

Then retrieve each image's base64 data individually:

```js
(idx) => window.__gdocImages[idx].base64
```

If the base64 string is too large for evaluate_script, retrieve it in chunks via substring and concatenate.

### 5. Save files

Create a folder structure based on the document title:

```
{kebab-title}/
  index.md          # first tab (or only tab)
  {kebab-tab-name}.md  # additional tabs (if multi-tab)
  images/
    image-1.png
    image-2.png
```

#### Folder and filenames

- Convert the document title to kebab-case for the folder name (lowercase, spaces/special chars to hyphens, collapse multiple hyphens)
- **Single tab**: save as `{folder}/index.md`
- **Multiple tabs**: first tab is `{folder}/index.md`, additional tabs are `{folder}/{kebab-tab-name}.md`
- Each markdown file starts with `<!-- source: {original_url_with_tab} -->`

#### Images

Save images to `{folder}/images/` (shared across all tabs, with per-tab prefixing if needed to avoid collisions). Decode base64 to binary:

```bash
echo '{base64_data}' | base64 -d > {folder}/images/image-1.png
```

If the base64 string is too large for a single shell command, write it to a temp file first:

```bash
# Write base64 to temp file, then decode
base64 -d < /tmp/gdoc-img.b64 > {folder}/images/image-1.png
```

#### Output

Tell the user:
- The folder name created
- Number of tabs exported (and their filenames if multiple)
- Number of images saved

## Important

- If the HTML is too large for a single evaluate_script response, store it on `window` and retrieve in chunks.
- Strip all CSS classes and style information from the output, produce only clean standard Markdown.
- Strip Google Doc comment annotations (e.g. `[[a]]`, `[[b]]` links and their footnote text at the end).
- Clean up HTML entities (`&nbsp;`, `&amp;`, `&uuml;`, etc.) to their Unicode equivalents.
- Do not bold headings redundantly (headings are already emphasized by `#` markers).
