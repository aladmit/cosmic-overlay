EAPI=8

inherit cargo

DESCRIPTION="COSMIC Greeter"
HOMEPAGE="https://github.com/pop-os/cosmic-greeter"

COMMIT="cc744b0b9a6065a97808744bf63433c439e4186c"
SRC_URI="
	https://github.com/pop-os/cosmic-greeter/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC-PD CC0-1.0 GPL-3 ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="
	>=virtual/rust-1.75.0
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	sys-devel/clang
	sys-libs/pam
	x11-libs/libxkbcommon
"

RDEPEND="
	app-shells/bash
	cosmic-base/cosmic-comp
	gui-libs/greetd
	sys-apps/dbus
	acct-user/cosmic-greeter
	acct-group/cosmic-greeter
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

	cargo_src_compile --all
}

src_install() {
	dobin "$(cargo_target_dir)/cosmic-greeter"
	dobin "$(cargo_target_dir)/cosmic-greeter-daemon"

	insinto /usr/share/dbus-1/system.d
	doins dbus/com.system76.CosmicGreeter.conf
}
