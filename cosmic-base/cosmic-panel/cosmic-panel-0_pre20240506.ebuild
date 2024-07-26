EAPI=8

inherit cargo

DESCRIPTION="COSMIC Panel"
HOMEPAGE="https://github.com/pop-os/cosmic-panel"

COMMIT="683a204ef81bd17c2b35264521e5145df3518ee5"
SRC_URI="
	https://github.com/pop-os/cosmic-panel/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016
Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

COMMON_DEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon
"

RDEPEND="${COMMON_DEPEND}"

BDEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.70.0
	dev-libs/libinput
	dev-util/desktop-file-utils
	dev-util/pkgconf
	media-libs/fontconfig
	media-libs/mesa[wayland]
	sys-apps/systemd
	sys-auth/seatd
	virtual/udev
	x11-libs/libxcb
	x11-libs/pixman
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

src_install() {
	just prefix="${D}/usr" install
}
