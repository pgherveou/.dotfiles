# Vendored from github/gh-stack

`SKILL.md` in this directory is vendored verbatim from
https://github.com/github/gh-stack at version `0.0.4` (see the `metadata.version`
field in the file's frontmatter).

It is bundled here so that `/split-pr` and `/restack-pr` can rely on the gh-stack
skill being available without requiring a separate install step. To refresh
against upstream, re-download the file:

```sh
gh api -H "Accept: application/vnd.github.raw" \
  repos/github/gh-stack/contents/skills/gh-stack/SKILL.md \
  > skills/gh-stack/SKILL.md
```

## License

Vendored under the MIT License.

```
Copyright GitHub, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
