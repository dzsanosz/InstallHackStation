#!/bin/bash

# Get script source path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if script is running with sudo privileges
function check_priv {
	if [[ $EUID -ne 0 ]]; then
		echo "Please run this script with sudo!" 
		exit 1
	fi
}

# Get the system up-to-date and install essential packages
function update {
	apt update && apt full-upgrade -y
	# TODO Enrich this list
	apt install git tmux forensics-extra rlwrap steghide seclist wfuzz
}

# Clone some useful tool from github
function get_github_tools {
	(
		cd /opt
		for tool in $(cat $DIR/git_tool_list.txt);
		do
			git clone --recurse $tool
		done
	)
}

# Call functions
echo "Start building the environment..."
check_priv
update
get_github_tools
