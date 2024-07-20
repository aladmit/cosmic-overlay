EAPI=8

inherit cargo

DESCRIPTION="COSMIC Greeter"
HOMEPAGE="https://github.com/pop-os/cosmic-greeter"

COMMIT="9933926d443386089a39683818109a9df50564a5"
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

KEYWORDS="amd64 arm64"

BDEPEND="
	>=virtual/rust-1.75.0
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
	cargo_src_compile --all
}

src_install() {
	dobin target/release/cosmic-greeter
	dobin target/release/cosmic-greeter-daemon

	insinto /usr/share/dbus-1/system.d
	doins dbus/com.system76.CosmicGreeter.conf
}