#!/bin/bash

set -e
set -u
set -o pipefail

if [[ $# -ne 2 ]]; then
	echo "bump-epoch.sh <CURRENT VERSION> <NEW VERSION>" >&2
	echo "bump-epoch.sh 1.0.0_alpha_rc1 1.0.0_alpha_rc2_pre20240817" >&2
	exit 1
fi

CV=$1
NV=$2

if [ ! -d "cosmic-epoch" ]; then
	echo "desired cosmic-epoch repo should be cloned to ./cosmic-epoch" >&2
	exit 1
fi

echo "Bumping from ${CV} to ${NV}."
echo "Script will ask for sudo password to run ebuild command."

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

	
for p in "${packages[@]}"
do
	echo -ne "Bumping ${p} ebuild..."

	if [ "${p}" == "cosmic-workspaces" ]; then
		cd "cosmic-epoch/cosmic-workspaces-epoch"
		commit=$(git rev-parse HEAD)
		cd ../../
	else
		cd "cosmic-epoch/${p}"
		commit=$(git rev-parse HEAD)
		cd ../../
	fi

	cp "../cosmic-base/${p}/${p}-${CV}.ebuild" "../cosmic-base/${p}/${p}-${NV}.ebuild"
	sed -i "s/COMMIT=\".*\"/COMMIT=\"${commit}\"/" ../cosmic-base/${p}/${p}-${NV}.ebuild
	echo "DONE"

	echo -ne "Updating manifest for ${p}-${NV}..."
	sudo ebuild "../cosmic-base/${p}/${p}-${NV}.ebuild" manifest > /dev/null
	echo "DONE"
done

echo "All ebuilds bumped!"
