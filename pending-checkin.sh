#!/usr/bin/sh

#Script to find the pending smgrintegration checkin and send email
#To be run on crontab

## Clean temp files
rm -f ~dharmendra1/scm/cfg/.pending-checkin
rm -f ~dharmendra1/scm/cfg/.pending
jenkinsworkhome="/var/lib/jenkins/workspace"

## Find the list of workspace
egrep -v "libs|installedIzPack|smgrintegration|SMGRPatchInstaller" ~dharmendra1/scm/cfg/workspace.cfg > ~dharmendra1/scm/cfg/.pending-workspace

## Loop workspace to find pending checkin
for work in `cat ~dharmendra1/scm/cfg/.pending-workspace`
do
	workspace="${jenkinsworkhome}/${work}"
	if [ -d "${workspace}" ]
	then
		svn status $workspace | egrep -v "(release|build.properties)$" >> ~dharmendra1/scm/cfg/.pending
		if [ -s "~dharmendra1/scm/cfg/.pending" ]
		then
			echo "No pending checkin for workspace"
		else
			echo "Email to be sent"
		fi
	fi
done
if [ -s ~dharmendra1/scm/cfg/.pending ]
then
	cat ~dharmendra1/scm/cfg/.pending | mailx -v -s  "Pending Checkin For `date`" dharmendra1@avaya.com
fi
