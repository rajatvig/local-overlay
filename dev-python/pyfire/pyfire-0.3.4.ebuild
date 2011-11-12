# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit bash-completion-r1 distutils eutils

DESCRIPTION="A Python implementation of the Campfire API"
HOMEPAGE="http://github.com/mariano/pyfire"
SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND} dev-python/PyQt4"

src_prepare() {
	distutils_src_prepare
}

src_install() {
	distutils_src_install
}
