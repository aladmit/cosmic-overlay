EAPI=8

inherit cargo xdg

DESCRIPTION="The session for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-session"

COMMIT="577a181122881ac5e1a2bd263edf6cd53d17b3dc"
SRC_URI="
	https://github.com/pop-os/cosmic-session/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD Boost-1.0 GPL-3 MIT MPL-2.0 Unicode-DFS-2016 Unlicense
ZLIB"

SLOT="0"

KEYWORDS="~amd64 ~arm64"

RDEPEND="
	cosmic-base/cosmic-applets
	cosmic-base/cosmic-applibrary
	cosmic-base/cosmic-bg
	cosmic-base/cosmic-comp
	cosmic-base/cosmic-greeter
	cosmic-base/cosmic-icons
	cosmic-base/cosmic-launcher
	cosmic-base/cosmic-notifications
	cosmic-base/cosmic-osd
	cosmic-base/cosmic-panel
	cosmic-base/cosmic-randr
	cosmic-base/cosmic-screenshot
	cosmic-base/cosmic-settings
	cosmic-base/cosmic-settings-daemon
	cosmic-base/cosmic-workspaces
	cosmic-base/xdg-desktop-portal-cosmic
	x11-themes/pop-icon-theme
	x11-base/xwayland
"

BDEPEND=">=virtual/rust-1.70.0"
IDEPEND="dev-build/just"

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
	cargo_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	export VERGEN_GIT_COMMIT_DATE=$(date --utc +'%Y-%m-%d')
	export VERGEN_GIT_SHA=${COMMIT}
	just prefix="${D}/usr" etcdir="${D}/etc" install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
