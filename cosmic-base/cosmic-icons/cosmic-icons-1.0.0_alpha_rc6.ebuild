EAPI=8

inherit xdg

DESCRIPTION="COSMIC Cosmic Icons"
HOMEPAGE="https://github.com/pop-os/cosmic-icons"

COMMIT="52ad55cba5272630f345e14bee69c9fbe7aa98c4"
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
	just prefix="${D}/usr" install || die
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
