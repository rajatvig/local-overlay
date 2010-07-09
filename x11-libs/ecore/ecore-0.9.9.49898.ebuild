# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ecore/ecore-9999.ebuild,v 1.14 2006/10/29 03:27:50 vapier Exp $

E_SNAP_DATE="2010-06-27"
inherit enlightenment

DESCRIPTION="core event abstraction layer and X abstraction layer (nice convenience library)"

IUSE="curl directfb fbcon gnutls inotify opengl sdl ssl X xcb"

RDEPEND="
	directfb? ( >=dev-libs/DirectFB-0.9.16 )
	>=dev-libs/eet-1.3.2
	>=dev-libs/eina-0.9.9.49898
	ssl? ( dev-libs/openssl )
	sdl? ( media-libs/libsdl )
	gnutls? ( net-libs/gnutls )
	curl? ( net-misc/curl )
	opengl? ( virtual/opengl )
	>=x11-libs/evas-0.9.9.49898
	X? (
		x11-libs/libXcursor
		x11-libs/libXp
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXScrnSaver
		x11-libs/libXrender
		x11-libs/libXfixes
		x11-libs/libXdamage
	)
	xcb? ( x11-libs/xcb-util )"
DEPEND="${RDEPEND}
	X? (
		x11-proto/xproto
		x11-proto/xextproto
		x11-proto/printproto
		x11-proto/xineramaproto
		x11-proto/scrnsaverproto
	)"

src_compile() {
	export MY_ECONF="
		--enable-ecore-txt
		--enable-ecore-job
		--enable-ecore-evas-software-buffer
		--enable-ecore-evas
		--enable-ecore-con
		--enable-ecore-ipc
		--enable-ecore-config
		--enable-ecore-file
		$(use_enable inotify)
		$(use_enable xcb ecore-evas-xrender-xcb)
		--disable-ecore-x-xcb
		$(use_enable X ecore-x)
		$(use_enable X ecore-evas-software-16-x11)
		$(use_enable X ecore-evas-xrender-x11)
		$(use_enable opengl ecore-evas-opengl-x11)
		$(use_enable directfb ecore-directfb)
		$(use_enable directfb ecore-evas-directfb)
		$(use_enable fbcon ecore-fb)
		$(use_enable fbcon ecore-evas-fb)
		$(use_enable directfb ecore-evas-directfb)
		$(use_enable opengl ecore-evas-opengl-x11)
		$(use_enable opengl ecore_evas_opengl_glew)
		$(use_enable sdl ecore-evas-software-sdl)
		$(use_enable sdl ecore-sdl)
		$(use_enable ssl openssl)
		$(use_enable curl)
		$(use_enable gnutls)
	"
	enlightenment_src_compile
}
