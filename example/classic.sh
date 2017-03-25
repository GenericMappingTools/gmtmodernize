#!/bin/bash
# Classic mode: GMT commands using -R -J -O -K and redirection to PS file
gmt set GMT_RUNMODE classic
gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
gmt makecpt -Cgeo -T-8000/2000 > t.cpt
gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P -K > my_map.ps
gmt pscoast -Rdata.nc -J -O -Dh -Baf -W0.75p -K >> my_map.ps
echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite -R -J -O -K >> my_map.ps
gmt psxy -W2p lines.txt -R -J -O -K >> my_map.ps
gmt psscale -R -J -O -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km" >> my_map.ps
gmt psconvert -Tf -P -A -Z my_map.ps
open my_map.pdf
rm -f intens.nc t.cpt gmt.conf gmt.history
