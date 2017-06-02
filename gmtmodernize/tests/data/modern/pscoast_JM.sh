#!/bin/bash
#
#	$Id: pscoast_JM.sh 11490 2013-05-16 06:26:21Z pwessel $
# Make sure when fixed it works for all resolutions -D?
gmt set GMT_RUNMODE modern

ps=pscoast_JM

gmt pscoast -R90/290/-70/65 -JM6i -P -Ggray -Baf

gmt psconvert -Tp -F$ps
