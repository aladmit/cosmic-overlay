EAPI=8

inherit meson xdg

DESCRIPTION="System76 Pop icon theme"
HOMEPAGE="https://github.com/pop-os/icon-theme"

SRC_URI="https://github.com/pop-os/icon-theme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/icon-theme-${PV}"

LICENSE="CC-BY-4.0"
SLOT="0"

KEYWORDS="*"

src_unpack() {
	default
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	meson_src_install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
