EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC backend for xdg-desktop-portal"
HOMEPAGE="https://github.com/pop-os/xdg-desktop-portal-cosmic"

COMMIT="566b8660964588bb2d66daf397f680f015c3f451"
SRC_URI="
	https://github.com/pop-os/xdg-desktop-portal-cosmic/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.75.0
	sys-devel/clang
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/mesa[opengl]
	media-video/pipewire
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
	insinto /usr/libexec
	doins target/release/xdg-desktop-portal-cosmic
	fperms +x /usr/libexec/xdg-desktop-portal-cosmic

	insinto /usr/share/dbus-1/services
	doins data/org.freedesktop.impl.portal.desktop.cosmic.service

	insinto /usr/share/xdg-desktop-portal/portals
	doins data/cosmic.portal

	insinto /usr/share/xdg-desktop-portal
	doins data/cosmic-portals.conf

	insinto /usr/share/icons/hicolor
	doins -r data/icons/*
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}