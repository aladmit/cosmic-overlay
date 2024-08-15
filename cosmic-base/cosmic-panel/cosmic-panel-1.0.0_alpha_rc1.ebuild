EAPI=8

inherit cargo

DESCRIPTION="COSMIC Panel"
HOMEPAGE="https://github.com/pop-os/cosmic-panel"

COMMIT="47c672066adac6ff77b680b9461c8e1c2667b758"
SRC_URI="
	https://github.com/pop-os/cosmic-panel/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016
Unlicense ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="
	>=virtual/rust-1.70.0
	dev-libs/wayland
	dev-util/desktop-file-utils
	dev-util/pkgconf
	x11-libs/libxkbcommon
"

IDEPEND="dev-build/just"

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
	just \
		prefix="${D}/usr" \
		bin-src="$(cargo_target_dir)/${PN}" \
		install || die
}
