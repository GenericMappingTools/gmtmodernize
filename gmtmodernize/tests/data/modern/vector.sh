#!/bin/bash
#       $Id: vector.sh 13579 2014-10-02 20:35:47Z pwessel $
#
# Check vector symbols

ps=vector

gmt begin $ps ps

gmt psbasemap -R0/6/0/3 -Jx1i -B1g1 -BWSne -Xc
gmt gmtset MAP_VECTOR_SHAPE 0.5
# Center justified vectors
gmt psxy -W1p -Gred -S << EOF
0.5	0.5	30	1i	v0.2i+jc
1.5	0.5	30	1i	v0.2i+jc+b
2.5	0.5	30	1i	v0.2i+jc+e+p-
3.5	0.5	30	1i	v0.2i+jc+b+e+p1p,blue
4.5	0.5	30	1i	v0.2i+jc+bl
5.5	0.5	30	1i	v0.2i+jc+er
EOF
# Beginning justified vectors
gmt psxy -W1p -Gyellow -S << EOF
0.1	1.2	30	1i	v0.2i+jb
1.1	1.2	30	1i	v0.2i+jb+b
2.1	1.2	30	1i	v0.2i+jb+e+gorange
3.1	1.2	30	1i	v0.2i+jb+b+e+g-
4.1	1.2	30	1i	v0.2i+jb+bl
5.1	1.2	30	1i	v0.2i+jb+er
EOF
# End justified vectors
gmt psxy -W1p -S << EOF
0.9	2.8	30	1i	v0.2i+je
1.9	2.8	30	1i	v0.2i+je+b
2.9	2.8	30	1i	v0.2i+je+e
3.9	2.8	30	1i	v0.2i+je+b+e
4.9	2.8	30	1i	v0.2i+je+bl
5.9	2.8	30	1i	v0.2i+je+er
EOF
# Then with -SV and Mercator
gmt gmtset MAP_VECTOR_SHAPE 1
gmt psbasemap -R0/6/0/3 -Jm1i -B1g1 -BWSne -Y4i
# Center justified vectors
gmt psxy -W1p -Gred -S << EOF
0.5	0.5	60	1i	V0.2i+jc
1.5	0.5	60	1i	V0.2i+jc+b
2.5	0.5	60	1i	V0.2i+jc+e+p-
3.5	0.5	60	1i	V0.2i+jc+b+e+p1p,blue
4.5	0.5	60	1i	V0.2i+jc+bl
5.5	0.5	60	1i	V0.2i+jc+er
EOF
# Beginning justified vectors
gmt psxy -W1p -Gyellow -S << EOF
0.1	1.2	60	1i	V0.2i+jb
1.1	1.2	60	1i	V0.2i+jb+b
2.1	1.2	60	1i	V0.2i+jb+e+gorange
3.1	1.2	60	1i	V0.2i+jb+b+e+g-
4.1	1.2	60	1i	V0.2i+jb+bl
5.1	1.2	60	1i	V0.2i+jb+er
EOF
# End justified vectors
gmt psxy -W1p -S << EOF
0.9	2.8	60	1i	V0.2i+je
1.9	2.8	60	1i	V0.2i+je+b
2.9	2.8	60	1i	V0.2i+je+e
3.9	2.8	60	1i	V0.2i+je+b+e
4.9	2.8	60	1i	V0.2i+je+bl
5.9	2.8	60	1i	V0.2i+je+er
EOF

gmt end
