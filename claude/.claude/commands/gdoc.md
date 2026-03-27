---
argument-hint: [google doc url]
description: Export a Google Doc to a clean Markdown file. Use when the user says "convert this google doc", "export google doc to markdown", or provides a Google Docs URL to convert. Requires Chromium running with --remote-debugging-port=9222 and the Chrome DevTools MCP plugin.
---

Convert a Google Doc to Markdown and save it to the current directory.

## Input

The argument is a Google Docs URL: `$ARGUMENTS`

If no URL is provided, get it from the currently active tab using `evaluate_script` to read `window.location.href`. Confirm it's a Google Docs URL before proceeding.

## Steps

### 1. Extract the document ID

Parse the doc ID from the URL pattern: `docs.google.com/document/d/{DOC_ID}/...`

### 2. Fetch HTML export and title

Use a single `evaluate_script` call on whatever page is currently active (do NOT navigate away from the user's tab):

```js
async () => {
  const docId = 'THE_DOC_ID';
  const [htmlResp, metaResp] = await Promise.all([
    fetch(`https://docs.google.com/document/d/${docId}/export?format=html`, { credentials: 'include' }),
    fetch(`https://docs.google.com/document/d/${docId}`, { credentials: 'include' })
  ]);
  const html = await htmlResp.text();
  const meta = await metaResp.text();
  const titleMatch = meta.match(/<title>([^<]+)<\/title>/);
  const title = titleMatch ? titleMatch[1].replace(' - Google Docs', '').trim() : null;
  return { html, title, status: htmlResp.status };
}
```

If the fetch fails (status != 200), tell the user. Common causes: not logged in, doc not shared with them, or Chromium not running with debug port.

### 3. Convert HTML to Markdown

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

### 4. Save the file

- Convert the document title to kebab-case for the filename (lowercase, spaces/special chars to hyphens, collapse multiple hyphens)
- Add `<!-- source: {original_url} -->` as first line
- Add blank line then the markdown content
- Save as `{kebab-title}.md` in the current working directory
- Tell the user the filename

## Important

- NEVER navigate away from the user's current tab. The fetch works from any page with Google cookies.
- If the HTML is too large for a single evaluate_script response, fetch in chunks or fetch just the `<body>` content.
- Strip all CSS classes and style information from the output, produce only clean standard Markdown.
