#!/bin/sh
# Ensure the user and group for running the synapse server exist

USERNAME=${1}
GROUPNAME=${2}

ensure_user_and_group_exist() {
	# create a system user
	echo "+ Verifying group ""$GROUPNAME"" and user ""$USERNAME"" exist..."

	getent group $GROUPNAME > /dev/null
	if [ $? -gt 0 ]; then
		echo "  Group ""$GROUPNAME"" does not exist -- creating."
		groupadd -r $GROUPNAME
	else
		echo "  Group ""$GROUPNAME"" already exists."
	fi

	getent passwd $USERNAME > /dev/null
	if [ $? -gt 0 ]; then
		echo "  User ""$USERNAME"" does not exist -- creating."
		useradd --system --base-dir /var/lib --shell /bin/false -g $GROUPNAME $USERNAME
	else
		echo "  User ""$USERNAME"" already exists."
	fi
}

ensure_user_and_group_exist
