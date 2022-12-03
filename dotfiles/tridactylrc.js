// see :help js

tri.browserBg.runtime.getPlatformInfo().then(os => {
  // Adjust keybindings for Linux based on my Xremap configuration.
  // Currently I am a macOS user so I want to:
  //   - use Super (Command / Win) key for basic shortcuts such as copy paste.
  //   - use Ctrl key for moving cursor on input such as Ctrl-f/b that moves cursor left/right.
  // To achieve that, I use Xremap to customize key input (except on Terminal). For example:
  //   - remap Ctrl-f to Arrow-left, Ctrl-b to Arrow-right, etc.
  //   - remap Super-c to Ctrl-c, Super-f to Ctrl-f, etc.
  //   - (I cannot just remap Super to Ctrl since it breaks Super+Tab behavior)
  // Therefore, I need to make Tridactyl handle keys remapped by Xremap.
  if (os.os === 'linux') {
    tri.excmds.bind('<ArrowRight>', 'scrollpage 1') // <C-f>
    tri.excmds.bind('<ArrowLeft>', 'scrollpage -1') // <C-b>
    tri.excmds.bind('<Del>', 'scrollline -20') // <C-k>

    // Prevent Tridactyl from consuming <C-f> to use native Browser's page search.
    tri.excmds.unbind('<C-f>')
  }
});
