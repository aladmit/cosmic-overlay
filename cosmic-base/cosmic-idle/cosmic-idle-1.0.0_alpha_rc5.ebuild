EAPI=8

inherit cargo

DESCRIPTION="COSMIC idle daemon"
HOMEPAGE="https://github.com/pop-os/cosmic-idle"

COMMIT="7899fccbbe3d6746982178d3eff48ce8943b0f71"
SRC_URI="
	https://github.com/pop-os/cosmic-idle/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="amd64 arm64"

# add optional mold
BDEPEND="
	dev-build/just
	dev-libs/wayland
	dev-util/pkgconf
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

src_install() {
	just \
		prefix="${D}/usr" \
		bin-src="$(cargo_target_dir)/${PN}" \
		install || die
}
