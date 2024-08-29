EAPI=8

inherit cargo

DESCRIPTION="Cosmic settings daemon"
HOMEPAGE="https://github.com/pop-os/cosmic-settings-daemon"

COMMIT="add1cb3c4a6c3557c78085d51eff9b1b80035020"
SRC_URI="
	https://github.com/pop-os/cosmic-settings-daemon/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3+ ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

RDEPEND="
	sys-power/acpid
	x11-themes/adw-gtk3
	app-misc/geoclue
"

BDEPEND="
	>=virtual/rust-1.70.0
	dev-libs/libinput
	dev-util/pkgconf
	virtual/udev
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
	export GEOCLUE_AGENT=/usr/libexec/geoclue-2.0/demos/agent

	cargo_src_compile --bin cosmic-settings-daemon
}

src_install() {
	emake \
		prefix="${D}/usr" \
		CARGO_TARGET_DIR="$(cargo_target_dir)" \
		TARGET="" \
		install || die
}
