"""
Functions to convert a classic script into a modern one.

The main functionality is exposed through the ``modernize`` function.
"""

from .cli import GMTModernizeApp


def modernize(script):
    """
    Convert a script from classic to modern mode.

    Parameters
    ----------
    script : str
        Classic mode script.

    Returns
    -------
    str
        Script converted to modern mode.

    """
    app = GMTModernizeApp(['bla', 'meh', 'foo'])
    return '\n'.join(app.modernize(script.split('\n')[:-1]))
