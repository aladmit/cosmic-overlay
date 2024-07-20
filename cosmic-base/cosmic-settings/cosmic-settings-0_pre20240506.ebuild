EAPI=8

inherit cargo xdg

DESCRIPTION="Settings application for the COSMIC desktop environment"
HOMEPAGE="https://github.com/pop-os/cosmic-settings"

COMMIT="a8bf840ace00dd010b83ddead6cd2338e9408730"
SRC_URI="
	https://github.com/pop-os/cosmic-settings/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
SLOT="0"

KEYWORDS="arm64 amd64"

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

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	dobin target/release/cosmic-settings

	insinto /usr/share/applications
	doins resources/com.system76.CosmicSettings.About.desktop
	doins resources/com.system76.CosmicSettings.Appearance.desktop
	doins resources/com.system76.CosmicSettings.DateTime.desktop
	doins resources/com.system76.CosmicSettings.desktop
	doins resources/com.system76.CosmicSettings.Desktop.desktop
	doins resources/com.system76.CosmicSettings.Displays.desktop
	doins resources/com.system76.CosmicSettings.Firmware.desktop
	doins resources/com.system76.CosmicSettings.Keyboard.desktop
	doins resources/com.system76.CosmicSettings.Mouse.desktop
	doins resources/com.system76.CosmicSettings.Notifications.desktop
	doins resources/com.system76.CosmicSettings.RegionLanguage.desktop
	doins resources/com.system76.CosmicSettings.Sound.desktop
	doins resources/com.system76.CosmicSettings.Touchpad.desktop
	doins resources/com.system76.CosmicSettings.Users.desktop
	doins resources/com.system76.CosmicSettings.Wallpaper.desktop
	doins resources/com.system76.CosmicSettings.Workspaces.desktop

	insinto /usr/share/metainfo
	doins resources/com.system76.CosmicSettings.metainfo.xml

	insinto /usr/share/polkit-1/rules.d/
	doins resources/polkit-1/rules.d/cosmic-settings.rules

	insinto /usr/share/cosmic
	doins -r resources/default_schema/*

	insinto /usr/share/icons/hicolor
	doins -r resources/icons/*
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
