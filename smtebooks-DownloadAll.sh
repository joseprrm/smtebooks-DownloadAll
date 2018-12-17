#/bin/bash
# This script doesn't work properly and its full of bugs, do not use it
# It may be useful to take ideas to create a script that takes the links and downloads them.


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

function findErrorsCleanAndLog {
    number="${1}"
    filename="${2}"

    findOutput=$(find "${filename}" -type f -size -1c)

    if [ "$findOutput" == "" ]; then 
        rm $number
        echo "Probably book number $number is not present and can't be downloaded">>../log.log
    else
        rm $number
	echo $filename >> ../log.log
        echo "Probably book number $number ($filename) has been downloaded">>../log.log
    fi
}

# donwloads a book stored in google drive
function downloadABookDrive {
	number=$1
	echo $number >> ../log.log
	baseURLsmte=https://smtebooks.eu/getfile/
	URLsmte=${baseURLsmte}${number}
	eval $wget_command $URLsmte

	driveURL=$(grep 'drive.google.com' $number )
	driveURL=$(<<< $driveURL  cut -d '"' -f 8)

	filename=$(grep "<title>" $number)
	filename=$(<<< $filename cut -d ' ' -f 2- | cut -d "<" -f 1| rev |cut -d ' ' -f 3- | rev)
	filename=$(<<< $filename  sed 's/ /-/g')
	filename=${filename}.pdf


	driveURLFixed=$(<<< $driveURL cut -d '&' -f 2 )
	driveURLFixed=https://drive.google.com/uc?${driveURLFixed}
        # we do not need to use the wget_command because we are downloading from google drive 
	# wget -O $filename $driveURLFixed 

        #google drive has a limit in amount of data a signe IP address can download. When the limit is reached, we need to stop running
        gdownOutput=$(gdown "$driveURL" 2>&1 |grep 'Permission denied')

        if [ "$gdownOutput" != "" ]; then
            limitReachedMessage='The the limit of amount of data downloaded from google drive has been reached\n Wait until you can donwload from google drive again (up to 24 hours according to google)\n' 
            echo -ne "$limitReachedMessage" >> ../log.log
            exit
        fi

        findErrorsCleanAndLog "${number}" "${filename}"
}

# donwloads a book stored in smtebooks.eu
function downloadABookSmte {
	number=$1
	echo $number >> ../log.log
	baseURLsmte=https://smtebooks.eu/getfile/
	URLsmte=${baseURLsmte}${number}
	eval $wget_command $URLsmte

        downloadURL=$(grep /book/getfile1  $number)
        downloadURL=$(<<< $downloadURL  cut -d '"' -f 8)
        echo $downloadURL

	filename=$(grep "<title>" $number)
	filename=$(<<< $filename cut -d ' ' -f 2- | cut -d "<" -f 1|rev |cut -d ' ' -f 3-|rev)
	filename=$(<<< $filename  sed 's/ /-/g')
	filename=${filename}.pdf

        rm $number

        eval $wget_command -O "$filename"  https://www.smtebooks.eu${downloadURL}
        errorCode=$?

        if [ $errorCode == 127 ]; then
            echo "Probably book number $number is not present and can't be downloaded">>../log.log
        elif [ $errorCode == 8  ]; then
            echo "Session lost, getting it again">>../log.log
            construct_wget_command
            downloadABookSmte $number
        else 
            echo "Probably book number $number ($filename) has been downloaded">>../log.log
        fi

        #findErrorsCleanAndLog "${number}" "${filename}"
}

# Declare the global variable wget_command, constructed using the cookies obta cfscrape
declare wget_command
echo "Getting the cookies to be able to pass the Cloudflare DDoS Protection"
echo "This will take 5 seconds or more"
construct_wget_command

## Until the book 14872, the books are stored in google drive.
#for i in $(seq 0 100 14700 ); do
##for i in $(seq 11900 100 12000 ); do
#	j=$(($i + 99))
#	dir="${i}-${j}"
#	mkdir $dir
#	cd $dir
#	for k in $(seq $i $j); do
#		downloadABookDrive $k
#	done
#	cd ..
#done
#
## corner case 
#i=14800
#j=$(($i + 72))
#dir="${i}-${j}"
#mkdir $dir
#cd $dir
#for k in $(seq $i $j); do
#        downloadABookDrive $k
#done
#cd ..

# corner case
# from 14873 until the last book, they are stored in smtebooks.eu
i=14873
#j=$(($i - 73 + 99))
#dir="${i}-${j}"
#mkdir $dir
#cd $dir
#for k in $(seq $i $j); do
#        downloadABookSmte $k
#done
#cd ..

# the last one was TODO when the last commit was pushed
for i in $(seq 14900 100 16200 ); do
	j=$(($i + 99))
	dir="${i}-${j}"
	mkdir $dir
	cd $dir
	for k in $(seq $i $j); do
		downloadABookSmte $k
	done
	cd ..
done
