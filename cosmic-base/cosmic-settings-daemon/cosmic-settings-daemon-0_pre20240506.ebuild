EAPI=8

inherit cargo

DESCRIPTION="Cosmic settings daemon"
HOMEPAGE="https://github.com/pop-os/cosmic-settings-daemon"

COMMIT="bf2e505e450ab092010fa60ba75a6d9e9a8539f1"
SRC_URI="
	https://github.com/pop-os/cosmic-settings-daemon/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0
CC0-1.0 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

# https://github.com/lassekongo83/adw-gtk3
# instead of libadwaita?
RDEPEND="
	sys-power/acpid
	gui-libs/libadwaita
	app-misc/geoclue
"

BDEPEND="
	>=virtual/rust-1.70.0
	dev-libs/libinput
	dev-util/pkgconf
	virtual/udev
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
	GEOCLUE_AGENT=/usr/libexec/geoclue-2.0/demos/agent cargo_src_compile --bin cosmic-settings-daemon
}

src_install() {
	dobin target/release/cosmic-settings-daemon
}
