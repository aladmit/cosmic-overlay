EAPI=8

inherit cargo xdg

DESCRIPTION="System76 Power scripts for the launcher"
HOMEPAGE="https://github.com/pop-os/launcher"

SRC_URI="
	https://github.com/pop-os/launcher/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/0_pre20240506/${PN}-${PV}-vendor.tar.xz"

S="${WORKDIR}/launcher-${PV}"

LICENSE="MPL-2.0"
#deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
Boost-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	x11-libs/libxkbcommon
	dev-libs/wayland
	media-libs/mesa[opengl]
"

RDEPEND="
	sys-apps/fd
	sci-libs/libqalculate
"

IDEPEND="dev-build/just"

PATCHES=( "${FILESDIR}/${PN}-${PV}-just.patch" )

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	cargo_src_configure

	# use vendored crates
	sed -i "${ECARGO_HOME}/config.toml" -e '/source.gentoo/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/directory = .*/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/source.crates-io/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/replace-with = "gentoo"/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/local-registry = "\/nonexistent"/d'  || die
	cat "${WORKDIR}/config.toml" >> "${ECARGO_HOME}/config.toml" || die
}

src_compile() {
	cargo_src_compile -p pop-launcher-bin
}

src_install() {
	just \
		rootdir="${D}" \
		target="$(cargo_target_dir)" \
		install || die
}
