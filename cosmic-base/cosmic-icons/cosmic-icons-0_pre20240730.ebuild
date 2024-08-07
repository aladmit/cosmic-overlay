EAPI=8

inherit xdg

DESCRIPTION="COSMIC Cosmic Icons"
HOMEPAGE="https://github.com/pop-os/cosmic-icons"

COMMIT="73be037ba266b08a2fa7b544d78e7f143a2894c5"
SRC_URI="https://github.com/pop-os/cosmic-icons/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3 CC-BY-SA-4.0"

SLOT="0"

KEYWORDS="*"

IDEPEND="dev-build/just"
RDEPEND="x11-themes/pop-icon-theme"

src_preinst() {
	xdg_pkg_preinst
}

src_unpack() {
	unpack ${A}
}

src_install() {
	just prefix="${D}/usr" install
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
