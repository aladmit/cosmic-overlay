EAPI=8

inherit meson

DESCRIPTION="An unofficial GTK3 port of libadwaita."
HOMEPAGE="https://github.com/lassekongo83/adw-gtk3"

SRC_URI="https://github.com/lassekongo83/adw-gtk3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="dev-build/dart-sass"

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
