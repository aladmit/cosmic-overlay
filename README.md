# cosmic-overlay

[Gentoo](https://gentoo.org) overlay with next generation 
[COSMIC DE](https://blog.system76.com/tags/COSMIC%20DE). This DE is in
**pre-alpha** stage, but already usable for daily driving.

**Overlay status**: stable ebuilds install functional DE with a few minor
issues. Installation was tested only on aarch64 platform, but should work on
amd64 too.

> [!CAUTION]
> Overlay supports only **systemd** profiles at the moment!

## Install

### Add and sync overlay

```bash
eselect repository add cosmic-overlay git git@github.com:aladmit/cosmic-overlay.git
emaint sync -r cosmic-overlay
```

### Install cosmic DE

Stable ebuilds(amd64, arm64) install version from [cosmic-epoch](https://github.com/pop-os/cosmic-epoch)
repo which I consider stable.

```bash
emerge -av cosmic-base/cosmic
```

