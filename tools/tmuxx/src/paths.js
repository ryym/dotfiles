// Path helpers shared by tmuxx subcommands.

// shortenPath abbreviates the home directory as `~`, like the shell prompt does.
export function shortenPath(path) {
  const home = process.env.HOME;
  return home && path.startsWith(home) ? path.replace(home, "~") : path;
}
