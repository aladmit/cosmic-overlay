#!/bin/bash

set -e
set -u
set -o pipefail

version="0_pre20240506" # version name for this revision
latest=0                # update all submodules to latest version
vendored=""							# string to print info about packages at the end

packages=(
	"cosmic-applets"
	"cosmic-applibrary"
	"cosmic-bg"
	"cosmic-comp"
	"cosmic-edit"
	"cosmic-files"
	"cosmic-greeter"
	"cosmic-icons"
	"cosmic-launcher"
	"cosmic-notifications"
	"cosmic-osd"
	"cosmic-panel"
	"cosmic-randr"
	"cosmic-screenshot"
	"cosmic-session"
	"cosmic-settings-daemon"
	"cosmic-settings"
	"cosmic-term"
	"cosmic-workspaces-epoch"
	"xdg-desktop-portal-cosmic"
)

rm -rf cosmic-epoch
git clone --recurse-submodules git@github.com:pop-os/cosmic-epoch.git

cd cosmic-epoch
if [ $latest -eq 1 ]; then
	git submodule update --remote --merge
fi

for p in "${packages[@]}"
do
	cd $p/
		cargo vendor | head -n -0 > config.toml
		XZ_OPT='-T0 -8' tar -acf "${p}-${version}-vendor.tar.xz" vendor config.toml
		rm -rf vendor config.toml
		vendored+="${p}\t$(git rev-parse HEAD)\n"
	cd ../
done

printf $vendored | column --table --table-columns "PACKAGE, COMMIT" -s $'\t'
