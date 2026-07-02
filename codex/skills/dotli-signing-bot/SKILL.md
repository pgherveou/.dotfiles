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

Do not print secrets. Report the sanitized result: username, network, address/public key, session id prefix, and elapsed time.
