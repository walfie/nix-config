#!/usr/bin/env python3

import plistlib
import io
import os
import sys
import copy
import subprocess
import urllib.parse
import pwd
import tempfile

DOMAIN = 'com.apple.dock'
PERSISTENT_APPS = 'persistent-apps'
FILE_PROTOCOL = 'file://'

def reloadDock():
    subprocess.call(['/usr/bin/killall', 'Dock'])

def getLabel(app_path):
    return os.path.splitext(os.path.basename(app_path.rstrip('/')))[0]

def makeDockAppEntry(app_path):
    path_with_protocol = FILE_PROTOCOL + urllib.parse.quote(app_path)

    if not path_with_protocol.endswith('/'):
        path_with_protocol += '/'

    return {
        'tile-type': 'file-tile',
        'tile-data': {
            'file-label': getLabel(app_path),
            'file-type': 41,
            'file-data': {
                '_CFURLString': path_with_protocol,
                '_CFURLStringType': 15
            }
        }
    }

def getUrlFromEntry(entry):
    return entry['tile-data']['file-data']['_CFURLString']

def getPathFromEntry(entry):
    url = getUrlFromEntry(entry)
    if url.startswith(FILE_PROTOCOL):
        return url[len(FILE_PROTOCOL):]
    else:
        return url

def readPlist():
    defaults_export = subprocess.Popen(['defaults', 'export', DOMAIN, '-'], stdout = subprocess.PIPE)
    return plistlib.load(defaults_export.stdout, fmt = plistlib.FMT_XML)

def writePlist(pl):
    defaults_import = subprocess.Popen(['defaults', 'import', DOMAIN, '-'], stdin = subprocess.PIPE)
    plistlib.dump(pl, defaults_import.stdin, fmt = plistlib.FMT_XML)

def main(paths_to_add, is_dry_run):
    added = []
    removed = []
    def generateDockItems(existing, new_paths):
        items_to_add = list(map(makeDockAppEntry, new_paths))

        for item in existing:
            url = item['tile-data']['file-data']['_CFURLString']
            if url.startswith('file:///nix/'):
                matched = False

                # This is a managed dock item, so we should check if it matches
                # with one that we want to add
                for index, item_to_add in reversed(list(enumerate(items_to_add))):
                    if url == getUrlFromEntry(item_to_add):
                        # It's the exact same URL, so keep the old one
                        matched = True
                        del items_to_add[index]
                        yield item

                    elif item['tile-data']['file-label'] == item_to_add['tile-data']['file-label']:
                        matched = True
                        added.append(item_to_add)
                        removed.append(item)
                        del items_to_add[index]
                        yield item_to_add

                if not matched:
                    removed.append(item)
            else:
                # Not a nix path, so do nothing
                yield item

        for item_to_add in items_to_add:
            added.append(item_to_add)
            yield item_to_add

    dock = readPlist()
    dock[PERSISTENT_APPS] = list(generateDockItems(dock[PERSISTENT_APPS], paths_to_add))

    for item in removed:
        print('Removing item from dock: ' + getPathFromEntry(item))
    for item in added:
        print('Adding item to dock: ' + getPathFromEntry(item))

    if (added or removed) and (not is_dry_run):
        writePlist(dock)
        reloadDock()


if __name__ == "__main__":
    paths_to_add = list(sys.argv[1:])
    is_dry_run = os.environ.get('DRY_RUN') is not None

    for path in paths_to_add:
        if not (path.endswith('.app') or path.endswith('.app/')):
            print('Error: expected `' + path + '` to have an `.app` extension', file = sys.stderr)
            sys.exit(-1)

    main(paths_to_add, is_dry_run)

