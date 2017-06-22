#!/bin/bash
#	$Id: logos.sh 16562 2016-06-18 04:04:08Z pwessel $
# Testing gmt logo options

ps=logos

gmt begin $ps ps

gmt psxy -R0/8.5/0/11 -Jx1i -X0 -Y0 -P -W4p << EOF
> vertical line
4.25	0.2
4.25	10.8
> top horizontal line
0.2	8.25
8.3	8.25
> middle horizontal line
0.2	5.5
8.3	5.5
> bottom horizontal line
0.2	2.75
8.3	2.75
EOF
# Logo on yellow background with outline and with gray shadow
gmt logo -Dx0/0+w3.5i -F+p+glightyellow+s -Y0.5i -X0.375i
# Logo on yellow background with outline and with darkred shadow
gmt logo -Dx0/0+w3.5i -F+p+glightyellow+sdarkred -X4.25i
# Logo on yellow background with outline and larger south clearance
gmt logo -Dx0/0+w3.5i -F+p+glightyellow+c4p/4p/20p/4p -Y2.75i -X-4.25i
# Logo on no background with double outline and unequal clearances
gmt logo -Dx0/0+w3.5i -F+p+c12p/6p/20p/4p+i -X4.25i
# Logo on yellow background with outline
gmt logo -Dx0/0+w3.5i -F+p+glightyellow -Y2.75i -X-4.25i
# Logo on yellow background without outline
gmt logo -Dx0/0+w3.5i -F+glightyellow -X4.25i
# Logo by itself
gmt logo -Dx0/0+w3.5i -Y2.75i -X-4.25i
# Logo with outline
gmt logo -Dx0/0+w3.5i -F -X4.25i

gmt end
