#/bin/bash
function donwloadABook {
	number=$1
	baseURLsmte=https://smtebooks.us/getfile/
	URLsmte=$baseURLsmte$number
	echo $URLsmte
	wget $URLsmte

	driveURL=$(cat $number |grep drive.google.com)
	echo $driveURL
	driveURL=$(echo $driveURL | cut -d '"' -f 4)
	echo $driveURL


	filename=$(cat $number |grep "<title>")
	echo $filename
	filename=$(echo $filename | cut -d ' ' -f 2- | cut -d "<" -f 1)
	echo $filename
	filename=$(echo $filename | sed -r  's/ /-/g')
	filename=$(echo $filename".pdf" )
	echo $filename


	driveURLFixed=$(echo $driveURL | cut -d '&' -f 2 )
	driveURLFixed=$(echo "https://drive.google.com/uc?"$driveURLFixed)
	echo $driveURLFixed
	wget -O $filename $driveURLFixed 


	findOutput=$(find "$filename" -type f -size -5000c)
	if [ "$findOutput" = "" ]; then 
		rm $number
		echo "xicotet"
	fi

	findOutput=$(find "$filename" -type f -size -1c)
	if [ "$findOutput" != "" ]; then 
		rm $number
		rm $filename
		echo "fraus"
	fi


	echo $number - $filename >> ../log.log
}

for i in $(seq 0 100 12000 ); do
	j=$(($i + 99))
	dir=$i"-"$j
	mkdir $dir
	cd $dir
	for k in $(seq $i $j); do
		donwloadABook $k
	done
	cd ..
done
