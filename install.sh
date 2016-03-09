#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# reboard v1.0 [ easy reboot or shutdown routerboard ]
# ----------------------------------------------------- #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1


# help function
function help_f {
	echo 'Usage: '
	echo '	sudo ./install.sh -i [install program]'
	echo '	sudo ./install.sh -u [help to uninstall program]'
	echo '	sudo ./install.sh -c [check dependencies]'
}


# install program on system
function install_f {
	[ ! -d /opt/reboard_v1/ ] && mkdir -p /opt/reboard_v1/ && echo "[+] Directory created" || echo "[-] Error: /opt/reboard_v1/ exist"
	sleep 1
	[ ! -f /opt/reboard_v1/reboard.sh ] && cp reboard.sh /opt/reboard_v1/ && chmod 755 /opt/reboard_v1/reboard.sh && echo "[+] reboard.sh copied" || echo "[-] Error: /opt/reboard_v1/reboard.sh exist"
	sleep 1
	[ ! -f /opt/reboard_v1/reboard.database.en ] && cp reboard.database.en /opt/reboard_v1/reboard.database.en && chown root:root /opt/reboard_v1/reboard.database.en && chmod 700 /opt/reboard_v1/reboard.database.en && echo "[+] reboard.database.en copied" || echo "[-] Error: /opt/reboard_v1/reboard.database.en exist"
	sleep 1
	[ -f /opt/reboard_v1/reboard.sh ] && ln -s /opt/reboard_v1/reboard.sh /usr/bin/reboard && echo "[+] Symbolic link created" || echo "[-] Error: symbolic link not created"
	sleep 1
	[ ! -f /opt/reboard_v1/README ] && cp README /opt/reboard_v1/README && chmod 644 /opt/reboard_v1/README && echo "[+] README copied" || echo "[-] Error: /opt/reboard_v1/README exist"
	sleep 1

	echo "[+] Please see README"
	sleep 0.5
	echo "[!] Warning: run program and edit your database."
	sleep 0.5
	echo "[!] Warning: defaul password is 'reboard'"
	sleep 0.5
	echo "[+] Done"
}


# uninstall program from system
function uninstall_f {
	echo 'For uninstall program:'
	echo '	sudo rm -rf /opt/reboard_v1/'
	echo '	sudo rm -f /usr/bin/reboard'
}


# check dependencies on system
function check_f {
	echo "[+] check dependencies on system:  "
	for program in whoami sleep cat head tail cut nano openssl sshpass
	do
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo -e "[+] $program found"
		else
			echo -e "[-] Error: $program not found"
		fi
		sleep 0.5
	done
}


case $1 in
	-i) install_f ;;
	-u) uninstall_f ;;
	-c) check_f ;;
	*) help_f ;;
esac
