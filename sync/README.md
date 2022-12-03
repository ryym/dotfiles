# Installers

The install scripts is in this directory.

## Directories

### os/

This directory contains the installers for each supported OS. These files
use other install scripts in `pkgs/` or `env/`.

### pkgs/

This directory contains the installers which install some basic tools
via a package manager that are usually used in the supported OSs.

### env/

This directory contains the installers of language version managers like [rbenv].
All manager tools themselves are managed by [anyenv].

[rbenv]: https://github.com/rbenv/rbenv
[anyenv]: https://github.com/riywo/anyenv
