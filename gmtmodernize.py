import os
import sys

PSMODULES = """
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
    Given a GMT shell script (as a string), modernize it and return the new
    text.
    """



def main(args):
    assert len(args) > 3, 'Too few arguments. Provide input dir and output dir'
    input_dir = args[1]
    output_dir = args[2]





if __name__ == '__main__':
    main(sys.argv)
