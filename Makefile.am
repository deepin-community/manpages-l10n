# Makefile for manpages-l10n
#
# Copyright © 2012-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

SUBDIRS = po

# Download and update all upstream manpages
.PHONY: update-upstream
update-upstream:
	cd $(top_srcdir)/upstream ; \
	./update-distribution-manpages.sh ; \
	git add . ; \
	git commit -m "Update upstream manpages" || true

# Update all template files from upstream manpages.
.PHONY: update-templates
update-templates:
	cd $(top_srcdir)/templates ; \
	./update-all-templates.py ; \
	git add . ; \
	git commit -m "Update templates" || true ; \
	./create-common-templates.sh ; \
	git add . ; \
	git commit -m "Update common templates" || true ; \
	cd .. ; \
	cd $(top_srcdir)/po ; \
	./update-common.sh ; \
	git add . ; \
	git commit -m "Update common messages from templates" || true

# Update all translations from templates.
.PHONY: update-translations
update-translations:
	cd $(top_srcdir)/po ; \
	$(MAKE) update-po

# Export the current git tree into the tarball directory
dist-hook:
	git archive --format=tar v$(VERSION) | (cd $(distdir) && tar xf -)
