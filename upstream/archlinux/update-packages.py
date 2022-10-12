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
import os
import re
import shutil
import subprocess
import sys
import urllib.request


# Read package information from a JSON file, if available
package_data = {}
if os.path.exists("downloads/packages.json"):
    with open("downloads/packages.json") as input_file:
        package_data = json.loads(input_file.read())

# Read all packages names
page_buffer = {}
with open("packages.txt") as input_file:
    for line in input_file:
        repo, package = line.strip().split(" ")

        # Download HTML page and discover the correct link
        print("Checking package '{}' from '{}' ... ".format(package, repo), end="")

        if not repo in page_buffer:
            download_page = urllib.request.urlopen("https://mirror.netcologne.de/archlinux/{}/os/x86_64/".format(repo))
            page_buffer[repo] = download_page.read().decode()
            download_page.close()
        contents = page_buffer[repo]

        # search for <pkgname>-[<epoch>:]<version>-<release>-<architecture>.pkg.tar.<compression>
        package_url = re.findall(r"\"({}-(?:[0-9]*%3A)?(?:[0-9a-z._%B]+)-(?:[0-9]+)-(?:any|x86_64)\.pkg\.tar\.[^.\"]+)".format(package), contents)
        # Ensure unique values and use the latest version (sort alphabetically)
        package_url = list(set(package_url))
        package_url.sort()
        package_url = "https://mirror.netcologne.de/archlinux/{}/os/x86_64/{}".format(repo, package_url[-1])

        package_filename = re.split(r"/", package_url)[-1]

        # If the latest download is already available, skip this package
        if package in package_data:
            if package_data[package]['filename'] == package_filename:
                print("current.")
                continue

        # Store information about downloaded package
        package_data[package] = {
            'filename': package_filename,
            'needs_templates': True,
            'needs_update': True,
        }

        # Prepare for downloading the file
        package_dir = "downloads/{}".format(package)
        local_filename = "downloads/{}/{}".format(package, package_filename)

        # Ensure there are no leftovers of previous packages
        os.makedirs(package_dir, exist_ok=True)
        shutil.rmtree(package_dir)
        os.makedirs(package_dir, exist_ok=True)

        # Download new package
        urllib.request.urlretrieve(package_url, local_filename)
        print("downloaded.")

        # Get the exact filename of data.tar with the extension
        os.makedirs("{}/tmp".format(package_dir), exist_ok=True)

        # Extract the package into a temporary directory
        subprocess.run(["tar", "xaf", local_filename, "--directory={}/tmp".format(package_dir)])

        # Move the manpages up
        manpath = "{}/tmp/usr/share/man".format(package_dir)
        for mandir in os.listdir(manpath):
            if not mandir.startswith("man"):
                continue
            # Make sure the directory exists
            os.makedirs(mandir, exist_ok=True)
            shutil.move(
                "{}/{}".format(manpath, mandir),
                "{}".format(package_dir)
            )

        # Cleanups
        shutil.rmtree("downloads/{}/tmp".format(package))
        os.remove(local_filename)

# Save package information in a JSON file
with open("downloads/packages.json", "w") as output_file:
    output_file.write(json.dumps(package_data, sort_keys=True, indent=4))
