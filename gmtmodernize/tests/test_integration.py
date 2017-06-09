"""
Test that the library converts a set of test scripts correctly.
"""
import os
import pytest

from .. import modernize


TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), 'data')


def load_test_scripts(path):
    """
    Utility function to load all scripts from the given folder and return them
    in a dict.
    """
    scripts = dict()
    for fname in os.listdir(path):
        if os.path.splitext(fname)[-1] == '.sh' and fname[0] != '~':
            with open(os.path.join(path, fname)) as script:
                scripts[fname] = script.read()
    return scripts


@pytest.fixture(scope='module')
def classic():
    """
    Scripts in classic mode.
    """
    return load_test_scripts(os.path.join(TEST_DATA_DIR, 'classic'))


@pytest.fixture(scope='module')
def modern():
    """
    Scripts in modern mode corresponding to the same scripts in classic mode.
    """
    return load_test_scripts(os.path.join(TEST_DATA_DIR, 'modern'))


def test_integration(classic, modern):
    'Compare converted scripts to a reference of what they should be.'
    assert set(classic.keys()) == set(modern.keys()), \
        'Different number of scripts in classic and modern data dirs'
    for script in classic:
        modernized = modernize(classic[script])
        assert modernized == modern[script], \
            'Failed {}.\n\nModernized:\n\n{}\n\nExpected:\n\n{}\n\n'.format(
                script, modernized, modern[script])
