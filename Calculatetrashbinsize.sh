#!/bin/sh
# File Name:Calculatetrashbinsize.sh
# Check and report via EA size of user's trash bin
# github.com/jkwhar
#
#Modified by johnnykim
#find logged in user
loggedinuser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#find how large trash bin is
trash=`du -hd 1 /Users/$loggedinuser/.trash | awk 'END{print $1}'`
#echo it for EA
echo "<result>$trash</result>"
