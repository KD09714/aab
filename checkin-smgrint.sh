#Script to checkin to smgr integration svn from localpatch jenkins workspace 
#To be run manually

## Find the workspace path
noofarg=$#
if [ $noofarg -ne 1 ]
then
	echo "No of Argument NOT OK: Input $# : Required: 1"
else
	echo "No of Input Argument if OK"
fi
