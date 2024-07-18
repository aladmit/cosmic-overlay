EAPI=8

inherit cargo

DESCRIPTION="Display and configure wayland display outputs"
HOMEPAGE="https://github.com/pop-os/cosmic-randr"

COMMIT="88c570cf8b88beae1cf4f3e2d412cc64ec49cd7c"
SRC_URI="
	https://github.com/pop-os/cosmic-randr/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions ISC
MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

# TODO: add optional mold
BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/wayland
	dev-util/pkgconf
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_install() {
	dobin target/release/cosmic-randr
}
