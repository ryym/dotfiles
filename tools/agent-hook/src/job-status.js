// Report this pane's job status (running/blocked/done) to the tmux status line
// via `tmuxx job-status`. Failures are only logged by `run`, never propagated.

import { run } from "./run.js";

export async function setPaneJobStatus(status) {
  await run("tmuxx", ["job-status", "set", status]);
}

export async function clearPaneJobStatus() {
  await run("tmuxx", ["job-status", "clear"]);
}
