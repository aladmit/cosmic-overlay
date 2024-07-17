EAPI=8

inherit cargo systemd

DESCRIPTION="The session for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-session"

COMMIT="577a181122881ac5e1a2bd263edf6cd53d17b3dc"
SRC_URI="
	https://github.com/pop-os/cosmic-session/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3.0 MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="~arm64 ~amd64"

RDEPEND="
	cosmic-base/cosmic-applets
	cosmic-base/cosmic-applibrary
	cosmic-base/cosmic-bg
	cosmic-base/cosmic-comp
	cosmic-base/cosmic-greeter
	cosmic-base/cosmic-icons
	cosmic-base/cosmic-launcher
	cosmic-base/cosmic-notifications
	cosmic-base/cosmic-osd
	cosmic-base/cosmic-panel
	cosmic-base/cosmic-randr
	cosmic-base/cosmic-screenshot
	cosmic-base/cosmic-settings
	cosmic-base/cosmic-settings-daemon
	cosmic-base/cosmic-workspaces
	cosmic-base/cosmic-xdg-desktop-portal
	cosmic-base/pop-gtk-theme
	cosmic-base/pop-icon-theme
	x11-base/xwayland
"

BDEPEND="
	>=virtual/rust-1.70.0
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config" "${CARGO_HOME}/"
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install
	dobin data/start-cosmic

	systemd_douserunit data/cosmic-session.target

	insopts -m 0644
	insinto /usr/share/wayland-sessions
	doins data/cosmic.desktop

	insinto /usr/share/applications
	doins data/cosmic-mimeapps.list
}
