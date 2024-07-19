EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC workspaces"
HOMEPAGE="https://github.com/pop-os/cosmic-workspaces-epoch"

COMMIT="30b0cfe17b87936e08cc1e659972e8052e247d2b"
SRC_URI="
	https://github.com/pop-os/cosmic-workspaces-epoch/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${PN}-epoch-${PV}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016
Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/mesa[opengl]
	virtual/udev
	x11-libs/libxkbcommon
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-epoch-${COMMIT}/* ${PN}-${PV}/ || die
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
	dobin target/release/cosmic-workspaces

	insinto /usr/share/applications
	doins data/com.system76.CosmicWorkspaces.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins data/com.system76.CosmicWorkspaces.svg
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
