EAPI=8

inherit cargo

DESCRIPTION="COSMIC OSD"
HOMEPAGE="https://github.com/pop-os/cosmic-osd"

COMMIT="dc4df2c006434ffce0f69960adf30ed1ec9a1d75"
SRC_URI="
	https://github.com/pop-os/cosmic-osd/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
BSD-2 Boost-1.0 CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/libpulse
	virtual/udev
	x11-libs/libxkbcommon
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	export POLKIT_AGENT_HELPER_1=/usr/lib/polkit-1/polkit-agent-helper-1
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_install() {
	dobin target/release/cosmic-osd
}
