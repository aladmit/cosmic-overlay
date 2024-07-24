EAPI=8

inherit cargo

DESCRIPTION="Cosmic settings daemon"
HOMEPAGE="https://github.com/pop-os/cosmic-settings-daemon"

COMMIT="54700dfee57d1569efb2179896e36d754c2bf270"
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
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure
}

src_compile() {
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}
	GEOCLUE_AGENT=/usr/libexec/geoclue-2.0/demos/agent cargo_src_compile --bin cosmic-settings-daemon
}

src_install() {
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}
	emake prefix="${D}/usr" install
}