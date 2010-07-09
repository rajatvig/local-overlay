# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/edje/edje-9999.ebuild,v 1.6 2006/07/16 05:29:42 vapier Exp $

E_SNAP_DATE="2010-06-27"
inherit enlightenment

DESCRIPTION="graphical layout and animation library"
HOMEPAGE="http://www.enlightenment.org/pages/edje.html"

IUSE="vim-syntax"

DEPEND="dev-lang/lua
	>=dev-libs/eet-1.3.2
	>=dev-libs/eina-0.9.9.49898
	>=dev-libs/embryo-0.9.9.49898
	>=x11-libs/ecore-0.9.9.49898
	>=x11-libs/evas-0.9.9.49898"

src_compile() {
	export MY_ECONF="
		$(use_with vim-syntax vim /usr/share/vim)
	"
	enlightenment_src_compile
}

src_install() {
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins data/edc.vim edc.vim
	fi
	enlightenment_src_install
}
