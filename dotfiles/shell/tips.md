# Useful commands

### Remove old sub directories

```bash
# List sub directories which is not touched since the specified date.
fd --max-depth 1 --type d --changed-before "2023-01-01" . <target-dir>
#=>
# ./foo/
# ./bar/

# Remove all of them. You can exclude some of them with `-E`.
fd --max-depth 1 --type d --changed-before "2023-01-01" -E <exclude-pattern> . <target-dir> -X echo rm -rf
#=> echo rm -rf ./foo ./bar
```

### List and sort sub directories by size

```bash
du -d 0 -h . | sort -rh
```

### Remove duplicate lines without changing the original order

If there are multiple identical lines, it keeps the first line.

```bash
awk '!seen[$0]++' file.txt
cat file.txt | awk '!seen[$0]++'
```
