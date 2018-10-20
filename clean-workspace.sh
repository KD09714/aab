# Script to cleanup the jenkins workspace of old jobs
# to be run on cronjob.
#

## Set maxdaytokeep=5 as default

if [ $# -ge 1 ]
then
	maxdaytokeep=$1
	jenkinsworkhome=$2
else
	maxdaytokeep=5
fi

nowdate=`date`
[ -z $jenkinsworkhome ] && jenkinsworkhome="/var/lib/jenkins/workspace"

rm -f /home/jenkins/scm/cfg/.mail-cleaned.txt
for path in `cat ~dharmendra1/scm/cfg/workspace.cfg`
do
	fullpath=${jenkinsworkhome}/${path}
	if [ -d "${fullpath}" ]
	then
		lastdate=`ls -lrtd ${fullpath} | awk '{ print $6,$7,$8 }'`
		d1=$(date -d "$lastdate" +%s)
		d2=$(date -d "$nowdate" +%s)
		diffdays=$(( (d2 - d1) / 86400 ))
		echo "$diffdays | ${fullpath}"

		if [ $diffdays -ge $maxdaytokeep ]
		then
			echo "$nowdate | $lastdate | ${fullpath}" >> ~dharmendra1/scm/log/clean-workspace.log
			rm -rf ${fullpath}
			echo ${fullpath} >> /home/jenkins/scm/cfg/.mail-cleaned.txt
		fi
	fi
done

if [ -s /home/jenkins/scm/cfg/.mail-cleaned.txt ]
then
        cat /home/jenkins/scm/cfg/.mail-cleaned.txt | mailx -v -s  "Workspace Cleanup Report For `date`" dharmendra1@avaya.com
fi

## check the mount point for space>85 % used
rm -f /home/jenkins/scm/cfg/.space.txt /home/jenkins/scm/cfg/.mail-alert.txt
df -h | grep -v Filesystem > /home/jenkins/scm/cfg/.space.txt
while read f1 f2 f3 f4 f5 f6; do
	echo "Processing $f1"
	space=${f5%"%"}
	
	if [ $space -ge 90 ]
	then
		echo "$f1 $f2 $f3 $f4 $f5 $f6" >> /home/jenkins/scm/cfg/.mail-alert.txt
	fi
done < /home/jenkins/scm/cfg/.space.txt

if [ -s /home/jenkins/scm/cfg/.mail-alert.txt ]
then
        cat /home/jenkins/scm/cfg/.mail-alert.txt | mailx -v -s  "Space Report For `date`" dharmendra1@avaya.com
fi

