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

# Filter out the 'common' directory
pofiles = $(sort $(wildcard $(srcdir)/man*/*.po))
manpages = $(addprefix $(distribution)/, $(patsubst %.po,%, $(pofiles)))

MOSTLYCLEANFILES = $(manpages)

# Common rules for all manpage sections
$(distribution)/%: %.po
	$(srcdir)/../generate-manpage.sh $(distribution) $<

# Generate all localized manpages for given distribution
all-local: $(manpages)

# Install localized manpages for given distribution
install-data-hook: $(manpages)
	for directory in $(srcdir)/$(distribution)/man*; do \
		mansection=$$(basename $$directory) ; \
		$(mkinstalldirs) $(DESTDIR)$(mandir)/$(LANGUAGE)/$$mansection ; \
	done
	for manpage in $(manpages); do \
		if test ! -f "$$manpage"; then \
			continue ; \
		fi ; \
		filename=$$(basename $$manpage) ; \
		mansection=$$(basename $$(dirname $$manpage)) ; \
		$(INSTALL_DATA) $$manpage $(DESTDIR)$(mandir)/$(LANGUAGE)/$$mansection ; \
		if test "$(compressor)" != "none" ; then \
			$(compressor) $(DESTDIR)$(mandir)/$(LANGUAGE)/$$mansection/$$filename ; \
		fi ; \
	done
	perl $(top_srcdir)/create-links.pl $(DESTDIR)$(mandir)/$(LANGUAGE) $(comp_extension) \
		$(top_srcdir)/upstream/$(distribution)/links.txt

# Uninstall localized manpages for given distribution
uninstall-hook:
	for link in $$(cut -d" " -f2 $(top_srcdir)/upstream/$(distribution)/links.txt); do \
		rm -f $(DESTDIR)$(mandir)/$(LANGUAGE)/$$link$(comp_extension) ; \
	done
	for manpage in $(manpages); do \
		filename=$$(basename $$manpage) ; \
		mansection=$$(basename $$(dirname $$manpage)) ; \
		rm -f $(DESTDIR)$(mandir)/$(LANGUAGE)/$$mansection/$$filename$(comp_extension) ; \
	done

# Reformat all .po files and commit changes
.PHONY: reformat
reformat:
	$(srcdir)/../format-po.sh ; \
	git commit -m "Reformat .po files, no content changes" . || true

# Reformat all .po files and commit changes
.PHONY: update-po
update-po: reformat
	$(srcdir)/../update-translations.sh ; \
	git commit -m "Update .po files from templates and common messages" . || true
