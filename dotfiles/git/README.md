# Manual Setups Related to Git / GitHub

## Set up SSH key

Follow the GitHub instructions:
<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>

## Set up GPG key

### Import key

1. Get my private key from somewhere
2. `gpg --import private.key`
3. Trust my key ultimately: <https://unix.stackexchange.com/a/407070>
   1. `gpg --edit-key ryym.64@gmail.com`
   1. `> trust`
   1. Select `5 = I trust ultimately`

### Export key

1.  `gpg --list-secret-keys ryym.64@gmail.com`
2.  `gpg --export-secret-keys ID > private.key`

(ref: <https://makandracards.com/makandra-orga/37763-gpg-private-key-export-quick-guide>)
