EAPI=8

inherit cargo xdg

DESCRIPTION="System76 Power scripts for the launcher"
HOMEPAGE="https://github.com/pop-os/launcher"

SRC_URI="
	https://github.com/pop-os/launcher/archive/refs/tags/${PV}.zip -> ${PN}-${PV}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/0_pre20240506/${PN}-${PV}-vendor.tar.xz"

S="${WORKDIR}/launcher-${PV}"

LICENSE="MPL-2.0"
#deps
LICENSE+="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
Boost-1.0 GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.70.0
	x11-libs/libxkbcommon
	dev-libs/wayland
	media-libs/mesa[opengl]
"

RDEPEND="
	sys-apps/fd
	sci-libs/libqalculate
"

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile -p pop-launcher-bin
}

src_install() {
	newbin target/release/pop-launcher-bin pop-launcher

	plugins=('calc' 'desktop_entries' 'files' 'find' 'pop_shell' 'pulse' 'recent' 'scripts' 'terminal' 'web')

	for plugin in "${plugins[@]}"
	do
		insinto /usr/lib/pop-launcher/plugins/${plugin}
		doins plugins/src/${plugin}/plugin.ron
		dosym /usr/bin/pop-launcher /usr/lib/pop-launcher/plugins/${plugin}/$(echo ${plugin} | sed 's/_/-/')
	done

	insinto /usr/lib/pop-launcher/scripts
	doins -r scripts/*
}
