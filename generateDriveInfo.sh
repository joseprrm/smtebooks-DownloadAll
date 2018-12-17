#/bin/bash

#this function generates the wget command using the cookies obtained with cfscrape
function construct_wget_command {
# read the output of the inline python script as a here-string an put it in the wget_command global variable
read wget_command <<< $(python <<EOF
import cfscrape

web='https://smtebooks.eu'

cookies, user_agent = cfscrape.get_cookie_string(web)

# we set the cookies as suggested in the wget man page
call='wget --no-cookie'
call=call+' --header "Cookie: '+cookies+'"'
call=call+' --header "User-Agent: '+user_agent+'"'

# send the variable to stdout
print(call)
EOF
)
}

function downloadABookDrive {
	number=$1
	echo $number >> driveLinks.txt
	baseURLsmte=https://smtebooks.eu/getfile/
	URLsmte=${baseURLsmte}${number}
        eval $wget_command $URLsmte
        errorCode=$?
        echo $errorCode
        if [ $errorCode == 8 ]; then
            construct_wget_command
            eval $wget_command $URLsmte
        fi

	driveURL=$(grep 'drive.google.com' $number )
	driveURL=$(<<< $driveURL  cut -d '"' -f 8)
        if [ "$driveURL" != "" ]; then 
            echo "$driveURL" >> driveLinks.txt
        fi
        rm $number
}

# Declare the global variable wget_command, constructed using the cookies obta cfscrape
declare wget_command
construct_wget_command

# Until the book 14872, the books are stored in google drive.
for i in $(seq 0 14872 ); do
    downloadABookDrive $i
done
