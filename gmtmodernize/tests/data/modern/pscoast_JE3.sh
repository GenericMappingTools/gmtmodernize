#!/bin/bash
#
#	$Id: pscoast_JE3.sh 13203 2014-05-27 02:55:31Z pwessel $
# Test a non-global -JE plot

ps=pscoast_JE3

gmt begin $ps ps

gmt pscoast -B10g10 -Je-70/-90/1:15000000 -R-95/-60/-75/-55 -Di -Ggreen -Sblue -P

gmt end
