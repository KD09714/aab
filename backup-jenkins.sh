#!/usr/bin/sh
#Script to backup jenkins workspace
#To be run on crontab

##Default variables
jenkinsworkhome="/var/lib/jenkins/workspace"
tempbackuphome="/home/jenkins/.backup"
backuphome="/var/lib/jenkins/jenkins-workspace"
crondate=`date +"%Y-%m-%d"`
crontime="12-00"
#crontime="05-16"
backupdir="FULL-${crondate}_${crontime}"

##Create dir if not exists
[ -d "$backuphome/${backupdir}" ] || mkdir -p "$backuphome/${backupdir}"
[ -d "$tempbackuphome/${backupdir}/workspace" ] || mkdir -p "$tempbackuphome/${backupdir}/workspace"

##Backup jenkins workspace
cp -rf ${jenkinsworkhome}/* ${tempbackuphome}/${backupdir}/workspace

##Call cleanup script
~dharmendra1/scm/tools/clean-workspace.sh 0 $tempbackuphome/${backupdir}/workspace
cp -rf ${tempbackuphome}/${backupdir}/* "${backuphome}/${backupdir}"

##Clean tempbackuphome if copied fine
diff ${tempbackuphome}/${backupdir}/workspace ${backuphome}/${backupdir}/workspace
[ $? -eq 0 ] && rm -rf ${tempbackuphome}/${backupdir}

