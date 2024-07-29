EAPI=8

inherit cargo xdg

DESCRIPTION="Applets for COSMIC panel"
HOMEPAGE="https://github.com/pop-os/cosmic-applets"

COMMIT="10b69b07c21e1037b5111f2ed23fa9e4831983ac"
SRC_URI="
	https://github.com/pop-os/cosmic-applets/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0
CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-build/just
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/libpulse
	media-libs/mesa[opengl]
	sys-apps/dbus
	virtual/udev
	x11-libs/libxkbcommon
"

RDEPEND="
	cosmic-base/cosmic-icons
"

PATCHES=( "${FILESDIR}/${PN}-${PV}-just.patch" )

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
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}
	just prefix="${D}/usr" install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
