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
    ps_name = None
    psconvert = '\ngmt psconvert -Tp -F$ps\n'
    script = script.split('\n')[:-1]

    # Copy the header comments and add a command to set the mode
    # to modern after the header
    for line in script:
        line = line.strip()
        if not line or line[0] != '#':
            break
        modern.append(line)
    last_line = len(modern)
    modern.append('gmt set GMT_RUNMODE modern')

    # Parse the rest of the script
    for line in script[last_line:]:
        line = line.strip()

        # Check if this line defines a .ps file name variable
        ps_var_def = re.findall(r'^ps=.+\.ps$', line)
        if ps_var_def:
            assert len(ps_var_def) == 1, \
                "Found more than 1 ps variable in line '{}'".format(line)
            ps_definition = ps_var_def[0]
            ps_file_name = ps_definition.split('=')[1]
            ps_name = os.path.splitext(ps_file_name)[0]
            line = os.path.splitext(ps_definition)[0]

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

        # Check if line is deleting gmt.conf. Need to insert the psconvert
        # before that.

    # Only add a psconvert call if this script defined a ps variable
    if ps_name is not None:
        rm_gmt_conf = [i for i, line in enumerate(modern)
                       if re.findall('(?:(?<= )|^)rm .* gmt.conf(?: +|$)',
                                     line)]
        assert len(rm_gmt_conf) <= 1, "Found more than 1 'rm gmt.conf'"
        if rm_gmt_conf:
            modern.insert(rm_gmt_conf[0], psconvert)
            modern.append('')  # Make sure the file ends in a newline
        else:
            modern.append(psconvert)

    return '\n'.join(modern)
