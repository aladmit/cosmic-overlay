# cosmic-overlay

[Gentoo](https://gentoo.org) overlay with next generation 
[COSMIC DE](https://blog.system76.com/tags/COSMIC%20DE). This DE is in
**beta**, but already usable for daily driving.

> [!CAUTION]
> Overlay supports only **systemd** profiles. Contributions are welcome!

## Install

### Add and sync overlay

```bash
eselect repository add cosmic-overlay git https://github.com/aladmit/cosmic-overlay.git
emaint sync -r cosmic-overlay
```

### Install COSMIC DE

Ebuilds follow releases from [cosmic-epoch](https://github.com/pop-os/cosmic-epoch)

```bash
emerge -av cosmic-base/cosmic
```

After installation COSMIC should be available to choose in you login
manager(**Wayland only**).

### COSMIC login manager

COSMIC has it's own login manager `cosmic-greeter` working on top of `greetd`.
Disable all other login managers like GDM and enable cosmic-greeter.

```sh
systemctl enable cosmic-greeter-daemon
systemctl enable cosmic-greeter
```

## Known issues

### Flatpak apps can't open files and directories

Issue: [xdg-desktop-portal-cosmic#102](https://github.com/pop-os/xdg-desktop-portal-cosmic/issues/102)

XDG portal doesn't support `org.freedesktop.portal.OpenURI` interface. Install
gtk and nautilus as a fallback.

```sh
sudo emerge -av sys-apps/xdg-desktop-portal-gtk gnome-base/nautilus
```

### No icons in Files

Issue: [cosmic-files#61](https://github.com/pop-os/cosmic-files/issues/61)

It happens when cosmic renders using `opengl/gles`. Force vulkan render by
setting systemd-wide environment variable.

`/etc/env.d/99local`

```
WGPU_BACKEND=vulkan
```

Then run `sudo env-update` and restart cosmic.
