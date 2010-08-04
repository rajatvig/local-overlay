# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit multilib flag-o-matic #elisp-common

DESCRIPTION="GNU/MIT-Scheme"
HOMEPAGE="http://www.swiss.ai.mit.edu/projects/scheme/"
SRC_URI="http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc" # emacs"

#SITEFILE="50mitscheme-gentoo.el"

RDEPEND="app-crypt/mhash
	dev-libs/libmcrypt
	dev-libs/openssl
	sys-libs/gdbm
	sys-libs/ncurses
	dev-db/postgresql-base
	x11-libs/libX11"

DEPEND="${RDEPEND}
	doc? ( dev-texlive/texlive-texinfo )"

src_prepare() {
	sed "s:@for:@+for:" -i \
		Makefile || die "sed failed"
	sed "s:make:make -j1:" -i \
		src/etc/make-in-subdirs.sh || die "sed failed"
	sed "s:CFLAGS=\"\${CFLAGS} -O3\":CFLAGS=\"${CFLAGS}\":" -i \
		{src/lib/include,src/microcode}/configure{,.ac} || die "sed failed"
}

src_configure() {
	if use doc; then
		cd "${S}"/doc
		econf
	fi
}

src_compile() {
	cd "${S}"/src
	./etc/make-liarc.sh --prefix=/usr --exec-prefix=/usr --libdir=/usr/$(get_libdir) || die "making liar C failed"

	if use doc ; then
		cd "${S}"/doc
		emake -j1 || die "emake doc failed"
	fi

	cd ..

#    if use emacs ; then
#        elisp-compile etc/*.el || die
#    fi
}

src_install() {
	cd "${S}"/src
	emake DESTDIR="${D}" install || die "make install failed"

	cd "${S}"/doc
	doman scheme.1 || die "doman failed"
	if use doc ; then
		dohtml index.html || die "dhtml failed"
		doinfo ref-manual/mit-scheme-ref.info* || die "doinfo failed"
		dodoc ref-manual/mit-scheme-ref.{pdf,ps} || die "dodoc failed"
		doinfo user-manual/mit-scheme-user.info || die "doinfo failed"
		dodoc user-manual/mit-scheme-user.{pdf,ps} || die "dodoc failed"
		doinfo sos/mit-scheme-sos.info || die "doinfo failed"
		dodoc sos/mit-scheme-sos.{pdf,ps} || die "dodoc failed"
		doinfo imail/mit-scheme-imail.info || die "doinfo failed"
		dodoc imail/mit-scheme-imail.{pdf,ps} || die "dodoc failed"

		cd ref-manual
		docinto html/mit-scheme-ref
		dohtml mit-scheme-ref/* || die "dhtml failed"

		cd ../user-manual
		docinto html/mit-scheme-user
		dohtml mit-scheme-user/* || die "dhtml failed"

		cd ../sos
		docinto html/mit-scheme-sos
		dohtml mit-scheme-sos/* || die "dhtml failed"

		cd ../imail
		docinto html/mit-scheme-imail
		dohtml mit-scheme-imail/* || die "dhtml failed"
		cd ../
	fi
}

#pkg_postinst() {
#    use emacs && elisp-site-regen
#}

#pkg_postrm() {
#    use emacs && elisp-site-regen
#}
