# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

E_PKG_IUSE="static-libs"
ESVN_SUB_PROJECT="PROTO"

inherit enlightenment

DESCRIPTION="EFL based login manager"

IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/edje-9999
	>=media-libs/elementary-9999"
DEPEND="${RDEPEND}"
