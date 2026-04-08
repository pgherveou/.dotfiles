---
argument-hint: <file.md> [--force]
description: Push a local Markdown file to Google Docs. By default creates a NEW document. If the file has a source link to an existing Google Doc, the user MUST be prompted for confirmation before updating (updating overwrites the remote document). Only skip the confirmation if --force is explicitly passed. Use when the user says "push to google docs", "create google doc from markdown", "upload markdown to gdoc", "sync markdown to google docs", or wants to convert a .md file into a Google Doc. This is the inverse of /gdoc. Requires a Chromium-based browser (Brave, Chrome) running with --remote-debugging-port=9222 and the Chrome DevTools MCP plugin.
---

Push a local Markdown file to Google Docs. Creates a new document by default, or updates an existing one if the file has a source link.

## Input

The argument is a file path and optional flags: `$ARGUMENTS`

Parse the arguments:
- `<file.md>` - path to the markdown file (required)
- `--force` - skip confirmation when updating an existing document (optional)

If no file path is provided, ask the user which file to push.

## Steps

### 1. Read the markdown file and check for source link

Read the markdown file. Check if the first line is a source comment:

```
<!-- source: https://docs.google.com/document/d/{DOC_ID}/... -->
```

If a source URL is found:
- Extract the document ID from the URL pattern `docs.google.com/document/d/{DOC_ID}/`
- If `--force` is NOT in the arguments, ask the user: "This file has a source link to an existing Google Doc. Update that document, or create a new one?"
- If the user chooses to create new, proceed as if there's no source link
- If `--force` IS present, proceed directly to update the existing document

