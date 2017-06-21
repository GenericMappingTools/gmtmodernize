"""Convert GMT shell scripts from classic to modern mode.

Prints the converted modern mode script to standard output (STDOUT) when
converting a single script.

Usage:
    gmtmodernize SCRIPT
    gmtmodernize --recursive [--quiet] FOLDER_CLASSIC FOLDER_MODERN
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
    --quiet         Don't print any text to STDERR while processing.
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


def is_gmt_script(fname):
    """
    Check if a given file is a GMT script.
    """
    return os.path.splitext(fname)[-1] == '.sh'


def find_gmt_scripts(directory):
    """
    Find all GMT scripts in the given directory (including subdirectories).
    """
    gmt_scripts = []
    for base, _, fnames in os.walk(directory):
        full_fnames = (os.path.join(base, f) for f in fnames)
        gmt_scripts.extend(f for f in full_fnames if is_gmt_script(f))
    return gmt_scripts


def mirror_directory(original, target, ignore):
    """
    Mirror the original directory structure.

    Creates a new 'target' folder and copy all files and subfolders from
    'original', except the files in the 'ignore' list.
    """
    ignore = set(ignore)
    for base, _, fnames in os.walk(original):
        base_target = base.replace(original, target)
        os.mkdir(base_target)
        to_copy = set(os.path.join(base, f) for f in fnames).difference(ignore)
        for fname in to_copy:
            shutil.copy(fname, base_target)


def main():
    """
    Entry point for the command line interface.
    """
    args = docopt(__doc__, version=__version__)

    if args['--quiet'] or not args['--recursive']:

        def echo(*args, **kwargs):
            return None

    else:
        echo = partial(print, file=sys.stderr)

    if args['SCRIPT'] is not None:
        gmt_scripts = [args['SCRIPT']]
        output_names = [None]

        def save_output(content, *args, **kwargs):
            print(content)

    else:
        input_dir = os.path.normpath(args['FOLDER_CLASSIC'])
        output_dir = os.path.normpath(args['FOLDER_MODERN'])
        if os.path.exists(output_dir):
            raise RuntimeError("Target directory '{}' already exists.".format(
                output_dir))
        echo("Scanning '{}' for GMT scripts...".format(input_dir))
        gmt_scripts = find_gmt_scripts(input_dir)
        if len(gmt_scripts) < 1:
            raise RuntimeError("Didn't find any GMT scripts in '{}'.".format(
                input_dir))
        else:
            echo("Found {} GMT scripts:".format(len(gmt_scripts)))
            for fname in gmt_scripts:
                echo("  {}".format(fname))

        echo("Copying folder structure and non-script files to '{}'.".format(
            output_dir))
        mirror_directory(original=input_dir,
                         target=output_dir,
                         ignore=gmt_scripts)

        output_names = [script.replace(input_dir, output_dir)
                        for script in gmt_scripts]

        def save_output(content, fname, original_fname):
            with open(fname, 'w') as outputfile:
                outputfile.write(content)
            # Copy the file permissions to the modern script
            shutil.copymode(original_fname, fname)

    echo("Converting scripts to modern mode:")
    for classic_fname, modern_fname in zip(gmt_scripts, output_names):
        with open(classic_fname) as inputfile:
            classic_script = inputfile.read()
        modern_script = modernize(classic_script)
        save_output(modern_script, modern_fname, classic_fname)
        echo('  {}'.format(modern_fname))

    echo("Done")
