# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils
SRC_URI="http://download.racket-lang.org/installers/${PV}/${PN}/${P}-src-unix.tgz"
DESCRIPTION="Programming environment based on Scheme."
HOMEPAGE="http://www.racket-lang.org"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-backtrace cairo cgc doc opengl profile X slatex sgc -futures -places +foreign static -plain"
# jit
RDEPEND="X? ( x11-libs/libX11
			x11-libs/libXaw
			x11-libs/libXft
			x11-libs/libXrender
			media-libs/jpeg
			media-libs/libpng
			opengl? ( virtual/opengl )
			cairo? ( x11-libs/cairo[X] ) )
		slatex? ( virtual/latex-base )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/plt-${PV}/src/build"
ECONF_SOURCE="${S}/.."
MY_PNUM="01"

pkg_setup() {
	if use cgc && use sgc ; then
		die "You cannot use both cgc and sgc USE flags, you have to choose one of them"
	fi
	for my_flag in backtrace futures places
	do
		if use "${my_flag}" ; then
			ewarn "${my_flag} USE flag is known that may make ${P} compilation"
			ewarn "to fail. Please remove it, if the ebuild fails for you. "
		fi
	done
	if use cairo || use opengl ; then
		if ! use X ; then
			ewarn "cairo and opengl USE flags support features that are disabled"
			ewarn "by ${P} build system when you haven't enabled the X USE flag."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	mkdir -v "${S}" || die "failed to create build dir"
}

src_prepare() {
	#( cd .. && rm -Rv wxcommon && rm -Rv foreign ) \
	#|| die "failed to remove dir of bundled libraries"
	#rm -Rv ../wxcommon/{jpeg,libpng,zlib} ../../collects  \
	#|| die "failed to remove dir of bundled libraries"
	#rm -Rv ../wxcommon/{jpeg,libpng,zlib} ../wxxt \
	rm -Rv ../wxcommon/{jpeg,libpng,zlib} \
	|| die "failed to remove dir of bundled libraries"
	sed -i -e "s/docdir=\"\${datadir}\/racket\/doc\"/docdir=\"\${datadir}\/doc\/${PF}\"/" ../configure || die "sed failed"
	pushd ..
	epatch "${FILESDIR}/${P}-hack_makefile_in_temp${MY_PNUM}.patch"
	epatch "${FILESDIR}/${P}-libpng14.patch"
	epatch "${FILESDIR}/${P}-fix-noplaces-sighand.patch"
	epatch "${FILESDIR}/${P}-rename-gc.patch"
	epatch "${FILESDIR}/${P}-thread-gc-backtrace.patch"
	popd
	#sed -i -e 's/#! \/bin\/sh/#! \/bin\/sh -x/g' ../configure \
	#|| die "sed failed"
}

src_configure() {
	local myconf=""
	if use static; then
		myconf="--disable-shared"
	else
		myconf="--enable-shared"
	fi
	econf \
		$(use_enable doc docs) \
		$(use_enable X gracket) \
		$(use_enable X xrender) \
		$(use_enable X xft) \
		$(use_enable opengl gl) \
		$(use_enable cairo) \
		$(use_enable profile gprof) \
		$(use_enable backtrace) \
		$(use_enable sgc) \
		$(use_enable futures) \
		$(use_enable places) \
		$(use_enable foreign) \
		--enable-jit \
		--enable-libpng \
		--enable-libjpeg \
		--enable-pthread \
		--enable-account \
		--disable-sgcdebug \
		--disable-compact \
		--disable-smalloskit \
		--disable-oskit \
		--disable-wbuild \
		--disable-perl \
		$(use_with X x) \
		${myconf} \
		|| die "Configure script failed"
}

src_compile() {
	emake || die "emake default target(3m) failed"
	if use cgc || use sgc ; then
		time emake cgc || die "emake cgc-install target failed"
	fi
}

src_install() {
	local pla1n=""
	if use plain; then
		pla1n="plain-"
	fi
	time emake DESTDIR="${D}" "${pla1n}"install || die "emake install failed"
	if use cgc || use sgc ; then
		time emake DESTDIR="${D}" "${pla1n}"install-cgc || die "emake cgc target failed"
	fi
	if use X; then
		newicon ../../collects/icons/PLT-206.png drscheme.png
		make_desktop_entry drscheme "DrScheme" drscheme "Development"
	fi
	# deal with slatex
	if use slatex; then
		if ! use plain; then
			pushd "${D}"/usr/bin
			{ rename slatex plt-slatex slatex* && rename pdf-slatex plt-pdf-slatex pdf-slatex* ; } || die "Failed to rename slatex* to plt-slatex*"
			popd
		fi
		insinto /usr/share/texmf/tex/latex/slatex/
		newins ../../collects/slatex/slatex.sty plt-slatex.sty
	else
		if ! use plain; then
			rm -Rfv "${D}"/usr/bin/*slatex* || die "Failed to delete slatex files"
		fi
	fi
}
