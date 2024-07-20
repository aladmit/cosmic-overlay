EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC Notifications"
HOMEPAGE="https://github.com/pop-os/cosmic-notifications"

COMMIT="4a79052f46d88b9843ca68bb1d59fc27369d22a0"
SRC_URI="
	https://github.com/pop-os/cosmic-notifications/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/wayland
	dev-util/intltool
	dev-util/pkgconf
	x11-libs/libxkbcommon
"

IDEPEND="dev-build/just"

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure
}

src_compile() {
	cargo_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	just prefix="${D}/usr" install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
