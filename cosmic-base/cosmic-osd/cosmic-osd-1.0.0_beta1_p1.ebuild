EAPI=8

inherit cargo

DESCRIPTION="COSMIC OSD"
HOMEPAGE="https://github.com/pop-os/cosmic-osd"

COMMIT="fc095b351ba03011c384b89170d9557a6052f390"
SRC_URI="
	https://github.com/pop-os/cosmic-osd/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 GPL-3+ ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	dev-libs/wayland
	dev-util/pkgconf
	media-libs/libpulse
	virtual/udev
	x11-libs/libxkbcommon
"

IDEPEND="dev-build/just"

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	export POLKIT_AGENT_HELPER_1=/usr/lib/polkit-1/polkit-agent-helper-1
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
	dobin "$(cargo_target_dir)/${PN}"
}
