gmtmodernize: Convert GMT5 scripts to the "modern" mode
=======================================================

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
on the background.

Read more about it:

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
