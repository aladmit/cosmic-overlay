# cosmic-overlay

[Gentoo](https://gentoo.org) overlay with next generation 
[Cosmic DE](https://blog.system76.com/tags/COSMIC%20DE).

## Status

> [!WARNING]
> Experimental. Installed environment wouldn't be functions due to lack of
> ebuilds for all components.

## Install

### Add and sync overlay

```bash
eselect repository add cosmic-overlay git git@github.com:aladmit/cosmic-overlay.git
emaint sync -r cosmic-overlay
```

### Install cosmic DE

```bash
emerge -av cosmic-base/cosmic
```

