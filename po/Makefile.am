# Makefile for manpages-l10n
#
# Copyright © 2017-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

SUBDIRS = cs da de es fr nl it mk pl pt_BR ro


# Reformat all .po files and commit changes
.PHONY: reformat
reformat:
	for d in $(SUBDIRS) ; do \
		cd $$d && make reformat && cd .. ; \
	done

# Reformat and update all .po files and commit changes
.PHONY: update-po
update-po: reformat
	$(srcdir)/update-translations.py ; \
	git commit -m "Update .po files from templates and common messages" . || true
