// A best-effort file logger shared by all hook modules.

import fs from "node:fs";

// Use the Sweden locale to print a timestamp with ISO8601-like format.
const dtFormat = new Intl.DateTimeFormat("sv-SE", {
  timeZone: "Asia/Tokyo",
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
});

let logPath = null;

/** Set the log file path. Until this is called, log is a no-op. */
export function configureLog(path) {
  logPath = path;
}

/** Append a line of text to the log file. Never throws (logging must not break the hook). */
export function log(value) {
  const text = String(value || "").trim();
  if (!text || !logPath) return;
  try {
    fs.appendFileSync(logPath, `[${dtFormat.format(new Date())}] ${text}\n`);
  } catch {
    // ignore
  }
}
