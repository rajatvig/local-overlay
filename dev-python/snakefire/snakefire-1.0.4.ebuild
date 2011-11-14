# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Snakefire is a desktop client for Campfire that can run on Linux, and any other OS that has QT support."
HOMEPAGE="http://snakefire.org/"
SRC_URI="http://snakefire.org/downloads/${PN}-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND} dev-python/pyenchant dev-python/pyfire dev-python/PyQt4"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
}
