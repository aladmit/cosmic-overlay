EAPI=8

inherit cargo xdg

DESCRIPTION="COSMIC Screenshot Utility"
HOMEPAGE="https://github.com/pop-os/cosmic-screenshot"

COMMIT="f853446dbe1ff6e124749cdfd0eeb94dc43e884a"
SRC_URI="
	https://github.com/pop-os/cosmic-screenshot/archive/${COMMIT}.zip
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

ECARGO_VENDOR="${WORKDIR}/vendor"

LICENSE="GPL-3.0"
# deps
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"

KEYWORDS="arm64 amd64"

BDEPEND="
	>=virtual/rust-1.75.0
"

src_unpack() {
	cargo_src_unpack
	mv ${WORKDIR}/${PN}-${COMMIT}/* ${PN}-${PV}/ || die
}

src_configure() {
	mv "${WORKDIR}/config.toml" "${CARGO_HOME}/config" || die
	cargo_src_configure --frozen
}

src_compile() {
	cargo_src_compile
}

src_preinst() {
	xdg_pkg_preinst
}

src_install() {
	dobin target/release/cosmic-screenshot

	insinto /usr/share/applications
	doins resources/com.system76.CosmicScreenshot.desktop
}

src_postinst() {
	xdg_pkg_postinst
}

src_postrm() {
	xdg_pkg_postrm
}
