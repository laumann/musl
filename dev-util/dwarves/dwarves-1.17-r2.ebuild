# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit multilib cmake python-single-r1

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF2 utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"

LICENSE="GPL-2" # only
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.178
	sys-libs/zlib"
DEPEND="${RDEPEND}"

if [[ ${PV//_p} == ${PV} ]]; then
	SRC_URI="http://fedorapeople.org/~acme/dwarves/${P}.tar.xz"
else
	SRC_URI="https://dev.gentoo.org/~zzam/${PN}/${P}.tar.xz"
fi

DOCS=( README README.ctracer NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-1.10-python-import.patch
)

src_prepare() {
	if use elibc_musl ; then
		eapply "${FILESDIR}"/dwarves-1.17-musl.patch
	fi
	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( "-D__LIB=$(get_libdir)" )
	cmake_src_configure
}

src_test() { :; }

src_install() {
	cmake_src_install
}
