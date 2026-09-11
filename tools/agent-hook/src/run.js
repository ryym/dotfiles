// Helpers to run external commands with their output logged.

import { execFile as execFileCb } from "node:child_process";
import { promisify } from "node:util";
import { log } from "./log.js";

const execFile = promisify(execFileCb);

/** Run a command, with logging its stdout and stderr. Returns { code, stdout, stderr }; */
export async function run(file, args, options = {}) {
  try {
    log(`RUN: ${file} ${args.join(" ")}`);
    const { stdout, stderr } = await execFile(file, args, { encoding: "utf8", ...options });
    log(stdout);
    log(stderr);
    return { code: 0, stdout, stderr };
  } catch (err) {
    const stdout = err.stdout || "";
    const stderr = err.stderr || "";
    log(stdout);
    log(stderr);
    if (!stdout && !stderr) {
      log(err.message); // e.g. spawn failure (command not found)
    }
    // err.code is the exit code (number) or a spawn-error string such as "ENOENT".
    const code = typeof err.code === "number" ? err.code : 1;
    return { code, stdout, stderr };
  }
}

/** Run a git command (output auto-logged). Returns { code, stdout, stderr }. */
export function git(cwd, args) {
  return run("git", ["-C", cwd, ...args]);
}

/** Run a git command and return trimmed stdout, or null on failure. */
export async function gitOut(cwd, args) {
  const { code, stdout } = await git(cwd, args);
  return code === 0 ? stdout.trim() : null;
}

/** Run a git command for its side effect. Returns whether it succeeded. */
export async function gitRun(cwd, args) {
  return (await git(cwd, args)).code === 0;
}
