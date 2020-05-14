---
date: 2020-02-27 20:50
draft: true
---

# Shades of Grey

I’m maintaining [a fork of TextMate](https://github.com/peteschaffner/textmate), and it has [a beautiful default theme](https://github.com/peteschaffner/textmate/commit/63fd0315393506dcf3ca6c7c63b8f600dd9e20c3) that changes based on the system appearance (light/dark mode). I was inspired by Xcode’s default theme that does just this, but I wanted to push things a bit further.

+++

Dark mode on macOS is not so simple. Thanks to a technology Apple calls “[Desktop Tinting](https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/dark-mode/),” windows, bars and other UI elements take on a different dark tone based on what background wallpaper is set. For example, a blueish wallpaper will result in a cool grey, while a reddish produces a warm grey:

Maybe you can see where I’m going with this? I don’t want a static, dark theme—I want a dynamic one. That way, my text area feels at home next to the sidebar and titlebar. A picture says it better:

---

I also tweaked a few other things:

- The bottom toolbars meld with the text view and sidebar, which also makes it compete less [visually] with the title bar + tab strip.
- When a window loses key status, more of the UI fades out, making the window recede nicely.
- Custom, app-level key bindings take [precedence over bundle shortcuts](TODO).

