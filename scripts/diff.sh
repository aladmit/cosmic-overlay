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

justfiles=(
	"cosmic-applets"
	"cosmic-applibrary"
	"cosmic-bg"
	"cosmic-edit"
	"cosmic-files"
	"cosmic-greeter"
	"cosmic-icons"
	"cosmic-idle"
	"cosmic-launcher"
	"cosmic-notifications"
	"cosmic-panel"
	"cosmic-randr"
	"cosmic-screenshot"
	"cosmic-settings"
	"cosmic-term"
)

Justfiles=(
	"cosmic-session"
)

Makefiles=(
	"cosmic-comp"
	"cosmic-osd"
	"cosmic-settings-daemon"
	"cosmic-workspaces-epoch"
	"xdg-desktop-portal-cosmic"
)

cd cosmic-epoch

for p in "${Justfiles[@]}"; do
	echo "${p}/Justfile"
	cd $p/
	git --no-pager diff --stat ${OLDTAG} ${NEWTAG} Justfile
	cd ../
done

for p in "${Makefiles[@]}"; do
	echo $p
	cd $p/
	git --no-pager diff --stat ${OLDTAG} ${NEWTAG} Makefile
	cd ../
done

for p in "${justfiles[@]}"; do
	echo $p
	cd $p/
	git --no-pager diff --stat ${OLDTAG} ${NEWTAG} justfile
	cd ../
done

