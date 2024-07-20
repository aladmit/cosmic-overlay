EAPI=8

inherit cargo xdg

DESCRIPTION="Settings application for the COSMIC desktop environment"
HOMEPAGE="https://github.com/pop-os/cosmic-settings"

COMMIT="a8bf840ace00dd010b83ddead6cd2338e9408730"
SRC_URI="
	https://github.com/pop-os/cosmic-settings/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
#deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 NCSA
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

RDEPEND="
	app-text/iso-codes
	cosmic-base/cosmic-randr
	sys-apps/accountsservice
	sys-devel/gettext
"

# add use mold
# sys-devel/mold
BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/expat
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/fontconfig
	media-libs/freetype
	virtual/udev
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
