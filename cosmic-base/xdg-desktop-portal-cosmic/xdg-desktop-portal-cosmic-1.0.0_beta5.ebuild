EAPI=8

inherit cargo xdg systemd

DESCRIPTION="COSMIC backend for xdg-desktop-portal"
HOMEPAGE="https://github.com/pop-os/xdg-desktop-portal-cosmic"

COMMIT="86410278881367a871fa4a6fe06e756baf6b3aee"
SRC_URI="
	https://github.com/pop-os/xdg-desktop-portal-cosmic/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
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
	media-libs/mesa[opengl,wayland]
	media-video/pipewire
	x11-libs/libxkbcommon
"

RDEPEND="sys-auth/rtkit"

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
	emake \
		prefix="${D}/usr" \
		CARGO_TARGET_DIR="$(cargo_target_dir)" \
		TARGET="" \
		install || die

	service_name="org.freedesktop.impl.portal.desktop.cosmic.service"

	sed "s|@libexecdir@|/usr/libexec|" \
		"data/${service_name}.in" > \
		"${D}/usr/lib/systemd/user/${service_name}" || die

	sed "s|@libexecdir@|/usr/libexec|" \
		"data/${service_name}.in" > \
		"${D}/usr/share/dbus-1/services/${service_name}" || die

}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
