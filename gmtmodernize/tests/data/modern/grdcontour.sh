#!/bin/bash
#
#	$Id: grdcontour.sh 12114 2013-09-03 19:19:00Z fwobbe $
gmt set GMT_RUNMODE modern

ps=grdcontour

contour="gmt grdcontour -A200 -C100 -Gd4 xz-temp.nc -Jx0.4c/0.4c -Ba5f1 -BWNse -Wathin,grey -Wcdefault,grey"
$contour -R-100/-60/3/21.02 -P -Y1.5c
$contour -R-100/-60/3/20 -Y9c
echo 100 C >  cont.dat
echo 200 A >> cont.dat
echo 300 C >> cont.dat
echo 400 A >> cont.dat
echo 500 C >> cont.dat
echo 600 A >> cont.dat
echo 700 C >> cont.dat
echo 800 A >> cont.dat
echo 900 C >> cont.dat
gmt grdcontour -Ccont.dat xz-temp.nc -Jx -R-100/-60/3/20 -Ba5f1 -BWNse -Gd4 -Wathin,grey -Wcdefault,grey -Y9c

gmt psconvert -Tp -F$ps
