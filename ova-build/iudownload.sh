#1 /bin/bash
mkdir -p /var/autotest/ius
cd /var/autotest/ius
while read line
do
echo $line
wget $line

done < IULinks.txt
