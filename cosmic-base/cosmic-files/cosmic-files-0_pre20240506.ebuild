EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC File Manager"
HOMEPAGE="https://github.com/pop-os/cosmic-files"

COMMIT="5ecd697e5d5e7fe896ec8dd109b4c9dcf092feb6"
SRC_URI="
	https://github.com/pop-os/cosmic-files/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2
Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/glib
	dev-util/pkgconf
"

RDENEND="
	x11-misc/xdg-utils
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
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}
	cargo_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	dobin target/release/cosmic-files

	insinto /usr/share/applications
	doins res/com.system76.CosmicFiles.desktop

	insinto /usr/share/metainfo
	doins res/com.system76.CosmicFiles.metainfo.xml

	insinto /usr/share/icons/hicolor
	doins -r res/icons/hicolor/*
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
