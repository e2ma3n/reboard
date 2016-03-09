#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# reboard v1.0 [ easy reboot or shutdown routerboard ]
# ----------------------------------------------------- #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1


# check config file
[ ! -f /opt/reboard_v1/reboard.database.en ] && echo -e "\e[91m[-]\e[0m Error: can not find config file" && exit 1


# data base location , Don not change this form
database_en="/opt/reboard_v1/reboard.database.en"


# print header on terminal
reset
echo '[+] ------------------------------------------------------------------- [+]'
echo -e "[+] Programming and idea by : \e[1mE2MA3N [Iman Homayouni]\e[0m"
echo '[+] License : GPL v3.0'
echo -e '[+] reboard v1.0 \n'


# decrypt database
echo -en "[+] Enter password: " ; read -s pass
database_de=`openssl aes-256-cbc -pass pass:$pass -d -a -in $database_en 2> /dev/null`
if [ "$?" != "0" ] ; then
	echo -e "\n[-] Error: Database can not decrypted."
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 1
else
	echo
fi


# print servers informations on terminal
echo -e "\n 0) Edite Database"
var0=`echo "$database_de" | wc -l`
var0=`expr $var0 - 12`
for (( i=1 ; i <= $var0 ; i++ )) ; do
	echo -ne " $i) " ; echo "$database_de" | tail -n $i | head -n 1 | cut -d " " -f 1,2 | tr " " @
done


# edite database
function edit_db {
	echo "$database_de" > /opt/reboard_v1/reboard.database.de
	nano /opt/reboard_v1/reboard.database.de
	echo -en "[+] encrypt new database, Please type your password: " ; read -s pass
	openssl aes-256-cbc -pass pass:$pass -a -salt -in /opt/reboard_v1/reboard.database.de -out $database_en
	rm -f /opt/reboard_v1/reboard.database.de &> /dev/null
	echo -e "\n[+] Done, New database saved and encrypted"
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 0
}


# select server for continue
while :; do
	echo -en '\e[0m\n[+] Select your server/option or type exit for quit: ' ; read q1

	if [ "$q1" = "0" ] ; then
		edit_db
	fi

	if [ "$q1" -le "$var0" ] 2> /dev/null ; then
		break
	elif [ "$q1" = "exit" ] ; then
		echo "[+] Done"
		echo '[+] ------------------------------------------------------------------- [+]'
		exit 1
	else
		echo "[-] Error: bad input"
		echo '[+] ------------------------------------------------------------------- [+]'
		exit 1
	fi
done


password=`echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 4`
username=`echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 1`
ip_address=`echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 2`
ssh_port=`echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 3`


function reboot_f {
	sshpass -p "$password" ssh -o StrictHostKeyChecking=no -l $username $ip_address -p $ssh_port 'system reboot' &> /dev/null
	if [ "$?" = "0" ] ; then
		echo "[+] Done"
	else
		echo "[-] Error: command not executed"
	fi
	echo '[+] ------------------------------------------------------------------- [+]'
	exit
}


function shutdown_f {
	sshpass -p "$password" ssh -o StrictHostKeyChecking=no -l $username $ip_address -p $ssh_port 'system shutdown' &> /dev/null
	if [ "$?" = "0" ] ; then
		echo "[+] Done"
	else
		echo "[-] Error: command not executed"
	fi
	echo '[+] ------------------------------------------------------------------- [+]'
	exit
}


# status, checking up or down 
ping -c 1 `echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 2` &> /dev/null
if [ "$?" = "0" ] ; then
	echo -ne "\n You selected: \e[92m" ; echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 2 
else
	echo -ne "\n You selected: \e[91m" ; echo "$database_de" | tail -n $q1 | head -n 1 | cut -d " " -f 2
fi


echo -e "\e[0m 1) Shutdown"
echo -e "\e[0m 2) Reboot"
echo -e "\e[0m 3) Exit"
echo -en "\n[+] Select your option: " ; read q2


case $q2 in
	1) shutdown_f ;;

	2) reboot_f ;;

	3) echo "[+] Done"
		echo '[+] ------------------------------------------------------------------- [+]'
		exit 0 ;;
	
	*) echo "[-] Error: Bad input"
		echo '[+] ------------------------------------------------------------------- [+]'
		exit 1 ;;
esac
