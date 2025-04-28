EAPI=8

DESCRIPTION="The reference implementation of Sass, written in Dart."
HOMEPAGE="https://sass-lang.com/dart-sass"

LICENSE="MIT"
SLOT="0"

SRC_URI="
	amd64? ( https://github.com/sass/dart-sass/releases/download/${PV}/${P}-linux-x64.tar.gz )
	arm64? ( https://github.com/sass/dart-sass/releases/download/${PV}/${P}-linux-arm64.tar.gz )
"

KEYWORDS="amd64 arm64"

RDEPEND="!dev-ruby/sass"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "/usr/share"
	doins -r "${S}"
	fperms +x /usr/share/dart-sass/sass
	fperms +x /usr/share/dart-sass/src/dart
	dosym "/usr/share/dart-sass/sass" "/usr/bin/sass"
}
