EAPI=8

inherit cargo

DESCRIPTION="COSMIC Panel"
HOMEPAGE="https://github.com/pop-os/cosmic-panel"

COMMIT="05420b20035cdb9f2fa52517e9c5abce9e0f0bb5"
SRC_URI="
	https://github.com/pop-os/cosmic-panel/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="~arm64 ~amd64"

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
	media-libs/mesa
	sys-apps/systemd
	sys-auth/seatd
	virtual/udev
	x11-libs/libxcb
	x11-libs/pixman
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config" "${CARGO_HOME}/" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install --path cosmic-panel-bin

	dodir /usr/share/cosmic
	insinto /usr/share/cosmic
	doins -r data/default_schema/*
}
