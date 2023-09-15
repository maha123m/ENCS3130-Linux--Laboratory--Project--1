#Lama Naser 1200190, Maha Mali 1200746

#part 1 , asking the user if the dictionary file exist or not
DicFile=
Dictionary=
while [ true ]
do
	echo -n "Does the Dictionary file exist or not? (yes/no): "
	read choice
	if [ "$choice" = "yes" ]
	then
		while [ true ]
		do
			echo -n "Please enter the path of the dictionary file: "
			read path
			DicFile=$path
			#check if the file is exist
			if [ ! -e "$DicFile" -o ! -f "$DicFile" ]
			then 
				echo
				echo "file is not accepted"
				echo
				echo "-----------------------------------------------------------"
				echo
				continue
			fi
			Dictionary=$(cat $DicFile)
			#check the file is empty or not
			if [ "$Dictionary" = "" ]
			then
				echo
				echo "this ile is empty, it will be updated when you do a compresion peocess"
				echo
				echo -----------------------------------------------------------
				echo 
				break
			else 
				echo "The file has been read successfully, here is its content:"
				echo
				cat $DicFile
				echo
				echo -----------------------------------------------------------
				break
			fi
		done
		break
	elif [ $choice = "no" ]
	then 
		DicFile="/home/lama/Desktop/lama.txt"
		echo
		break
	else
		echo
		echo "invalid input, please try again"
		echo
	fi
done
echo

# Part 2 here is the main menu
while [ true ]
do
	echo "Please choose one of the options below: "
	echo
	echo "c - compress a file"
	echo "d - decompress a file"
	echo "q - exit from the program"
	echo -n "my choice is (c/d/q): "
	read choice
	
	
	# compresion
	if [ $choice = "c" -o $choice = "C" ]
	then
		buffer=
		while [ true ]
		do
			echo -n "Please input the path of the file to be compressed: "
			read path
			if [ ! -e "$path" -o ! -f "$path" ]
			then 
				echo
				echo "file is not accepted"
				echo
				continue
			else
				buffer=$(cat $path)
				if [ "$buffer" = "" ]
				then
					echo
					echo "The file is empty"
					echo
				else
					break
				fi
			fi		
		done
		echo
		echo "The file has been read successfully, here is its contents:"
		echo
		echo $buffer
		echo
		echo "compresion process..."
		echo
		#compresion process here
		codes=""
		newBuffer=$(echo "$buffer" | sed ':a;N;$!ba;s/ / space /g; s/\n/ \\n /g; s/\./ \. /g; s/,/ , /g; s/\#/ \# /g; s/\$/ \$ /g; s/?/ ? /g; s/~/ ~ /g; s/!/ ! /g; s/\^/ \^ /g; s/@/ @ /g; s/&/ & /g; s/-/ - /g; s/=/ = /g; s/_/ _ /g; s/+/ + /g; s/*/ * /g')
		for i in $newBuffer
		do
			flag=0
			while IFS= read -r j;
			do
				code=$(echo "$j" | cut -c1-6)
				wordD=$(echo "$j" | cut -c8-)
				if [ "$i" = "$wordD" ]
				then
					flag=1
					len=${#i}
					if [ "$len" -gt 7 ]
					then
						echo -n "$i	"
						echo "matches		$code"
					else
						echo -n "$i	"
						echo "	matches		$code"
					fi
					codes="$codes$code
"
				fi
	
			done <<< "$Dictionary"
			if [ "$flag" -eq 0 ]
			then
				echo -n "$i not found in the dictionary new code is: "
				lines=
				if [ "$Dictionary" = "" ]
				then
					lines=0
				else
					lines=$(echo "$Dictionary" | wc -l)
				fi
				hex=$(echo "obase=16; ibase=10; $lines" | bc)
				length=${#hex}
				newCode=
				if [ "$length" -eq 1 ]
				then
					newCode="0x000$hex"
				elif [ "$length" -eq 2 ]
				then
					newCode="0x00$hex"
				elif [ "$length" -eq 3 ]
				then
					newCode="0x0$hex"
				else
					newCode="0x$hex"
				fi
				codes="$codes$newCode
"
				data="$newCode $i"
				echo "$data" >> $DicFile
				Dictionary=$(cat $DicFile)
				echo "$newCode"
			fi
		done
		echo
		temp="compressed.txt"
		echo "$codes" > $temp
		echo "The compressed data has been saved to 'compressed' file"
		echo
		uncompSize=$(echo "$buffer" | wc -c)
		uncompSize=$(( ($uncompSize + 1) * 2))
		echo "The uncompresed data size is: $uncompSize"
		compSize=$(echo -n "$codes" | wc -l)
		compSize=$(($compSize * 2))
		echo "The compresed data size is: $compSize"
		ratio=$(echo "scale=4; $uncompSize / $compSize" | bc)
		echo "compresion ratio is: $ratio"
		echo
		echo -----------------------------------------------------------
	
	
	# Decompresion
	elif [ $choice = "d" -o $choice = "D" ]
	then
		buffer=
		while [ true ]
		do
			echo -n "Please input the path of the file to be deompressed: "
			read path
			if [ ! -e "$path" -o ! -f "$path" ]
			then 
				echo
				echo "file is not accepted"
				echo
				continue
			else
				buffer=$(cat $path)
				if [ "$buffer" = "" ]
				then
					echo
					echo "The file is empty"
					echo
				else
					break
				fi
			fi		
		done
		echo
		echo "decompresion process...."
		echo
		
		#decompress process here
		flag1=0
		uncompressedBuffer=""
		for i in $buffer
		do
			flag=0
			while IFS= read -r j; 
			do
				code=$(echo $j | cut -d' ' -f1)
				if [ "$i" = "$code" ]
				then
					flag=1
					word=$(echo $j | cut -c8-)
					if [ "$word" = "space" ]
					then
						uncompressedBuffer="$uncompressedBuffer "
					elif [ "$word" = "\n" ]
					then
						uncompressedBuffer="$uncompressedBuffer
"
					else
						uncompressedBuffer="$uncompressedBuffer$word"
					fi
					echo "$i matches $word"
				fi
			done <<< "$Dictionary"
			if [ $flag -eq 0 ]
			then
				echo "decoompresion process faild"
				echo "the code $i does not exist in thr dictionary file"
				flag1=1
				break
			fi
		done
		if [ $flag1 -eq 0 ]
		then
			echo
			echo "the uncompressed data is:"
			echo "$uncompressedBuffer"
			uncompressed="uncompresed.txt"
			echo "$uncompressedBuffer" > $uncompressed
		echo
		echo "The uncompressed data has been saved to 'uncompressed' file"
		fi
		echo
		echo -----------------------------------------------------------
	elif [ $choice = "q" -o $choice = "Q" ]
	then
		echo
		echo "thank you!!"
		echo
		echo -----------------------------------------------------------
		exit 1
	else
		echo
		echo "invalid input, please try again"
		echo
		echo -----------------------------------------------------------
	fi
		
done


