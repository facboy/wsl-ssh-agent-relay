#!/bin/bash

if [[ $# -lt 1 ]]; then
	echo "Expected at least 1 arg: <command> ..."
	exit 255
fi

COMMAND=$1

RELAY_BIN="/mnt/c/Bin/npiperelay/npiperelay.exe"
WSL_AGENT_SSH_SOCK="${HOME}/.ssh/wsl-ssh-agent.sock"

case "${COMMAND}" in
	'startpre')
		if [[ -e "${WSL_AGENT_SSH_SOCK}" ]]; then
			echo "WSL has been shutdown ungracefully, leaving garbage behind"
		    rm "${WSL_AGENT_SSH_SOCK}"
		fi
		;;
	'start')
		exec socat UNIX-LISTEN:"\"${WSL_AGENT_SSH_SOCK}\"",fork EXEC:"\"\'${RELAY_BIN}\' -ei -s \'//./pipe/openssh-ssh-agent\'\"",nofork 1>/dev/null 2>&1
		;;
	'startpost')
		echo "Relay is running with PID: ${MAINPID}"
		;;
	'stoppost')
		rm "${WSL_AGENT_SSH_SOCK}"
		;;
	*)
        echo "Invalid command: ${COMMAND}"
        exit 255
        ;;
esac
