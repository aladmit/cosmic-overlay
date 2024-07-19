EAPI=8

inherit cargo

DESCRIPTION="Cosmic settings daemon"
HOMEPAGE="https://github.com/pop-os/cosmic-settings-daemon"

COMMIT="54700dfee57d1569efb2179896e36d754c2bf270"
SRC_URI="
	https://github.com/pop-os/cosmic-settings-daemon/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
BSD-2 Boost-1.0 CC0-1.0 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS
Unlicense ZLIB"
SLOT="0"

KEYWORDS="~arm64 ~amd64"

RDEPEND="
	sys-power/acpid
	x11-themes/adw-gtk3
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

	insinto /usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/
	newins data/system_actions.ron system_actions

	insinto /usr/share/data/polkit-1/rules.d/
	doins data/polkit-1/rules.d/cosmic-settings-daemon.rules
}
