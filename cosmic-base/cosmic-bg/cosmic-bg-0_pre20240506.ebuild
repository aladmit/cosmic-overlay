EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC Background"
HOMEPAGE="https://github.com/pop-os/cosmic-bg"

COMMIT="ae45d5e1b3d1e297e608c160556ef2eec7b61ab2"
SRC_URI="
	https://github.com/pop-os/cosmic-bg/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0
CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0 Unicode Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

# add optional mold
BDEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon
	>=virtual/rust-1.73.0
	dev-lang/nasm
	dev-util/pkgconf
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
	dobin target/release/cosmic-bg

	insinto /usr/share/applications
	doins data/com.system76.CosmicBackground.desktop

	insinto /usr/share/metainfo
	doins data/com.system76.CosmicBackground.metainfo.xml

	insinto /usr/share/cosmic/com.system76.CosmicBackground
	doins -r data/v1

	insinto /usr/share/icons/hicolor/scalable/apps/
	doins data/icons/com.system76.CosmicBackground.svg

	insinto /usr/share/icons/hicolor/symbolic/apps/
	doins data/icons/com.system76.CosmicBackground-symbolic.svg
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
