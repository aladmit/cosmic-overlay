EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC File Manager"
HOMEPAGE="https://github.com/pop-os/cosmic-files"

COMMIT="2aa7b6f063db04580785ec1ae0c36326af2f9868"
SRC_URI="
	https://github.com/pop-os/cosmic-files/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	dev-build/just
	dev-libs/glib
	dev-util/pkgconf
	x11-libs/libxkbcommon
"

RDENEND="x11-misc/xdg-utils"

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
	cargo_src_compile --package "${PN}-applet"
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	# replace COSMIC with X-COSMIC
	find ${S} -type f -name "*.desktop" -exec sed -i '/^Categories=/ s/COSMIC/X-COSMIC/g' {} +
	just \
		prefix="${D}/usr" \
		bin-src="$(cargo_target_dir)/${PN}" \
		applet-src="$(cargo_target_dir)/${PN}-applet" \
		install || die
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
