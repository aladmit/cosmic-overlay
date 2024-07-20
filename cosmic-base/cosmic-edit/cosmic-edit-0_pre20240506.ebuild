EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC Text Editor"
HOMEPAGE="https://github.com/pop-os/cosmic-edit"

COMMIT="8d16f0881631280b34d7b9cbda097b1cb31ebcd3"
SRC_URI="
	https://github.com/pop-os/cosmic-edit/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.75.0
	dev-build/just
	dev-util/pkgconf
"

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure
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
	just prefix="${D}/usr" install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
