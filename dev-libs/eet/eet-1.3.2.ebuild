# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-9999.ebuild,v 1.4 2005/03/25 17:51:29 vapier Exp $

EKEY_STATE=snap
inherit enlightenment

SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

DESCRIPTION="E file chunk reading/writing library"
HOMEPAGE="http://www.enlightenment.org/pages/eet.html"

DEPEND="dev-libs/eina
	media-libs/jpeg
	sys-libs/zlib"
