# Karabiner-Elements configurations

I use Karabiner-Elements for two purposes:

- Complement the JIS keyboard behavior when it is recognized as a US layout
- Enhance the US keyboard

My main keyboards are these:

- MacBook keyboard (JIS layout that is recognized as US layout)
- [Dygma Raise 2][dygma-raise-2] (US layout)

Karabiner (or [Xremap][xremap] on Linux) is important to ensure that both keyboards provide the same typing experience.

[xremap]: ../xremap/README.md

## Complement the JIS keyboard behavior when it is recognized as a US layout

I use a JIS-layout MacBook when working on the go. While I slightly prefer US layouts over JIS,
I've stuck with JIS for years due to the extra keys it offers.

- An underscore key. I really like it because the underscore is frequently used in programming.
- Two IME (language) switch keys on either side of the Space bar.
  Once you get used to this, you can't live without these keys anymore. Typing with your thumbs is so effortless,
  and I really feel it’s a waste that the space bar takes up so much room on a standard US keyboard.

On the other hand, the JIS layout has some downsides compared to the US layout. Examples:

- Weird keys for single and double quotes (`Shift-7` and `Shift-2` respectively).
- Shift is required to input `=` (`Shift-minus`).

The best way I've found so far is to use a JIS keyboard physically but have the PC recognize it as the US layout.
This way, I can enjoy the intuitive US key mapping while using additional physical keys of the JIS layout. This is nice.
But it makes the PC not recognize keys that exist only in JIS layout, so I remap them to their original JIS functions.

## Enhance the US keyboard

At home, I use a [Dygma Raise 2][dygma-raise-2].
It is the US layout but I love it because it splits the space bar into 4 keys.
It is a programmable keyboard so I can map those keys to IME switch keys or any other function.
That said, it still lacks some physical keys found on a standard JIS layout, and the built-in firmware has its limitations.
This is why I rely on software remappers like Karabiner-Elements.

[dygma-raise-2]: https://dygma.com/pages/dygma-raise-2
