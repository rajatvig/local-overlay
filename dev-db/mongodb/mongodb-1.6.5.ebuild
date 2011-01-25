# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib versionator

MY_PATCHVER=$(get_version_component_range 1-2)
MY_P="${PN}-src-r${PV}"

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs v8"

RDEPEND="
	!v8? ( dev-lang/spidermonkey[unicode] )
	v8? ( dev-lang/v8 )
	dev-libs/boost
	dev-libs/libpcre
	net-libs/libpcap"

DEPEND="${RDEPEND}
	>=dev-util/scons-1.2.0-r1
	sys-libs/readline
	sys-libs/ncurses"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	myconf=""

	if ! use static-libs ; then
		myconf="--sharedclient"
	fi

	use static-libs || myconf="${myconf} --sharedclient"
	use v8 && myconf="${myconf} --usev8=USEV8"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-scons.patch"
	if ! use static-libs ; then
		epatch "${FILESDIR}/${P}-fix-shared.patch"
	fi
}

src_compile() {
	scons ${MAKEOPTS} ${myconf} all || die "Compile failed"
}

src_install() {
	scons ${MAKEOPTS} ${myconf} --full --nostrip install --prefix="${D}"/usr || die "Install failed"

	cd "${D}usr/$(get_libdir)"
	mv libmongoclient.so libmongoclient.so.${PV} || die
	ln -s libmongoclient.so.${PV} libmongoclient.so.$(get_version_component_range 1) || die
	ln -s libmongoclient.so.${PV} libmongoclient.so || die

	for x in /var/{lib,log,run}/${PN}; do
		dodir "${x}" || die "Install failed"
		fowners mongodb:mongodb "${x}"
	done

	cd "${S}"
	doman debian/mongo*.1 || die "Install failed"
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die "Install failed"
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die "Install failed"
}

src_test() {
	scons ${MAKEOPTS} smoke --smokedbprefix='testdir' test || die "Tests failed"
}
