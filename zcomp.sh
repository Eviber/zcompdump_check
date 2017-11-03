#!/bin/bash

DUMPLIST=`ls -1a ~/.zcompdump-e* | cut -c 26- | cut -c -7 | tr -d '-'`

# $1 = E, $2 = R
getrowsize()
{
	if [ $E -ne 1 ]
	then
		case $R in
			1 | 13) ROWSIZE=14;;
			5 ) ROWSIZE=22;;
			3 | 8 ) ROWSIZE=21;;
			6 | 9 ) ROWSIZE=20;;
			  *) ROWSIZE=23;;
		  esac
	else
		case $R in
			1 | 13) ROWSIZE=14;;
			7 ) ROWSIZE=22;;
			3 | 6 | 8 ) ROWSIZE=21;;
			9 ) ROWSIZE=20;;
			*) ROWSIZE=23;;
		esac
	fi
}

printspace()
{
	if [ \( $R -eq 1 -o $R -eq 13 \) -a $P -eq 7 ] ; then
		printf "                                 "
	elif [ $R -eq 3 ] ; then
		if [ $P -eq 7 -o $P -eq 14 ] ; then
			printf "      "
		fi
	elif [ $R -eq 5 -a $E -ne 1 -a $P -eq 16 ] ; then
		printf "      "
	elif [ $R -eq 6 ] ; then
		if [ $P -eq 7 ] ; then
			printf "      "
		elif [ $P -eq 14 ] ; then
			printf "      "
			if [ $E -ne 1 ] ; then
				printf "   "
			fi
		fi
	elif [ $R -eq 7 -a $E -eq 1 ] ; then
		case $P in
			6 ) printf "      ";;
			15 ) printf "   ";;
		esac
	elif [ $R -eq 8 ] ; then
		if [ $P -eq 6 ] ; then
			printf "         "
		elif [ $P -eq 14 ] ; then
			printf "   "
		fi
	elif [ $R -eq 9 ] ; then
		if [ $P -eq 6 ] ; then
			printf "         "
		elif [ $P -eq 13 ] ; then
			printf "      "
		fi
	elif [ $P -eq 7 -o $P -eq 16 ] ; then
		printf "   "
	fi
}

E=$1
if [ -n $E -a $E -gt 0 -a $E -lt 4 ]
then
	for R in $(seq 13 1);
	do
		printf "\033[0m%-3s" $R
		getrowsize
		for P in $(seq 1 $ROWSIZE);
		do
			DUMPCUR="e${E}r${R}p${P}"
			if [ $(echo $DUMPLIST | egrep -c $DUMPCUR) == 1 ] ; then
				printf "\033[32m%.2d " $P
			else
				printf "\033[31m%.2d " $P
			fi
			printspace
		done
		printf "\n"
	done
	if [ $R -lt 13 ] ; then
		printf "\n"
	fi
else
	echo "usage: sh $0 [1 | 2 | 3]"
fi
