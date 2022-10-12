#!/usr/bin/python3
#
# Copyright © 2020 Dr. Tobias Quathamer <toddy@debian.org>
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

import json
from pathlib import Path
import subprocess
import sys

# Look for update information from a JSON file
needed_updates = []
json_filename = "needed-updates.json"
if Path(json_filename).exists():
    with open(json_filename) as input_file:
        needed_updates = json.loads(input_file.read())

# Set up information about translations and languages
translations = {}
pofiles = Path(".").glob("*/man*/*.po")
for pofile in pofiles:
    language = pofile.parents[1].name
    translation = "{}/{}".format(pofile.parent.name, pofile.name)
    if translation not in translations:
        translations[translation] = [language]
    else:
        translations[translation].append(language)

# Only update needed translations
for needed_update in needed_updates:
    if needed_update in translations:
        for language in translations[needed_update]:
            print(language, needed_update)
            subprocess.run(["./update-po.sh", needed_update], cwd=language)

# Remove information about updates
if Path("needed-updates.json").exists():
    Path("needed-updates.json").unlink()
