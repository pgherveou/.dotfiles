---
name: dotli-signing-bot
description: Pair a dotli Polkadot Mobile QR/deeplink payload through the Nova signing bot. Use when the user provides a JSON object containing qrPayload, a raw polkadotapp://pair?handshake=... deeplink, or asks Codex to sign in / pair a dotli QR with signer-bot.
---

# Dotli Signing Bot

## Workflow

Use `scripts/pair.mjs` to submit a dotli QR payload to the signing bot.

If the user does not provide a QR payload, ask them to open dotli, click sign in, wait for the QR code, then run this in the browser console:

```js
copy(document.querySelector("#auth-modal-qr canvas").dataset.qrPayload)
```

Then ask them to paste the copied payload.

## Run

Accept any of these input shapes:

```json
{"qrPayload":"polkadotapp://pair?handshake=..."}
```

```json
{"handshake":"polkadotapp://pair?handshake=...","username":"dotlitestsabcxyz"}
```

```text
polkadotapp://pair?handshake=...
```

Run from the repo or worktree that has `.env`, or with signer-bot env vars already set:

```bash
node /home/pg/.codex/skills/dotli-signing-bot/scripts/pair.mjs '{"qrPayload":"polkadotapp://pair?handshake=..."}'
```

The script reads:

- `SIGNER_BOT_SVC_TOKEN` from env or nearest `.env` found by walking up from the current directory.
- `SIGNER_BOT_BASE_URL`, defaulting to `https://signing-bot-dev.novasama-tech.org/`.
- `SIGNER_BOT_NETWORK`, defaulting to `paseo-next-v2`.

When the user asks to test with the "local signing bot", use the Docker signer
from `/home/pg/github/signing-bot/`. Prefer an already-running
`http://localhost:3737/` bot if healthy; otherwise start it from that repo with
`docker compose up -d`. For TrUAPI/dotli e2e runs, set
`SIGNER_BOT_BASE_URL=http://localhost:3737/`, `SIGNER_BOT_SVC_TOKEN=admin`
unless the user/env overrides it, and `SIGNER_BOT_NETWORK=paseo-next-v2`.
If the 3737 signer fails with live-chain slot exhaustion such as
`no free statement-store slot for device registration`, treat that as local
signer state. To continue diagnosing runtime regressions, use an already
running fresh local signer such as `http://localhost:3747/` when available and
report that this is a fallback from the default local bot.

The script prints a copy-pasteable multiline curl request before submitting. The curl must use shell line-continuation backslashes and keep the bearer token as `${SIGNER_BOT_SVC_TOKEN}`; never print the actual token.

The script output includes `httpStatus` and `rawJsonResponse`, which is the parsed JSON response body returned by the signer-bot endpoint.

Do not print secrets. Report the sanitized result: curl request, HTTP status, raw JSON response, username, network, address/public key, session id prefix, and elapsed time.
