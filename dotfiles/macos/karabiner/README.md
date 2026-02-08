# Karabiner-Elements configurations

I use Karabiner-Elements for two purposes:

- 1. Restore some default JIS keyboard behaviors (e.g. `ろ` -> `_`)
- 2. Customize some default US keyboard behaviors (e.g. CapsLock -> Control)

As context, I use the following two keyboards everyday:

- Macbook keyboard (JIS layout)
- [Dygma Raise 2][dygma-raise-2] (US layout)

So it is important to me to keep their behaviors consistent.

## 1. Restore some default JIS keyboard behaviors

I use Macbook with a JIS layout keyboard when I'm out.
Although I slightly prefer the US layout than JIS, I have been using the JIS layout Macbook for years.
The reason is it has more keys than the US layout. Examples:

- An underscore key. I really like it because underscore is frequently used in programming.
- Two IME (language) switch keys on either side of the Space bar.
  Once you get used to this, you can't live without these keys anymore. Typing with your thumbs is so effortless,
  and I really feel it’s a waste that the space bar takes up so much room on a standard US keyboard.

On the other hand, the JIS layout has some downsides compared to the US layout. Examples:

- Weird keys for single and double quotes (`Shift-7` and `Shfit-2` respectively).
- Shift is required to emit `=` (`Shift-minus`).

The best way I've found so far is to use a JIS keyboard physically but have the PC recognize it as the US layout.
This way, I can enjoy the intuitive US key mapping while using additional physical keys of the JIS layout. This is nice.
But it makes the PC not recognize keys that exist only in JIS layout, so I remap them to their original JIS functions.

## 2. Customize some default US keyboard behaviors

At home, I use [Dygma Raise 2][dygma-raise-2].
It is the US layout but I love it because it splits the space bar into 4 keys.
It is a programmable keyboard so I can map those keys to IME switch keys or any arbitrary keys.
This is really nice but it sill lacks some physical keys that a standard JIS keyboard has.
And some remapping cannot be achieved with the keyboard's builtin remapping firmware.
Therefore I customize it with Karabiner-Elements.

[dygma-raise-2]: https://dygma.com/pages/dygma-raise-2
