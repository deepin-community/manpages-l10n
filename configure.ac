# Configuration for manpages-l10n
#
# Copyright © 2012 Dr. Tobias Quathamer <toddy@debian.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

AC_INIT(manpages-l10n, [4.11.0])

AM_INIT_AUTOMAKE([foreign dist-xz no-dist-gzip])

# Add option for selection of distribution
AC_ARG_ENABLE([distribution],
  AS_HELP_STRING([--enable-distribution=DIST],
    [Enable translations for specific distribution. @<:@default=debian-unstable@:>@.]
  ),
  ,
  [enable_distribution="debian-unstable"]
)

# Show the wanted distribution
AC_MSG_CHECKING([name of wanted distribution])
AC_MSG_RESULT([$enable_distribution])

# Check if the wanted distribution has
# own translations in an upstream directory
AC_MSG_CHECKING([that "$enable_distribution" has own translations])
AS_IF([test -d "upstream/$enable_distribution"],
  [AC_MSG_RESULT([yes])],
  [
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([there are no translations for "$enable_distribution".])
  ]
)
AC_SUBST([distribution], [$enable_distribution])

# Add option for compression of translated manpages
AC_ARG_ENABLE([compression],
  AS_HELP_STRING([--enable-compression=COMP],
    [Enable compression for translated manpages.
     Supported values are gzip, bzip2, xz, and none.
     @<:@default=gzip@:>@.]
  ),
  ,
  [enable_compression="gzip"]
)

# Show the wanted compression
AC_MSG_CHECKING([compression for translated manpages])
AC_MSG_RESULT([$enable_compression])

# Check if the wanted compression is supported by this package
AC_MSG_CHECKING([that "$enable_compression" is supported])
AS_IF(
  [test "$enable_compression" = "gzip"],
  [
    AC_MSG_RESULT([yes])
    AC_PATH_PROG([compressor], [gzip], [no])
    AS_IF([test "x$compressor" = "xno"],
      [AC_MSG_ERROR([You need to install gzip])]
    )
    AC_SUBST([comp_extension], [.gz])
  ],
  [test "$enable_compression" = "bzip2"],
  [
    AC_MSG_RESULT([yes])
    AC_PATH_PROG([compressor], [bzip2], [no])
    AS_IF([test "x$compressor" = "xno"],
      [AC_MSG_ERROR([You need to install bzip2])]
    )
    AC_SUBST([comp_extension], [.bz2])
  ],
  [test "$enable_compression" = "xz"],
  [
    AC_MSG_RESULT([yes])
    AC_PATH_PROG([compressor], [xz], [no])
    AS_IF([test "x$compressor" = "xno"],
      [AC_MSG_ERROR([You need to install xz])]
    )
    AC_SUBST([comp_extension], [.xz])
  ],
  [test "$enable_compression" = "none"],
  [
    AC_MSG_RESULT([yes])
    AC_SUBST([compressor], [none])
    AC_SUBST([comp_extension], ["''"])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([compression "$enable_compression" is not supported by manpages-de.])
  ]
)

# Check that po4a is available on the system
AC_PATH_PROG([po4a], [po4a], [no])
AS_IF([test "x$po4a" = "xno"],
  [AC_MSG_ERROR([You need to install po4a])]
)

AC_CONFIG_FILES([
    Makefile
    po/Makefile
    po/cs/Makefile
    po/da/Makefile
    po/de/Makefile
    po/es/Makefile
    po/fr/Makefile
    po/hu/Makefile
    po/it/Makefile
    po/mk/Makefile
    po/nl/Makefile
    po/pl/Makefile
    po/pt_BR/Makefile
    po/ro/Makefile
])

AC_OUTPUT
