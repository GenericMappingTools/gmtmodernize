gmtmodernize: Convert GMT5 scripts to the "modern" execution mode
=================================================================

.. image:: http://img.shields.io/pypi/v/gmtmodernize.svg?style=flat-square
    :alt: Latest version on PyPI
    :target: https://pypi.python.org/pypi/gmtmodernize
.. image:: http://img.shields.io/travis/GenericMappingTools/gmtmodernize/master.svg?style=flat-square
    :alt: Travis CI build status
    :target: https://travis-ci.org/GenericMappingTools/gmtmodernize
.. image:: http://img.shields.io/coveralls/GenericMappingTools/gmtmodernize/master.svg?style=flat-square
    :alt: Test coverage status
    :target: https://coveralls.io/r/GenericMappingTools/gmtmodernize?branch=master


Disclaimer
----------

This is **work in progress**. So far, it can convert some of the test and
example scripts from the GMT repository.


About
-----

GMT is introducing a "modern" execution mode that reduces the amount of
arguments needed for many programs and handles the PostScript layer-caking
in the background.

For example, the following classic mode script::

    gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
    gmt makecpt -Cgeo -T-8000/2000 > t.cpt
    gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P -K > classic_map.ps
    gmt pscoast -Rdata.nc -J -O -Dh -Baf -W0.75p -K >> classic_map.ps
    echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite -R -J -O -K >> classic_map.ps
    gmt psxy -W2p lines.txt -R -J -O -K >> classic_map.ps
    gmt psscale -R -J -O -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km" >> classic_map.ps
    gmt psconvert -Tf -P -A -Z classic_map.ps

is equivalent to the following in modern mode::

    gmt begin
    gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
    gmt makecpt -Cgeo -T-8000/2000 > t.cpt
    gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P
    gmt pscoast -Dh -Baf -W0.75p
    echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite
    gmt psxy -W2p lines.txt
    gmt psscale -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km"
    gmt psconvert -Tf -P -A -Fmodern_map
    gmt end

See the scripts and data in the ``example`` folder.

Read more about modern mode at:

* `Version 2.0 of the modern mode spec <http://gmt.soest.hawaii.edu/boards/2/topics/5138>`__
* `Initial proposal <http://gmt.soest.hawaii.edu/projects/gmt/wiki/Modernization>`__


Installing
----------

``gmtmodernize`` is in **alpha** status and can be installed using ``pip``::

    pip install gmtmodernize --pre


Using
-----

Command line
++++++++++++

The package provides a command-line interface through the ``gmtmodernize``
command::

    gmtmodernize <classic_scripts> <modern_scripts>

The program will crawl through the ``classic_scripts`` folder and convert any
``.sh`` files it finds. The directory structure will be mirrored in
``modern_scripts``.  All other files will be copied to
``modern_scripts``.

Library
+++++++

Alternatively, you can run the conversion using the ``gmtmodernize`` Python
library. It exposes a ``modernize`` function that takes a classic script (as a
single string) and outputs a modern script (also as a single string).

Example::

    from gmtmodernize import modernize

    with open('classic_script.sh') as f:
        classic = f.read()
    with open('modern_script.sh', 'w') as f:
        f.write(modernize(classic))
