#!/bin/bash
# Dumb script to accomplish the following:
# 1. Strip off all occurrences of -O and -K
# 2. Strip off any -R -J with no arguments
# 3. For all PostScript-producing modules, remove output redirection

cat << EOF > PStools.txt
gmtlogo
grdcontour
grdimage
grdvector
grdview
psbasemap
psclip
pscoast
pscontour
pshistogram
psimage
pslegend
psmask
psrose
psscale
pssolar
pstext
pswiggle
psxyz
psxy
pscoupe
psmeca
pspolar
pssac
psvelo
mgd77track
pssegyz
pssegy
EOF
cat << EOF > sed.job
s/ \-O//g
s/ \-K//g
s/\-R //g
s/\-J //g
EOF
while read line; do
	ps=`echo $line | grep -f PStools.txt -c`
	if [ $ps -gt 0 ]; then
		echo $line | sed -f sed.job | awk -F'>' '{printf "%s\n", $1}'
	else
		echo $line | sed -f sed.job
	fi
done < $1
