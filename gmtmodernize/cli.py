"""Convert GMT shell scripts from classic to modern mode.

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
"""
import os
import sys
import shutil
from functools import partial
from docopt import docopt

from . import __version__
from . import modernize


def echo(*args, **kwargs):
    """
    Print message to stderr.
    """
    print(file=sys.stderr, *args, **kwargs)


def main():
    """
    Entry point for the command line interface.
    """
    # Parse the command line arguments
    args = docopt(__doc__, version=__version__)

    echo = partial(print, file=sys.stderr)

    if args['SCRIPT'] is not None:
        with open(args['SCRIPT']) as inputfile:
            classic = inputfile.read()
        modern = modernize(classic)
        print(modern)
    else:
        input_dir = args['FOLDER_CLASSIC']
        output_dir = args['FOLDER_MODERN']
        for base, _, files in os.walk(input_dir):
            echo('Base dir:', base)
            base_output = base.replace(input_dir, output_dir)
            os.mkdir(base_output)

            scripts = set(f for f in files if os.path.splitext(f)[-1] == '.sh')
            not_scripts = set(files).difference(scripts)

            for file in not_scripts:
                shutil.copy(os.path.join(base, file), base_output)

            for script in scripts:
                modern_script = os.path.join(base_output, script)
                old_script = os.path.join(base, script)

                echo('  Converting:', old_script, ' --> ', modern_script)
                with open(old_script) as inputfile:
                    old_content = inputfile.read()
                modern_content = modernize(old_content)
                with open(modern_script, 'w') as outputfile:
                    outputfile.write(modern_content)
        echo("Done")
