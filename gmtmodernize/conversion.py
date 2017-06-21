"""
Functions to convert a classic script into a modern one.

The main functionality is exposed through the ``modernize`` function.
"""
import re
import os


# List of GMT modules that generate Postscript output
PS_MODULES = """
gmtlogo
grdcontour
grdimage
grdvector
grdview
psbasemap
psclip
pscoast
pscontour
pshistogram
psimage
pslegend
psmask
psrose
psscale
pssolar
pstext
pswiggle
psxyz
psxy
pscoupe
psmeca
pspolar
pssac
psvelo
mgd77track
pssegyz
pssegy
""".split()


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
    modern = []
    script = script.split('\n')[:-1]

    # Copy the header comments and add a command to set the mode
    # to modern after the header
    for line in script:
        line = line.rstrip()
        if not line or line[0] != '#':
            break
        modern.append(line)
    last_line = len(modern)

    # Look for the "ps" variable definition and extract the name
    ps_var_line = None
    for l, line in enumerate(script[last_line:]):
        line = line.strip()
        # Check if this line defines a .ps file name variable
        ps_var_def = re.findall(r'^ps=.+\.ps$', line)
        if ps_var_def:
            assert len(ps_var_def) == 1, \
                "Found more than 1 ps variable in line '{}'".format(line)
            ps_definition = ps_var_def[0]
            line = os.path.splitext(ps_definition)[0]
            modern.append('')
            modern.append(line)
            ps_var_line = last_line + l
            break
    if ps_var_line is not None:
        script.pop(ps_var_line)
        begin_args = " $ps ps"
    else:
        begin_args = ""

    modern.append('')
    modern.append('gmt begin{}'.format(begin_args))
    modern.append('')

    # Parse the rest of the script
    for line in script[last_line:]:
        line = line.rstrip()

        # Check if redirecting to the $ps variable and strip it out
        redirect_to_ps = re.findall(r'.+>+ *\$ps(?: +|$)', line)
        if redirect_to_ps:
            assert len(redirect_to_ps) == 1, \
                "Found more than 1 ps redirection in line '{}'".format(
                    line)
            redirection = re.findall(r'>+ *\$ps(?: +|$)', line)[0]
            line = line.replace(redirection, '').strip()

        # Remove -O -K -R -J
        okrj = re.findall(r'(?:(?<= )|^)-[KORJ](?: +|$)', line)
        if okrj:
            for match in okrj:
                line = line.replace(match, '')
            line = line.strip()

        modern.append(line)

    modern.append('')
    modern.append('gmt end')
    modern.append('')

    # Remove duplicate blank lines
    modern = [line for l, line in enumerate(modern)
              if l == 0 or not (line == '' and modern[l - 1] == '')]

    return '\n'.join(modern)
