EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC workspaces"
HOMEPAGE="https://github.com/pop-os/cosmic-workspaces-epoch"

COMMIT="e2e0f09311b523c4690e7064dcf7d7a0c9219c10"
SRC_URI="
	https://github.com/pop-os/cosmic-workspaces-epoch/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${PN}-epoch-${PV}-vendor.tar.xz"

S="${WORKDIR}/${PN}-epoch-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/mesa[opengl,wayland]
	virtual/udev
	x11-libs/libxkbcommon
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

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	# replace COSMIC with X-COSMIC
	find ${S} -type f -name "*.desktop" -exec sed -i '/^Categories=/ s/COSMIC/X-COSMIC/g' {} +
	emake \
		prefix="${D}/usr" \
		CARGO_TARGET_DIR="$(cargo_target_dir)" \
		TARGET="" \
		install || die
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
