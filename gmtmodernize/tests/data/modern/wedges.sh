#!/bin/bash
#       $Id: wedges.sh 16367 2016-05-05 01:55:00Z pwessel $
#
# Check wedges and geowedges

ps=wedges

gmt begin $ps ps

gmt gmtset PROJ_ELLIPSOID Sphere

# Cartesian
gmt psbasemap -R0/6/0/3 -Jx1i -P -Xc -Bafg
echo 0.5 0.5 30 100  | gmt psxy -Sw2i -Gred -W2p
echo 2.5 0.5 30 100  | gmt psxy -Sw2i -Gred
echo 4.5 0.5 30 100  | gmt psxy -Sw2i -W1
echo 0.5 1.75 30 100 | gmt psxy -Sw2i+a -W2p
echo 2.5 1.75 30 100 | gmt psxy -Sw2i+r -W2p
echo 4.5 1.75 30 100 | gmt psxy -Sw2i -Gred
echo 4.5 1.75 30 100 | gmt psxy -Sw2i+a -W2p
# Geographic
gmt psbasemap -Rg -JG0/25/6i -Bafg -Y3.5i
echo 0 0 30 100  | gmt psxy -SW4000k -Gred -W2p
echo 0 0 -30 -100  | gmt psxy -SW3000n -Gblue -W2p
echo 50 -30 -50 -110  | gmt psxy -SW30d -Gcyan
echo 50 -30 -50 -110  | gmt psxy -SW30d+a -W2p
echo -50 -30 50 110  | gmt psxy -SW30d -Gorange
echo -50 -30 50 110  | gmt psxy -SW30d+r -W2p
echo -10 80 -60 240  | gmt psxy -SW20d -W2p -Gyellow
gmt psxy -T

gmt end
