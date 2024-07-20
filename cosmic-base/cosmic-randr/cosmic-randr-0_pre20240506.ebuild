EAPI=8

inherit cargo

DESCRIPTION="Display and configure wayland display outputs"
HOMEPAGE="https://github.com/pop-os/cosmic-randr"

COMMIT="88c570cf8b88beae1cf4f3e2d412cc64ec49cd7c"
SRC_URI="
	https://github.com/pop-os/cosmic-randr/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

# TODO: add optional mold
BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/wayland
	dev-util/pkgconf
"

IDEPEND="dev-build/just"

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_install() {
	just prefix="${D}/usr" install
}
