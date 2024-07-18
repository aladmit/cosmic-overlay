EAPI=8

inherit xdg

DESCRIPTION="COSMIC Cosmic Icons"
HOMEPAGE="https://github.com/pop-os/cosmic-icons"

COMMIT="f48101c38db7e725d31591ec49896a2f525886e2"
SRC_URI="https://github.com/pop-os/cosmic-icons/archive/${COMMIT}.zip"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0 CC-BY-SA-4.0"
SLOT="0"

KEYWORDS="arm64 amd64"

RDEPEND="
	cosmic-base/pop-icon-theme
"

src_preinst() {
	xdg_pkg_preinst
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PN}-${COMMIT}" "${WORKDIR}/${P}" || die
}

src_install() {
	insinto /usr/share/icons/Cosmic
	doins -r freedesktop/scalable
	doins -r extra/scalable
	doins index.theme
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
