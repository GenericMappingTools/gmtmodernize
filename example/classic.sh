#!/bin/bash
# Classic mode: GMT commands using -R -J -O -K and redirection to PS file
ps=map.ps
gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
gmt makecpt -Cgeo -T-8000/2000 > t.cpt
gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P -K > $ps
gmt pscoast -Rdata.nc -J -O -Dh -Baf -W0.75p -K >> $ps
echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite -R -J -O -K >> $ps
gmt psxy -W2p lines.txt -R -J -O -K >> $ps
gmt psscale -R -J -O -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km" >> $ps
rm -f intens.nc t.cpt