Strip the source comment line from the content before conversion (it's metadata, not document content).

### 2. Determine the document title

1. Look for the first `# Heading` in the markdown (after stripping the source comment)
2. If no H1 found, use the filename without extension (e.g., `my-doc.md` -> `my-doc`)

### 3. Process local images

Find all image references in the markdown: `![alt](path)`

For each image with a **local** file path (not http/https URLs or data URIs):
1. Resolve the path relative to the markdown file's directory
2. Base64-encode the image:
   ```bash
   base64 < /resolved/path/to/image.png
   ```
3. Determine MIME type from extension: png, jpg/jpeg, gif, webp, svg+xml
4. Replace the path in the markdown with `data:image/{mime};base64,{data}`

Skip images that are already URLs or data URIs.

### 4. Convert Markdown to HTML

Open a Google page in the browser. Use `list_pages` to find an already-open Google tab (docs.google.com or drive.google.com). If none, use `navigate_page` to open `https://docs.google.com`. Then `select_page` on it.

Store the processed markdown on the page. Use JSON encoding to safely handle special characters:

```js
(() => {
  window.__gpushMd = JSON.parse('THE_JSON_STRINGIFIED_MARKDOWN');
})()
```

Replace `THE_JSON_STRINGIFIED_MARKDOWN` with the actual JSON.stringify'd markdown content (with images already replaced by data URIs and source comment stripped).

Convert markdown to HTML inline (do NOT use external libraries like `marked`, Google pages block them via CSP):

```js
() => {
  let html = window.__gpushMd;

  // Code blocks first (before other transforms)
  html = html.replace(/```(\w*)\n([\s\S]*?)```/g, (m, lang, code) => {
    return '<pre><code>' + code.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</code></pre>';
  });

  // Headings
  html = html.replace(/^###### (.+)$/gm, '<h6>$1</h6>');
  html = html.replace(/^##### (.+)$/gm, '<h5>$1</h5>');
  html = html.replace(/^#### (.+)$/gm, '<h4>$1</h4>');
  html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
  html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
  html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');

  // Bold and italic
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');

  // Inline code
  html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

  // Links
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

  // Images
  html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img alt="$1" src="$2">');

  // Blockquotes
  html = html.replace(/^> (.+)$/gm, '<blockquote>$1</blockquote>');

  // Horizontal rules
  html = html.replace(/^---$/gm, '<hr>');

  // List items
  html = html.replace(/^- (.+)$/gm, '<li>$1</li>');
  html = html.replace(/(<li>.*<\/li>\n?)+/g, '<ul>$&</ul>');

  // Ordered list items
  html = html.replace(/^\d+\. (.+)$/gm, '<li>$1</li>');

  // Paragraphs (lines not already wrapped in tags)
  html = html.replace(/^(?!<[hupbl]|<li|<\/|<blockquote|<hr|<img|<pre)(.+)$/gm, '<p>$1</p>');

  // Clean up extra newlines
  html = html.replace(/\n{2,}/g, '\n');

  window.__gpushHtml = `<html><head><meta charset="utf-8"><style>
    body { font-family: Arial, sans-serif; font-size: 11pt; line-height: 1.5; }
    code { font-family: 'Courier New', monospace; background-color: #f8f9fa; padding: 1px 4px; font-size: 0.9em; }
    pre { font-family: 'Courier New', monospace; background-color: #f8f9fa; padding: 12px; border: 1px solid #dadce0; white-space: pre-wrap; }
    pre code { padding: 0; background: none; }
    blockquote { border-left: 3px solid #dadce0; padding-left: 12px; margin-left: 1.5em; color: #5f6368; }
    table { border-collapse: collapse; }
    th, td { border: 1px solid #dadce0; padding: 8px; }
    th { background-color: #f8f9fa; font-weight: bold; }
    img { max-width: 100%; }
    hr { border: none; border-top: 1px solid #dadce0; }
    a { color: #1a73e8; }
  </style></head><body>${html}</body></html>`;

  return { length: window.__gpushHtml.length };
}
```

### 5. Authenticate via SAPISIDHASH

Google web apps authenticate API calls using the SAPISIDHASH scheme. Extract the token from the browser session:

```js
async () => {
  const cookies = document.cookie;
  let sapisid = null;

  // Try cookie variants
  for (const name of ['SAPISID', '__Secure-3PAPISID', '__Secure-1PAPISID']) {
    const m = cookies.match(new RegExp(name + '=([^;]+)'));
    if (m) { sapisid = m[1]; break; }
  }

  if (!sapisid) throw new Error('Not logged into Google in this browser.');

  const timestamp = Math.floor(Date.now() / 1000);
  const origin = 'https://docs.google.com';
  const input = `${timestamp} ${sapisid} ${origin}`;
  const buffer = await crypto.subtle.digest('SHA-1', new TextEncoder().encode(input));
  const hash = Array.from(new Uint8Array(buffer)).map(b => b.toString(16).padStart(2, '0')).join('');

  window.__gpushAuth = `SAPISIDHASH ${timestamp}_${hash}`;
  return { authenticated: true };
}
```

If this fails, tell the user to log into Google in the browser.

### 5b. Extract API key

Google web apps require an API key alongside the SAPISIDHASH. Extract it from the page source:

```js
async () => {
  const resp = await fetch(window.location.href, { credentials: 'include' });
  const text = await resp.text();
  const keyMatch = text.match(/"(AIza[^"]+)"/);
  if (!keyMatch) throw new Error('Could not find API key in page source.');
  window.__gpushApiKey = keyMatch[1];
  return { key: window.__gpushApiKey };
}
```

### 6. Upload to Google Drive

#### Creating a new document

```js
async () => {
  const title = TITLE_STRING;
  const html = window.__gpushHtml;
  const auth = window.__gpushAuth;
  const apiKey = window.__gpushApiKey;

  const metadata = {
    name: title,
    mimeType: 'application/vnd.google-apps.document'
  };

  const boundary = 'gpush_' + Date.now();
  const body = [
    '--' + boundary,
    'Content-Type: application/json; charset=UTF-8',
    '',
    JSON.stringify(metadata),
    '--' + boundary,
    'Content-Type: text/html; charset=UTF-8',
    '',
    html,
    '--' + boundary + '--'
  ].join('\r\n');

  const resp = await fetch(
    `https://clients6.google.com/upload/drive/v3/files?uploadType=multipart&fields=id,name,webViewLink&key=${apiKey}`,
    {
      method: 'POST',
      credentials: 'include',
      headers: {
        'Authorization': auth,
        'Content-Type': 'multipart/related; boundary=' + boundary,
        'X-Goog-AuthUser': '0'
      },
      body
    }
  );

  if (!resp.ok) {
    const err = await resp.text();
    throw new Error('Drive API error ' + resp.status + ': ' + err);
  }

  return await resp.json();
}
```

The response contains `{ id, name, webViewLink }`.

#### Updating an existing document

```js
async () => {
  const docId = DOC_ID_STRING;
  const html = window.__gpushHtml;
  const auth = window.__gpushAuth;
  const apiKey = window.__gpushApiKey;

  const resp = await fetch(
    `https://clients6.google.com/upload/drive/v3/files/${docId}?uploadType=media&fields=id,name,webViewLink&key=${apiKey}`,
    {
      method: 'PATCH',
      credentials: 'include',
      headers: {
        'Authorization': auth,
        'Content-Type': 'text/html; charset=UTF-8',
        'X-Goog-AuthUser': '0'
      },
      body: html
    }
  );

  if (!resp.ok) {
    const err = await resp.text();
    throw new Error('Drive API error ' + resp.status + ': ' + err);
  }

  return await resp.json();
}
```

### 7. Open the document and report

1. Use `navigate_page` to open the new document: `https://docs.google.com/document/d/{id}/edit`
2. Tell the user:
   - **New doc**: "Created Google Doc: {title}" and the URL
   - **Updated doc**: "Updated Google Doc: {title}" and the URL

## Handling large content

If the markdown or HTML is too large for a single `evaluate_script` call, pass it in chunks:

```js
window.__gpushMd = JSON.parse('CHUNK_1');
```
```js
window.__gpushMd += JSON.parse('CHUNK_2');
```

Same for the HTML upload: if `window.__gpushHtml` is very large, the fetch in step 6 handles it in-browser, so no chunking is needed for the upload itself.

## Important

- Use `clients6.google.com` (not `content.googleapis.com`) for the Drive API, as Brave and other privacy-focused browsers block cross-origin cookies to `content.googleapis.com`.
- The API key (extracted from the Google Docs page source in step 5b) must be included as a `key=` query parameter.
- When updating a document, only content changes. Sharing settings, comments, and version history are preserved.
- If the Drive API returns 401/403, the SAPISIDHASH token may have expired. Re-run the auth step (step 5) and retry.
- Strip the `<!-- source: ... -->` comment before converting, so it does not appear in the Google Doc.
- Do NOT load external JS libraries (like `marked`) via script tags. Google pages enforce strict CSP that blocks them. Use the inline converter in step 4.
