// Path helpers shared by tmuxx subcommands.

// shortenPath abbreviates some paths like my shell prompt does.
export function shortenPath(path) {
  const home = process.env.HOME;
  if (!home) return path;

  const github = `${home}/ghq/src/github.com`;
  if (path === github || path.startsWith(`${github}/`)) {
    return `~github${path.slice(github.length)}`;
  }
  return path.startsWith(home) ? path.replace(home, "~") : path;
}
