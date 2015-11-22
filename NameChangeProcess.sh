#!/bin/sh

#  NameChangeProcess.sh
#  
#
#  Created by jkim on 9/10/14.
#
# Script I use to do a Name change process after chaning a name on Active Directory.

#cocoa dialog location
cd=/private/var/ftboe/cocoaDialog.app/Contents/MacOS/cocoaDialog

#Current logged in user
# for production change to --> (ls -l /dev/console|cut -d' ' -f4)
loggedInUser=user2



# inputbox asking old username
res=$("$cd" inputbox --title "inputbox" --informative-text "Enter old username:" --button1 "Okay" --button2 "Cancel"\
)

[[ ! $(head -n1 <<<"$res") = "2" ]] && { res=$(tail -n1 <<<"$res"); echo "You entered: $res"; }

#delete MS user data first

rm -f -r /users/$res".old"/documents/Microsoft\ User\ Data

#copy from old to new users folder

ditto /users/$res".old"/documents/ /users/$loggedInUser/documents

#error catching
if [ "$?" -ne "0" ]; then
$cd msgbox --text "Oh No! Migration failed" --button1 Okay 

else
#name change successful msg
$cd msgbox --text "Migration successful" --button1 Okay
fi

#change shortname
ShortName=$(ls -l /dev/console|cut -d' ' -f4)
FullName=`dscl . -read /Users/$ShortName RealName | tail -1`
FullName2=`echo $FullName | awk '{print}'`
dscl . -change /Users/$ShortName RealName "$FullName2" "$ShortName"

#if name change fail...msg
if [ "$?" -ne "0" ]; then
$cd msgbox --text "Oh No! Name changed failed" --button1 Okay
else

#name change success msg
$cd msgbox --text "Name change OK!" --button1 Okay
fi

#Process completed.

$cd msgbox --text "Name Change DONE!" --button1 Okay
