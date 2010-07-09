# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

E_SNAP_DATE="2010-06-27"
inherit enlightenment

DESCRIPTION="the e17 window manager"

SLOT="0.17"
IUSE="pam"

RDEPEND=">=dev-libs/eet-1.3.2
	>=dev-libs/efreet-0.5.0.49898
	>=dev-libs/eina-0.9.9.49898
	>=dev-libs/embryo-0.9.9.49898
	>=media-libs/edje-0.9.99.49898
	pam? ( sys-libs/pam )
	>=x11-libs/ecore-0.9.9.49898
	>=x11-libs/evas-0.9.9.49898[png]
	>=x11-libs/e_dbus-0.5.0.49898"
DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-devel/libtool"
