#!/bin/bash
# Test based on issue # 968.  This one uses -JP6ir and fails.

ps=polcontr

gmt begin $ps ps

gmt grd2xyz -s "${src:-.}"/test.dat.nc > t.txt
gmt psxy -R"${src:-.}"/test.dat.nc -JP6ir t.txt -Sc0.05c -By30 -Bx30 -BWSnE -C"${src:-.}"/test.dat.cpt -P
gmt grdcontour "${src:-.}"/test.dat.nc -C"${src:-.}"/test.dat.cpt -A- -W+1p -By30 -Bx30 -BWSnE -Y4i

gmt end
