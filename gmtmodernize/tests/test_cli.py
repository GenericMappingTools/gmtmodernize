"""
Test components of the command line program.
"""
import os
import shutil

from ..cli import find_gmt_scripts, mirror_directory, is_gmt_script


TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), 'data')


def test_find_gmt_scripts():
    """
    Check if find_gmt_scripts finds all files in the 'classic' folder of the
    test data.
    """
    folder = os.path.join(TEST_DATA_DIR, 'classic')
    existing_scripts = set(os.path.join(folder, f) for f in os.listdir(folder))
    scripts_found = set(find_gmt_scripts(folder))
    assert scripts_found == existing_scripts


def test_is_gmt_script():
    """
    Check if identifying scripts correctly.
    """
    scripts = 'bla.sh dir/meh.sh'.split()
    not_scripts = 'meh bla bla/foo.txt foo.abc'.split()
    for script in scripts:
        assert is_gmt_script(script), 'Failed for {}'.format(script)
    for not_script in not_scripts:
        assert not is_gmt_script(not_script), \
            'Failed for {}'.format(not_script)


def test_mirror_directory():
    """
    Check if the correct directory structure is copies (excluding script files)
    """
    pjoin = os.path.join
    folder = pjoin(TEST_DATA_DIR, 'mirror_directory')
    target = folder.replace('mirror_directory', 'test_mirrored')
    # Copy the entire directory
    try:
        mirror_directory(folder, target, [])
        true_files = [
            "not_script.xyz",
            "script.sh",
            pjoin("level1", "not_script.txt"),
            pjoin("level1", "level2", "not_script.txt"),
            pjoin("level1", "level2", "script.sh"),
            pjoin("subfolder", "not_script.foo"),
            pjoin("subfolder", "script.sh"),
        ]
        should_contain = [pjoin(target, f) for f in true_files]
        contains = [pjoin(base, f)
                    for base, _, files in os.walk(target)
                    for f in files]
        assert set(contains) == set(should_contain), "Failed for all files"
    finally:
        shutil.rmtree(target)
    # Ignore a few files
    ignore = [pjoin(folder, f)
              for f in ['script.sh',
                        pjoin('level1', 'level2', 'script.sh'),
                        pjoin('subfolder', 'script.sh')]]
    try:
        mirror_directory(folder, target, ignore)
        true_files = [
            "not_script.xyz",
            pjoin("level1", "not_script.txt"),
            pjoin("level1", "level2", "not_script.txt"),
            pjoin("subfolder", "not_script.foo"),
        ]
        should_contain = [pjoin(target, f) for f in true_files]
        contains = [pjoin(base, f)
                    for base, _, files in os.walk(target)
                    for f in files]
        assert set(contains) == set(should_contain), "Failed for ignored files"
    finally:
        shutil.rmtree(target)
