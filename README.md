# cosmic-overlay

Gentoo overlay with Cosmic DE

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

