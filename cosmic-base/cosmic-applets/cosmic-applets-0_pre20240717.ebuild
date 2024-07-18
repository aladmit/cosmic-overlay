EAPI=8

inherit cargo

DESCRIPTION="COSMIC Panel"
HOMEPAGE="https://github.com/pop-os/cosmic-applets"

COMMIT="4ceac0c57ba09cce66ef4fe5dfc758768faad19f"
SRC_URI="
	https://github.com/pop-os/cosmic-applets/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0 Unicode Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="~arm64 ~amd64"

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
	dev-libs/libinput
	dev-util/pkgconf
	media-libs/libpulse
	sys-apps/dbus
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
	function _install_icons() {
		local name=$1

		dodir /usr/share/icons/scalable/apps
		insinto /usr/share/icons/scalable/apps
		doins -r ${name}/data/icons/scalable/apps/
	}

	function _install_desktop() {
		local path=$1

		insinto /usr/share/applications
		doins $path
	}

	function _install_button() {
		local id=$1
		local name=$2

		dodir /usr/share/icons/scalable/apps
		insinto /usr/share/icons/scalable/apps
		doins -r ${name}/data/icons/scalable/apps/
		insinto /usr/share/applications
		doins "${name}/data/${id}.desktop"
	}

	function _install_applet() {
		local id=$1
		local name=$2

		_install_icons $name
		_install_desktop "${name}/data/${id}.desktop"
		dosym /usr/bin/cosmic-applets /usr/bin/$name
	}

	dobin target/release/cosmic-applets
	dobin target/release/cosmic-panel-button

	dodir /usr/share/cosmic
	insinto /usr/share/cosmic
	doins -r cosmic-app-list/data/default_schema/*

	_install_button 'com.system76.CosmicPanelAppButton' 'cosmic-panel-app-button'
	_install_button 'com.system76.CosmicPanelLauncherButton' 'cosmic-panel-launcher-button'
	_install_button 'com.system76.CosmicPanelWorkspacesButton' 'cosmic-panel-workspaces-button'

	_install_applet 'com.system76.CosmicAppList' 'cosmic-app-list'
	_install_applet 'com.system76.CosmicAppletAudio' 'cosmic-applet-audio'
	_install_applet 'com.system76.CosmicAppletBattery' 'cosmic-applet-battery'
	_install_applet 'com.system76.CosmicAppletBluetooth' 'cosmic-applet-bluetooth'
	_install_applet 'com.system76.CosmicAppletInputSources' 'cosmic-applet-input-sources'
	_install_applet 'com.system76.CosmicAppletMinimize' 'cosmic-applet-minimize'
	_install_applet 'com.system76.CosmicAppletNetwork' 'cosmic-applet-network'
	_install_applet 'com.system76.CosmicAppletNotifications' 'cosmic-applet-notifications'
	_install_applet 'com.system76.CosmicAppletPower' 'cosmic-applet-power'
	_install_applet 'com.system76.CosmicAppletStatusArea' 'cosmic-applet-status-area'
	_install_applet 'com.system76.CosmicAppletTiling' 'cosmic-applet-tiling'
	_install_applet 'com.system76.CosmicAppletTime' 'cosmic-applet-time'
	_install_applet 'com.system76.CosmicAppletWorkspaces' 'cosmic-applet-workspaces'
}
