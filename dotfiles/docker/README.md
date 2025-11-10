# Useful configurations of Docker

## Enable to use Ctrl-p in interactive shell

<https://docs.docker.com/reference/cli/docker/#default-key-sequence-to-detach-from-containers>

> Once attached to a container, users detach from it and leave it running using the using CTRL-p CTRL-q key sequence.
> This detach key sequence is customizable using the detachKeys property. Specify a `<sequence>` value for the property.

Docker uses Ctrl-p as a prefix of key binding for detaching. But Ctrl-p is a command to scroll up the command history.
Therefore, this default key binding is annoying when you run an interactive shell in Docker.

```shell
docker run --rm it some-container bash
> # In Docker, Ctrl-p does not work as usual.
```

To use Ctrl-p, we can change the key binding by editing `~/.docker/config.json`.

```json
{
  "detachKeys": "ctrl-@"
}
```
