#!/bin/bash

set -e
set -u
set -o pipefail

if [[ $# -ne 2 ]]; then
	echo "This script shows dependency changes from original debian packages" >&2
	echo "depdiff.sh <OLD TAG> <NEW TAG>" >&2
	echo "depdiff.sh epoch-1.0.0-alpha.2 epoch-1.0.0-alpha.3" >&2
	exit 1
fi

OLDTAG=$1
NEWTAG=$2

if [ ! -d "cosmic-epoch" ]; then
	echo "cosmic-epoch repo should be cloned to ./cosmic-epoch" >&2
	exit 1
fi

packages=(
	"cosmic-applets"
	"cosmic-applibrary"
	"cosmic-bg"
	"cosmic-comp"
	"cosmic-edit"
	"cosmic-files"
	"cosmic-greeter"
	"cosmic-icons"
	"cosmic-idle"
	"cosmic-launcher"
	"cosmic-notifications"
	"cosmic-osd"
	"cosmic-panel"
	"cosmic-randr"
	"cosmic-screenshot"
	"cosmic-session"
	"cosmic-settings"
	"cosmic-settings-daemon"
	"cosmic-term"
	"cosmic-workspaces"
	"xdg-desktop-portal-cosmic"
)

LIST=${packages[@]}
DEPS_FILES=${LIST// //debian/control }

cd cosmic-epoch
git diff ${OLDTAG} ${NEWTAG} -- cosmic-applets/justfile
git diff ${OLDTAG} ${NEWTAG} -- cosmic-session/justfile
git diff ${OLDTAG} ${NEWTAG} -- ${DEPS_FILES}
