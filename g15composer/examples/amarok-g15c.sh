#!/bin/sh
#
# g15_amarok
#
# Logitech G15 Amarok Script
# Outputs the current track from amarok to the LCD
# Basic Format:
# Artist
# Title
# Time
#
# Check out http://waug.at/g15lcd/ for more information.
# (also http://phyreskull.ithium.net/g15wiki/wiki/Main_Page)
#
# Script by akshoslaa@gmail.com
# Modified by Mike Lampard for the gfx simple graphics language
# Modified from that by Anthony J. Mirabella to use g15composer
#
# Draws a nice duo-tone rectangle with round corners, uses the 8x8 font
# for the artist name. Has a percent-complete bar in the center of the
# screen, and the song name above.  Not usable as an inbuilt amarok script
# any more, I think.  Runs from the cmd line fine though.

PIPE="/var/run/lcdpipe"

#load the truetype font we want to use..
#echo 'FL 0 10 "'$PWD'/mc__.ttf"' > ${PIPE} 
#echo 'FL 1 10 "'$PWD'/lotusf__.ttf"' > ${PIPE} 
echo 'FL 0 10 "/usr/share/fonts/ttf-bitstream-vera/Vera.ttf"' > ${PIPE}
echo 'FL 1 10 "/usr/share/fonts/ttf-bitstream-vera/Vera.ttf"' > ${PIPE}

while [ 1 ]
do
ARTIST="`dcop amarok player artist 2>/dev/null`"
TITLE="`dcop amarok player title 2>/dev/null`"
CURTIME="`dcop amarok player trackCurrentTime 2>/dev/null`"
MAXTIME="`dcop amarok player trackTotalTime 2>/dev/null`"
FCURTIME="`dcop amarok player currentTime 2>/dev/null`"
FMAXTIME="`dcop amarok player totalTime 2>/dev/null`"
STATUS="`dcop amarok player status 2>/dev/null`"

if [ "$STATUS" == "2" ]; then
{
	cat <<EOT > ${PIPE}
	MC 1
	PC 0
	DR 0 0 159 43 1 1
	DR 3 22 157 40 1 0
	PB 3 22 157 24 0
	FP 0 14 0 0 0 1 "$ARTIST"
	FP 0 9 0 15 0 1 "$TITLE"
	DB 3 27 157 35 2 $CURTIME $MAXTIME 3
	TO 0 35 0 1 "$FCURTIME / $FMAXTIME"
	MC 0

EOT
}
else
echo TO 0 15 2 1 \"`date +"%H:%M"`\" > ${PIPE}

fi
sleep 1
done

