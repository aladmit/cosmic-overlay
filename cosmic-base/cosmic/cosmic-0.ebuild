EAPI=8

DESCRIPTION="Meta package to install cosmic-epoch DE"
KEYWORDS="arm64 amd64"

SLOT="0"

RDEPEND="
	media-fonts/fira-mono
	media-fonts/fira-sans
	media-fonts/roboto

	cosmic-base/cosmic-applets
	cosmic-base/cosmic-applibrary
	cosmic-base/cosmic-bg
	cosmic-base/cosmic-comp
	cosmic-base/cosmic-edit
	cosmic-base/cosmic-files
	cosmic-base/cosmic-icons
	cosmic-base/cosmic-launcher
	cosmic-base/cosmic-notifications
	cosmic-base/cosmic-osd
	cosmic-base/cosmic-panel
	cosmic-base/cosmic-randr
	cosmic-base/cosmic-session
	cosmic-base/cosmic-settings
	cosmic-base/cosmic-settings-daemon
"
	# cosmic-base/pop-gtk-theme
	# cosmic-base/pop-icon-theme
	#
	# cosmic-base/cosmic-screenshot
	# cosmic-base/cosmic-term
	# cosmic-base/cosmic-workspaces
	# cosmic-base/cosmic-xdg-desktop-portal
