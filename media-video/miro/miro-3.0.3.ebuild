# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"

inherit eutils fdo-mime gnome2-utils python distutils

DESCRIPTION="Open source video player and podcast client"
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/${PN}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libnotify aac musepack xvid"

CDEPEND="
	dev-libs/glib:2
	dev-libs/boost[python]
	>=dev-python/pyrex-0.9.6.4
	dev-python/pygtk:2
	dev-python/pygobject:2"

RDEPEND="${CDEPEND}
	libnotify? ( dev-python/notify-python )
	|| ( dev-lang/python[sqlite] dev-python/pysqlite:2 )
	dev-python/dbus-python
	dev-python/pycairo
	dev-python/gconf-python
	dev-python/gst-python:0.10
	>=dev-python/pywebkitgtk-1.1.5

	>=net-libs/rb_libtorrent-0.14.1[python]

	media-plugins/gst-plugins-meta:0.10
	media-plugins/gst-plugins-pango:0.10
	aac? ( media-plugins/gst-plugins-faad:0.10 )
	musepack? ( media-plugins/gst-plugins-musepack:0.10 )
	xvid? ( media-plugins/gst-plugins-xvid:0.10 )"

DEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/platform/gtk-x11"

src_prepare() {
	# fix debug mode
	epatch "${FILESDIR}/${PN}-3.0.2-fix-debug.patch"

	# disable autoupdate
	sed -i -e "/autoupdate/d" ../../portable/startup.py || die "sed failed"

	# be sure libnotify is never used if disabled
	if ! use libnotify; then
		sed -i -e "s:import pynotify:import pynotifyisdisabled:" \
			../../portable/frontends/widgets/gtk/trayicon.py \
			plat/frontends/widgets/application.py || die "sed failed"
	fi
}

src_install() {
	# doing the mv now otherwise, distutils_src_install will install it
	mv README README.gtk || die "mv failed"

	distutils_src_install

	# installing docs
	dodoc README.gtk ../../{ADOPTERS,CREDITS,README} || die "dodoc failed"
	newdoc ../../portable/frontends/cli/README README.cli || die "dodoc failed"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	ewarn
	ewarn "If miro doesn't play some video or audio format, please"
	ewarn "check your USE flags on media-plugins/gst-plugins-meta"
	ewarn
	elog "Miro for Linux doesn't support Adobe Flash, therefore you"
	elog "you will not see any embedded video player on MiroGuide."
	elog
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
