# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user eutils readme.gentoo-r1

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"
SRC_URI="http://v6web.litech.org/radvd/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc x86"
IUSE="selinux test"
RESTRICT="!test? ( test )"

CDEPEND="dev-libs/libdaemon"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-radvd )
"
DOCS=( CHANGES README TODO radvd.conf.example )

PATCHES=( "${FILESDIR}"/"${PN}"-2.17-r1-musl.patch
)

pkg_setup() {
	enewgroup radvd
	enewuser radvd -1 -1 /dev/null radvd
}

src_configure() {
	econf --with-pidfile=/run/radvd/radvd.pid \
		--disable-silent-rules \
		--with-systemdsystemunitdir=no \
		$(use_with test check)
}

src_install() {
	default

	insinto /usr/share/doc/${PF}/html
	doins INTRO.html

	newinitd "${FILESDIR}"/${PN}-2.15.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service

	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please create a configuration file ${ROOT}etc/radvd.conf.
See ${ROOT}usr/share/doc/${PF} for an example.

grsecurity users should allow a specific group to read /proc
and add the radvd user to that group, otherwise radvd may
segfault on startup."
