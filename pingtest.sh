#src=$1
#dst=$2
#iface=en5


#######
#edit these variables before running the script

iface=eth0
ip1=8.8.8.8
ip2=8.8.4.4
name=Task4
size1=60
size2=60
#######


folder="./"



echo "make sure you edit the parameters in the pingtest.sh script! They are currently:
- interface = $iface
- IP address 1 = $ip1
- IP address 2 = $ip2
- packet size for IP address 1 = $size1
- packet size for IP address 2 = $size2
- file name string = $name"


if [ $iface = "edit_me" ] || [ ip1 = "edit_me" ] || [ ip2 = "edit_me" ] || [ name = "edit_me" ] || [ size1 = "edit_me" ] || [ size2 = "edit_me" ]
then
	echo "edit default values before running the script!!"
	exit
fi

if [ $USER != "root" ]
then
	echo "This script must be run as root"
	exit
fi


killall -9 tcpdump
killall -9 ping

killall -9 ping
killall -9 tcpdump
#echo "$folder/$src-$dst.$(($size1+8)).`date +%y-%m-%d`.txt"
#exit


# any previous files are moved into a subfolder called "archive"

mkdir $folder/archive
mv *.ping.txt $folder/archive
mv *.ping.pcap $folder/archive


ping -s $size1 $ip1 > $folder/$name.$(($size1+8)).$ip1.`date +%y-%m-%d-%s`.ping.txt &
tcpdump -i $iface -w  $folder/$name.$(($size1+8)).$ip1.`date +%y-%m-%d-%s`.ping.pcap icmp and host $ip1 &
ping -s $size2 $ip2 > $folder/$name.$(($size2+8)).$ip2.`date +%y-%m-%d-%s`.ping.txt &
tcpdump -i $iface -w  $folder/$name.$(($size2+8)).$ip2.`date +%y-%m-%d-%s`.ping.pcap icmp and host $ip2 &

