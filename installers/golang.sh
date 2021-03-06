#!/bin/bash

action="install"
go_version="1.18.1"

. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/colors.sh) --

function option_value() {
  echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g';
}

function install() {
  echo -e "${C_LGn}GO installation...${RES}"
  if ! go version | grep -q $go_version; then
	  sed -i "s%:`which go | sed 's%/bin/go%%g'`%%g" $HOME/.bash_profile
		rm -rf `which go | sed 's%/bin/go%%g'`
		sudo apt update
		sudo apt upgrade -y
		sudo apt install tar wget git make -y
		cd "$HOME"
		wget -t 5 "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
		sudo rm -rf /usr/local/go
		sudo tar -C /usr/local -xzf "go${go_version}.linux-amd64.tar.gz"
		rm "go${go_version}.linux-amd64.tar.gz"
		. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/addvar.sh) -n "PATH" -v "$PATH:/usr/local/go/bin:$HOME/go/bin"
	fi
}

function uninstall() {
	echo -e "${C_LGn}GO uninstalling...${RES}"
	sed -i "s%:`which go | sed 's%/bin/go%%g'`%%g" "$HOME"/.bash_profile
	rm -rf `which go | sed 's%/bin/go%%g'`
}

while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script installs or uninstalls GO"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h, --help             show the help page"
		echo -e "  -v, --version VERSION  GO VERSION to install (default is ${C_LGn}${go_version}${RES})"
		echo -e "  -u, --uninstall        uninstall GO"
		echo
		echo -e "You can use either \"=\" or \" \" as an option and value ${C_LGn}delimiter${RES}"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://raw.githubusercontent.com/letsnode/Utils/main/installers/golang.sh - script URL"
		echo -e "https://t.me/letskynode — node Community"
		echo -e "https://teletype.in/@letskynode — guides and articles"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-v*|--version*)
		if ! grep -q "=" <<< "$1"; then shift; fi
		go_version=`option_value "$1"`
		shift
		;;
	-u|--uninstall)
		action="uninstall"
		shift
		;;
	*|--)
		break
		;;
	esac
done

$action

. "$HOME"/.bash_profile

echo -e "${C_LGn}Done!${RES}"
