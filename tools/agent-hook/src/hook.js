// The common driver of hook entry points.

import fs from "node:fs";
import { configureLog, log } from "./log.js";

/**
 * Read a hook event as JSON from stdin and pass it to `handle`.
 * On any error, log it and exit with 1 so that the agent reports the hook failure.
 */
export async function runHook({ logPath, handle }) {
  configureLog(logPath);
  try {
    const json = fs.readFileSync(0, "utf8");
    const input = JSON.parse(json);
    log(`============ hook start: ${input.hook_event_name} ${json}`);
    await handle(input);
  } catch (err) {
    log(`fatal: ${err.stack || err.message}`);
    console.error(err.message);
    process.exit(1);
  }
}
