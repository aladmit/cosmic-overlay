EAPI=8

inherit cargo

DESCRIPTION="Compositor for the COSMIC desktop environment "
HOMEPAGE="https://github.com/pop-os/cosmic-comp"

COMMIT="4748916ff91c50c16d84f4a777db1e1b4d90c90c"
SRC_URI="
	https://github.com/pop-os/cosmic-comp/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 OFL-1.1
Unicode-3.0 Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="
	>=virtual/rust-1.76
	dev-build/just
	dev-libs/libinput
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/mesa[opengl]
	sys-apps/systemd
	sys-auth/seatd
	virtual/udev
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pixman
"

RDEPEND="
	dev-libs/wayland
	media-libs/mesa[opengl]
"

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
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}

	cargo_src_compile
}

src_install() {
	emake \
		prefix="${D}/usr" \
		sysconfdir="${D}/etc" \
		CARGO_TARGET_DIR="$(cargo_target_dir)" \
		TARGET="" install || die
}
