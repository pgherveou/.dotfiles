#!/usr/bin/env node
import { existsSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const DEFAULT_BASE_URL = "https://signing-bot-dev.novasama-tech.org/";
const DEFAULT_NETWORK = "paseo-next-v2";
const REQUEST_TIMEOUT_MS = 120_000;

function usage(exitCode = 1) {
  const script = fileURLToPath(import.meta.url);
  console.error(`Usage:
  node ${script} '{"qrPayload":"polkadotapp://pair?handshake=..."}'
  echo '{"qrPayload":"polkadotapp://pair?handshake=..."}' | node ${script}
  QRPAYLOAD='polkadotapp://pair?handshake=...' node ${script}

Options:
  --username <name>     Optional bot username. Defaults to dotlitests + random letters.
  --network <id>        Defaults to SIGNER_BOT_NETWORK or ${DEFAULT_NETWORK}.
  --base-url <url>      Defaults to SIGNER_BOT_BASE_URL or ${DEFAULT_BASE_URL}.
  --env-file <path>     Optional .env path. Defaults to nearest .env above cwd.
`);
  process.exit(exitCode);
}

function parseArgs(argv) {
  const options = {};
  const positional = [];
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--help" || arg === "-h") usage(0);
    if (arg === "--username") {
      options.username = requireValue(argv, ++i, arg);
    } else if (arg === "--network") {
      options.network = requireValue(argv, ++i, arg);
    } else if (arg === "--base-url") {
      options.baseUrl = requireValue(argv, ++i, arg);
    } else if (arg === "--env-file") {
      options.envFile = requireValue(argv, ++i, arg);
    } else if (arg.startsWith("--")) {
      throw new Error(`Unknown option: ${arg}`);
    } else {
      positional.push(arg);
    }
  }
  return { options, positional };
}

function requireValue(argv, index, flag) {
  const value = argv[index];
  if (!value || value.startsWith("--")) {
    throw new Error(`${flag} requires a value`);
  }
  return value;
}

function readStdinIfPiped() {
  if (process.stdin.isTTY) return "";
  return readFileSync(0, "utf8").trim();
}

function findNearestEnv(startDir) {
  let dir = resolve(startDir);
  while (true) {
    const candidate = join(dir, ".env");
    if (existsSync(candidate)) return candidate;
    const parent = dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

function loadEnvFile(path) {
  if (!path || !existsSync(path)) return;
  const content = readFileSync(path, "utf8");
  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const match = /^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/.exec(line);
    if (!match) continue;
    const [, key, rawValue] = match;
    if (process.env[key] !== undefined) continue;
    process.env[key] = unquoteEnv(rawValue.trim());
  }
}

function unquoteEnv(value) {
  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    return value.slice(1, -1);
  }
  return value;
}

function parseInput(raw) {
  const input = raw.trim();
  if (!input) return {};
  if (input.startsWith("{")) return JSON.parse(input);
  return { qrPayload: input };
}

function generateUsername() {
  const alphabet = "abcdefghijklmnopqrstuvwxyz";
  let suffix = "";
  for (let i = 0; i < 6; i++) {
    suffix += alphabet[Math.floor(Math.random() * alphabet.length)];
  }
  return `dotlitests${suffix}`;
}

function assertPairPayload(value) {
  if (typeof value !== "string" || value.length === 0) {
    throw new Error("Missing qrPayload. Expected polkadotapp://pair?handshake=...");
  }
  if (!value.includes("://pair?handshake=")) {
    throw new Error(`Invalid pairing payload: ${value.slice(0, 80)}`);
  }
  return value;
}

function shellQuote(value) {
  const text = String(value);
  if (text.length === 0) return "''";
  return `'${text.replace(/'/g, "'\\''")}'`;
}

function buildCurlCommand(url, body) {
  return [
    `curl -sS -X POST ${shellQuote(url)}`,
    '-H "Authorization: Bearer ${SIGNER_BOT_SVC_TOKEN}"',
    "-H 'Content-Type: application/json'",
    "-H 'Accept: application/json'",
    `--data-raw ${shellQuote(JSON.stringify(body))}`,
  ].join(" \\\n  ");
}

function parseJsonOrNull(text) {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}

class PairResponseError extends Error {
  constructor(status, statusText, rawTextResponse, rawJsonResponse) {
    super(`pair ${status}: ${rawTextResponse.slice(0, 1000)}`);
    this.name = "PairResponseError";
    this.status = status;
    this.statusText = statusText;
    this.rawTextResponse = rawTextResponse;
    this.rawJsonResponse = rawJsonResponse;
  }
}

async function postJsonWithTimeout(url, token, body) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);
  try {
    const response = await fetch(url, {
      method: "POST",
      signal: controller.signal,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify(body),
    });
    const text = await response.text();
    const rawJsonResponse = parseJsonOrNull(text);
    if (!response.ok) {
      throw new PairResponseError(response.status, response.statusText, text, rawJsonResponse);
    }
    if (rawJsonResponse === null) {
      throw new PairResponseError(response.status, response.statusText, text, null);
    }
    return {
      httpStatus: response.status,
      rawJsonResponse,
    };
  } finally {
    clearTimeout(timer);
  }
}

function sanitizedResult(response, requestedUsername, elapsedMs, requestCurl) {
  const result = response.rawJsonResponse;
  return {
    ok: true,
    requestCurl,
    httpStatus: response.httpStatus,
    rawJsonResponse: response.rawJsonResponse,
    elapsedMs,
    requestedUsername,
    sessionIdPrefix: String(result.sessionId ?? "").slice(0, 16),
    user: result.user
      ? {
          username: result.user.username,
          network: result.user.network,
          address: result.user.address,
          publicKeyHex: result.user.publicKeyHex,
          attested: result.user.attested,
        }
      : null,
  };
}

let requestCurl;

try {
  const { options, positional } = parseArgs(process.argv.slice(2));
  loadEnvFile(options.envFile ? resolve(options.envFile) : findNearestEnv(process.cwd()));

  const rawInput = positional.join(" ") || process.env.QRPAYLOAD || readStdinIfPiped();
  const input = parseInput(rawInput);
  const handshake = assertPairPayload(input.qrPayload ?? input.handshake);
  const username = options.username ?? input.username ?? generateUsername();
  const network = options.network ?? input.network ?? process.env.SIGNER_BOT_NETWORK ?? DEFAULT_NETWORK;
  const baseUrl = options.baseUrl ?? process.env.SIGNER_BOT_BASE_URL ?? DEFAULT_BASE_URL;
  const token = process.env.SIGNER_BOT_SVC_TOKEN;
  if (!token) {
    throw new Error("SIGNER_BOT_SVC_TOKEN is not set in env or nearest .env");
  }

  const url = `${baseUrl.replace(/\/$/, "")}/api/pair`;
  const body = {
    handshake,
    username,
    network,
  };
  requestCurl = buildCurlCommand(url, body);
  console.error(`[dotli-signing-bot] curl:\n${requestCurl}`);

  const started = Date.now();
  const response = await postJsonWithTimeout(url, token, body);
  console.log(JSON.stringify(sanitizedResult(response, username, Date.now() - started, requestCurl), null, 2));
} catch (error) {
  const failure = { ok: false, error: error.message };
  if (requestCurl) failure.requestCurl = requestCurl;
  if (error instanceof PairResponseError) {
    failure.httpStatus = error.status;
    failure.rawJsonResponse = error.rawJsonResponse;
    if (error.rawJsonResponse === null) {
      failure.rawTextResponse = error.rawTextResponse;
    }
  }
  console.error(JSON.stringify(failure, null, 2));
  process.exit(1);
}
