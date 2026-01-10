# Working Guidelines

## Communication

If the instructions contain contradictions or you believe they won't work as directed, please clearly point out these issues.

## Temporary Files

Unless otherwise specified, store temporary files like oneshot scripts, memo for yourself, etc, in the `.local/tmp` directory.
The `.local` directory is excluded from Git so you don't need to commit it.

## Documentation

When you write documents, store them in the `.local/claude` directory.
For example, you create a markdown document when instructed to investigate something and summarize results.

### Format

- A file name should be English in kebab-case like `.local/claude/research-result-of-something.md`.
- For markdown, run `prettier --ignore-path /dev/null --write <filepath>` after writing the file to format it.

### Version control

The `.local/claude` directory itself is managed by Git without a remote repository.
Whenever you create, update, or delete a file in it, you must commit it to Git.

## Git Usage

When working on development in a directory with `.git/`,
you MUST run `git commit` after completing each discrete step of work.
Do not wait to accumulate multiple changes.

### Commit Granularity

Commit changes in appropriate, focused chunks. Avoid large commits that mix multiple concerns.
If your commit message contains several sentences like "Create User model and add login page",
it is a sign that your commit is too big.
In this case, you should separate it into 2 commits like "Create User model" and "Add login page".

Each commit should:

- Have a single responsibility
- Be reviewable on its own
- Have a clear commit message explaining the changes

Also, all tests should pass at each commit. Do NOT commit incomplete work.

### Commit Messages

- Title: Concisely describe what was done
- Body: Include decision-making context and complex implementation details that aren't obvious from the code diff
- Language: English
