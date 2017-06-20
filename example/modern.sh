#!/bin/bash
# Modern mode: GMT commands avoids -R -J (when it can) and -O -K
# Redirection to a PS file is done in the background.
# Commands can guess -R from the input data or previous commands.

ps=map

gmt begin $ps ps

gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
gmt makecpt -Cgeo -T-8000/2000 > t.cpt
gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P
gmt pscoast -Rdata.nc -Dh -Baf -W0.75p
echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite
gmt psxy -W2p lines.txt
gmt psscale -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km"
rm -f intens.nc t.cpt

gmt end
