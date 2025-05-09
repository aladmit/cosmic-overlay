EAPI=8

inherit cargo xdg

DESCRIPTION="The session for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-session"

COMMIT="6d16513d77db627b93332f4ad5125c47f4fedea3"
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

KEYWORDS="amd64 arm64"

IDEPEND="dev-build/just"

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
	media-fonts/fira-mono
	media-fonts/fira-sans
	media-fonts/roboto
	sys-power/upower
	x11-base/xwayland
"

PATCHES=( "${FILESDIR}/justfile.patch" )

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
	just \
		prefix="${D}/usr" \
		etcdir="${D}/etc" \
		cargo-target-dir="$(cargo_target_dir)" \
		install || die
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
