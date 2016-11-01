#!/bin/bash
logger "starting dumponator"
# DumpOnator Variables

FileSize=$1                # File Size in MB recieved from command line arg 1
NumberofFiles=$2           # Number of files to create.
NumberOfCommandlineArg=$#  # convert the command line arg count into a variable
AveragePacketSize=1        # Size of average packets on the network in bytes
CaptureInterface=eth0      # Interface that will be the source of the capture
CommandLineArgErrMsg=""    # Empty String until command line error detected
ErrorCount=0
OutputPath="/tmp"

USAGE ()
{
echo -e "########################################################################"
echo -e "##****************************DumpOnator******************************##"
echo -e "##*******************************USAGE********************************##"
echo -e "##***********   ./DumpOnator <FileSize> <NumberofFiles>  *************##"
echo -e "##********************************************************************##"
echo -e "##First argument is the file size. That is input in MB................##"
echo -e "##Second argument is the amount of files that you want ...............##"
echo -e "##To change the capture interface you have to adjust it in the .SH....##"
echo -e "##To change the average packet size in bytes it is adjusted in the .SH##" 
 echo -e "##.....................Thank you have a great day.....................##"
echo -e "##************B-Martin is the Man with the Master Plan****************##"
echo -e "##>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>##"
echo -e "##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##"
echo -e "##********************************************************************##"
echo -e "########################################################################"
}
#Checks 

echo "Attempting TCP Dump with $NumberOfCommandLineArg" 

if [[ "$NumberOfCommandlineArg" -ne 2 ]]; then 
  CommandLineArgErrMsg+="\n  ERROR: Expected 2 Command Line Arguments\n"
  ErrorCount=1
fi

if [[ "$FileSize" -le 0 ]]; then 
  CommandLineArgErrMsg+="\n  ERROR: ARG1 - File Size must be >0\n"
fi

if [[ "$NumberofFiles" -le 1 ]]; then 
  CommandLineArgErrMsg+="\n  ERROR: ARG2 - Expected Number of Files must be > 1\n"
fi


if [[ "$CommandLineArgErrMsg" !=  "" ]]; then 
  USAGE
  echo -e  "$CommandLineArgErrMsg"
  exit 
fi

#Total Packet Count calculation

TotalPacketCount="$(($FileSize * $NumberofFiles * 1024 / $AveragePacketSize))" 

#Start TCPDump

cmd="/usr/sbin/tcpdump -n -C $FileSize -W $NumberofFiles -c $TotalPacketCount -i $CaptureInterface -w $OutputPath/packetcapture -s 65535"
echo "$0 running Command: $cmd"
logger "$0 running Command: $cmd"
$cmd
