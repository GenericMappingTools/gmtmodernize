#!/bin/bash
# Test based on issue # 968.  This one uses -JP6ir and fails.
gmt set GMT_RUNMODE modern
ps=polcontr
gmt grd2xyz -s "${src:-.}"/test.dat.nc > t.txt
gmt psxy -R"${src:-.}"/test.dat.nc -JP6ir t.txt -Sc0.05c -By30 -Bx30 -BWSnE -C"${src:-.}"/test.dat.cpt -P
gmt grdcontour "${src:-.}"/test.dat.nc -C"${src:-.}"/test.dat.cpt -A- -W+1p -By30 -Bx30 -BWSnE -Y4i

gmt psconvert -Tp -F$ps
