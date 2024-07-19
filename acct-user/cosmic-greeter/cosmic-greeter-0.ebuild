EAPI=7

inherit acct-user

DESCRIPTION="Cosmic Greeter Account"
ACCT_USER_GROUPS=( "cosmic-greeter" "video" )
ACCT_USER_ID=543
ACCT_USER_HOME=/var/lib/cosmic-greeter

acct-user_add_deps
