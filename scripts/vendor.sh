#!/bin/bash

set -e
set -u
set -o pipefail

version="1.0.0_alpha_rc4" # version name for this revision
latest=0 # update all submodules to latest version

packages=(
	"cosmic-applets"
	"cosmic-applibrary"
	"cosmic-bg"
	"cosmic-comp"
	"cosmic-edit"
	"cosmic-files"
	"cosmic-greeter"
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
	"cosmic-workspaces-epoch"
	"xdg-desktop-portal-cosmic"
)

rm -rf cosmic-epoch vendored
git clone --recurse-submodules git@github.com:pop-os/cosmic-epoch.git
mkdir vendored

cd cosmic-epoch
if [ $latest -eq 1 ]; then
	git submodule update --remote --merge
fi

vendored=""	# string to print info about vendored packages at the end
for p in "${packages[@]}"
do
	cd $p/
		cargo vendor | head -n -0 > config.toml
		XZ_OPT='-T0 -8' tar -acf "${p}-${version}-vendor.tar.xz" vendor config.toml
		mv "${p}-${version}-vendor.tar.xz" ../../vendored/
		rm -rf vendor config.toml
		vendored+="${p}\t$(git rev-parse HEAD)\n"
	cd ../
done

printf $vendored | column --table --table-columns "PACKAGE, COMMIT" -s $'\t' | tee ../vendored/index
