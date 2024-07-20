EAPI=8

inherit cargo xdg

DESCRIPTION="Applets for COSMIC panel"
HOMEPAGE="https://github.com/pop-os/cosmic-applets"

COMMIT="f154c16df9695a0a39fb64e795f0e6e200f0034b"
SRC_URI="
	https://github.com/pop-os/cosmic-applets/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0
CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="amd64 arm64"

COMMON_DEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon
	virtual/udev
"

RDEPEND="${COMMON_DEPEND}
	cosmic-base/cosmic-icons
"

BDEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.75.0
	dev-build/just
	dev-libs/libinput
	dev-util/pkgconf
	media-libs/libpulse
	sys-apps/dbus
"

PATCHES=( "${FILESDIR}/${PN}-${PV}-just.patch" )

S="${WORKDIR}/${PN}-${COMMIT}"
ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack

	# rename dir because it has typo
	mv "${S}/cosmic-applet-status-area/data/icons/scalable/app" \
		"${S}/cosmic-applet-status-area/data/icons/scalable/apps" || die
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
