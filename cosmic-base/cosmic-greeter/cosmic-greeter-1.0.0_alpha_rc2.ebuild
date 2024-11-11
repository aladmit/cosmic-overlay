EAPI=8

inherit cargo pam tmpfiles systemd

DESCRIPTION="COSMIC Greeter"
HOMEPAGE="https://github.com/pop-os/cosmic-greeter"

COMMIT="4ddb320daeea5124bf67500d73d6ead620f3d09b"
SRC_URI="
	https://github.com/pop-os/cosmic-greeter/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz
	https://github.com/aladmit/cosmic-overlay/releases/download/${PV}/${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
# deps
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
BSD BSD-2 Boost-1.0 CC-PD CC0-1.0 GPL-3 ISC MIT MPL-2.0
Unicode-DFS-2016 Unlicense ZLIB"

SLOT="0"

KEYWORDS="amd64 arm64"

BDEPEND="
	dev-libs/libinput
	dev-libs/wayland
	dev-util/pkgconf
	sys-devel/clang
	sys-libs/pam
	x11-libs/libxkbcommon
"

RDEPEND="
	app-shells/bash
	cosmic-base/cosmic-comp
	gui-libs/greetd
	sys-apps/dbus
	acct-user/cosmic-greeter
	acct-group/cosmic-greeter
"

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

	cargo_src_compile --all
}

src_install() {
	just \
		prefix="${D}/usr" \
		bin-src="$(cargo_target_dir)/${PN}" \
		daemon-src="$(cargo_target_dir)/${PN}-daemon" \
		install || die

	insinto /etc/greetd
	doins cosmic-greeter.toml

	newpamd "${FILESDIR}"/cosmic-greeter.pam cosmic-greeter

	sed -i \
		-e '/#\[Install\]/s/^#//' \
		-e '/#Alias/s/^#//' \
		debian/cosmic-greeter.service

	systemd_dounit debian/cosmic-greeter-daemon.service || die
	systemd_dounit debian/cosmic-greeter.service || die
}

pkg_postinst() {
	tmpfiles_process cosmic-greeter.conf
}
