# Development

## Vendor dependencies for release

```sh
cargo vendor | head -n -0 > config
XZ_OPT='-T0 -9' tar -acf cosmic-session-0_pre20240717-vendor.tar.xz vendor config
```

## Useful links

- [Writing Rust ebuilds](https://wiki.gentoo.org/wiki/Writing_Rust_ebuilds)
- [cargo.eclass](https://devmanual.gentoo.org/eclass-reference/cargo.eclass/index.html)

