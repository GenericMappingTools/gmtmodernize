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
.. image:: https://img.shields.io/pypi/pyversions/gmtmodernize.svg?style=flat-square
    :alt: Compatible Python versions.
    :target: https://pypi.python.org/pypi/gmtmodernize


Disclaimer
----------

This is **work in progress**. So far, it can convert some of the test and
example scripts from the GMT repository.


About modern mode
-----------------

GMT is introducing a "modern" execution mode that reduces the amount of
arguments needed for many programs and handles the PostScript layer-caking
in the background.

For example, the following classic mode script::

    ps=map.ps
    gmt grdgradient -Nt0.2 -A45 data.nc -Gintens.nc
    gmt makecpt -Cgeo -T-8000/2000 > t.cpt
    gmt grdimage -Ct.cpt -Iintens.nc data.nc -JM6i -P -K > $ps
    gmt pscoast -Rdata.nc -J -O -Dh -Baf -W0.75p -K >> $ps
    echo "Japan Trench" | gmt pstext -F+f32p+cTC -Dj0/0.2i -Gwhite -R -J -O -K >> $ps
    gmt psxy -W2p lines.txt -R -J -O -K >> $ps
    gmt psscale -R -J -O -DjBL+w3i/0.1i+h+o0.3i/0.4i -Ct.cpt -W0.001 -F+gwhite+p0.5p -Bxaf -By+l"km" >> $ps

is equivalent to the following in modern mode::

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

See the scripts and data in the ``example`` folder.

Read more about modern mode at the
`Modernization wiki page <http://gmt.soest.hawaii.edu/projects/gmt/wiki/Modernization>`__.


Installing
----------

Install the latest release using the ``pip`` package manager::

    pip install gmtmodernize

To install the development version from the Github *master* branch::

    git clone https://github.com/GenericMappingTools/gmtmodernize.git
    cd gmtmodernize
    pip install .


Using
-----

Command line
++++++++++++

The package provides a command-line interface through the ``gmtmodernize``
program::

    $ gmtmodernize --help
    Convert GMT shell scripts from classic to modern mode.

    Prints the converted modern mode script to standard output (stdout).

    Usage:
        gmtmodernize SCRIPT
        gmtmodernize --recursive FOLDER_CLASSIC FOLDER_MODERN
        gmtmodernize --help
        gmtmodernize --version

    Arguments:
        SCRIPT          Classic mode script to convert.
        FOLDER_CLASSIC  Folder with classic mode scripts (can have multiple
                        sub-folders).
        FOLDER_MODERN   Name of output folder with converted modern mode scripts.
                        Mirrors the folder structure of FOLDER_CLASSIC and copies
                        all non-script files.

    Options:
        -r --recursive  Recursively transverse a folder structure with GMT scripts
                        and other files instead of converting a single file.
                        Creates a new folder with the same structure and non-script
                        files copied over, plus the converted GMT scripts.
        -h --help       Show this help message and exit.
        --version       Show the version and exit.

    Examples:

        Convert a single GMT script to modern mode:

            $ gmtmodernize classic_script.sh > modern_script.sh

        Convert a folder with GMT scripts, data files, etc, (optionally inside
        multiple sub-folders):

            $ gmtmodernize -r gmt_classic_scripts/ gmt_modern_scripts/

        This will create a folder 'gmt_modern_scripts' with the same sub-folders
        and non-script files in 'gmt_classic_scripts' but with the scripts
        converted to modern mode.

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


License
-------

gmtmodernize is free software: you can redistribute it and/or modify it
under the terms of the **BSD 3-clause License**. A copy of this license is
provided in ``LICENSE.txt``.
