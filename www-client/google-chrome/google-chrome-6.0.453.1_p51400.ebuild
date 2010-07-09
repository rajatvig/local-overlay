# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils toolchain-funcs versionator

# Latest revision can be found at
# wget -qO- http://dl.google.com/linux/deb/dists/stable/main/binary-amd64/Packages|grep Filename

CHAN="unstable"
MY_P="${PN}-${CHAN}_${PV/_p/-r}"

DESCRIPTION="A browser that combines a minimal design with sophisticated technology (binary only)"
HOMEPAGE="http://www.google.com/chrome"

SRC_BASE="http://dl.google.com/linux/deb/pool/main/${PN:0:1}/${PN}-${CHAN}/"
SRC_URI="
	x86? ( ${SRC_BASE}${MY_P/-bin/}_i386.deb )
	amd64? ( ${SRC_BASE}${MY_P/-bin}_amd64.deb )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+suid +plugins-symlink"

LANGS="am ar bg bn ca cs da de el en_GB en_US es_419 es et fil fi fr gu he hi hr
	hu id it ja kn ko lt lv ml mr nb nl pl pt_BR pt_PT ro ru sk sl sr sv sw ta te th
	tr uk vi zh_CN zh_TW"

for l in ${LANGS} ; do
	IUSE="${IUSE} linguas_${l}"
done

DEPEND="|| (
		app-arch/xz-utils
		app-arch/lzma-utils
	)
	!~app-arch/deb2targz-1
	!www-client/google-chrome-bin"
RDEPEND="app-misc/ca-certificates
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/expat
	dev-libs/glib:2
    >=dev-libs/nspr-4.7
    >=dev-libs/nss-3.12.3
	gnome-base/gconf:2
	|| (
		media-fonts/liberation-fonts
		media-fonts/corefonts
	)
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2
	<media-libs/jpeg-7
	=media-libs/libpng-1.2*
	sys-apps/dbus
	>=sys-devel/gcc-4.2[-nocxx]
	>=sys-libs/glibc-2.6
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/pango
	x11-misc/xdg-utils"

# Incompatible system plugins:
# www-plugins/gecko-mediaplayer, bug #309231.
RDEPEND+="plugins-symlink? (
		!www-plugins/gecko-mediaplayer[gnome]
	)"

RESTRICT="primaryuri strip"

QA_EXECSTACK="opt/google/chrome/chrome"
QA_PRESTRIPPED="opt/google/chrome/chrome
	opt/google/chrome/chrome-sandbox
	opt/google/chrome/libffmpegsumo.so
	opt/google/chrome/libgcflashplayer.so"

QA_TEXTRELS="opt/google/chrome/libffmpegsumo.so"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.lzma
}

src_install() {
	local CHROME_HOME="/opt/google/chrome"
	local nss_subdir=$(has_version ">=dev-libs/nss-3.12.5-r1" || echo nss/)
	local nspr_subdir=$(has_version ">=dev-libs/nspr-4.8.3-r3" || echo nspr/)

	mv "${WORKDIR}"/{opt,usr} "${D}" || die

	if use suid; then
		fperms 4755 "${CHROME_HOME}"/chrome-sandbox
	else
		rm "${D}${CHROME_HOME}"/chrome-sandbox
	fi

	for i in ${nss_subdir}lib{nss{,util},smime,ssl}3.so.1d \
				${nspr_subdir}lib{pl{ds,c},nspr}4.so.0d ; do
		dosym /usr/$(get_libdir)/${i%.*} \
			${CHROME_HOME}/${i##*/}
	done

	domenu "${D}${CHROME_HOME}/${PN}.desktop"
	rm "${D}${CHROME_HOME}/${PN}.desktop"

	# Copy icon into system-wide location
	newicon "${D}${CHROME_HOME}/product_logo_256.png" "${PN}.png" || die "newicon failed"

	# Plugins symlink, optional wrt bug #301911
	if use plugins-symlink; then
		dosym "/usr/$(get_libdir)/nsbrowser/plugins" "${CHROME_HOME}/plugins"
	fi

	# Only remove unwanted locales if LINGUAS is set.
	if ! [[ -z ${LINGUAS} ]] ; then
		for l in ${LANGS} ; do
			if ! use linguas_${l} ; then
				rm ${D}${CHROME_HOME}/locales/${l/_/-}.pak || die
			fi
		done
	fi
}

pkg_postinst() {
    elog "This Chrome binary package is from the developer preview channel.  It is"
    elog "not guaranteed to be stable or even usable."
    elog ""
	elog "Chrome's auto-update mechanism has been disabled."
	elog "It is only available for Debian and RPM based distributions."
	elog ""
	elog "Please see"
	elog "	http://dev.chromium.org/for-testers/bug-reporting-guidlines-for-the-mac-linux-builds"
	elog "before filing any bugs."
	if ! version_is_at_least 4.2 "$(gcc-version)" || [[ -z $(tc-getCXX) ]]; then
		einfo ""
		ewarn "This Chrome binary package depends on C++ libraries from >=sys-devel/gcc-4.2,"
		ewarn "which do not appear to be available.  Google Chrome may not run."
		ebeep
	fi
}
