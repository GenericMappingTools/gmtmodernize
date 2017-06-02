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

The package provides a command-line interface through the ``gmtmodernize`` command::

    gmtmodernize OLD_SCRIPTS_FOLDER MODERN_SCRIPTS_FOLDER

The program will crawl through the ``OLD_SCRIPTS_FOLDER`` and convert any ``.sh`` files
it finds. The directory structure will be mirrored in ``MODER_SCRIPTS_FOLDER``.
All other files will be copied to ``MODER_SCRIPTS_FOLDER``.
