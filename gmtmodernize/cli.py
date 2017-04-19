"""
Convert GMT scripts to the new "modern" mode.

$ gmtmodernize old_script_dir modern_scripts_dir

Will crawl old_script_dir and convert any '*.sh' file to the GMT modern mode.
Modernized scripts and any other files present will be saved to
modern_scripts_dir using the same directory tree as the old scripts.

What it converts:

1. Inserts "gmt set GMT_RUNMODE modern" to the start of the script.
2. Removes -O -K -R -J (the last two only if alone).
3. If script defines a variable "ps=somefile.ps", will remove the '.ps' from
   the variable and insert a "psconvert ... -T$ps" at the end of the script.
4. Removes any redirection to "> $ps".

So far, it only works for the test scripts in the GMT repository or ones that
follow this rigid format.
"""
import os
import sys
import shutil
import re


def warn(*args, **kwargs):
    """
    Print message to stderr.
    """
    print(file=sys.stderr, *args, **kwargs)


class GMTModernizeApp():
    """
    The application class.
    """

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

    def __init__(self, args, verbose=False, output_type='ps'):
        self.verbose = verbose
        assert output_type in ['pdf', 'ps']
        self.output_type = output_type
        assert len(args) >= 3, \
            'Too few arguments. Provide input dir and output dir'
        self.input_dir = os.path.normpath(args[1])
        self.output_dir = os.path.normpath(args[2])
        if '--quite' in args or '-q' in args:
            self.verbose = False
        else:
            self.verbose = True

    def info(self, *args, **kwargs):
        """
        Print message to stderr according to set verbosity.
        """
        if self.verbose:
            print(file=sys.stderr, *args, **kwargs)

    def modernize(self, script):
        """
        Given a GMT shell script (as a string), modernize it and return the new
        text.
        """
        modern = []
        ps_name = None
        if self.output_type == 'ps':
            args = '-Tp'
        elif self.output_type == 'pdf':
            args = '-Tf -P -A'
        psconvert = '\ngmt psconvert {} -F$ps\n'.format(args)

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

        return modern

    def convert_script(self, old_script, modern_script):
        """
        Convert a script file in the old style to the modern style.

        Reads in 'old_script', modernize it, and save the output to
        'modern_scrip'.
        """
        self.info('  Converting:', old_script, ' --> ', modern_script)
        with open(old_script) as infile:
            old_content = infile.readlines()
        modern_content = self.modernize(old_content)
        with open(modern_script, 'w') as outfile:
            outfile.write('\n'.join(modern_content))

    def crawl_and_modernize(self, input_dir, output_dir):
        """
        Crawl the input dir and copy/modernize the contents to output dir.

        Will copy any file that isn't a shell script (ends in .sh).
        """

        for base, _, files in os.walk(input_dir):
            self.info('Base dir:', base)
            base_output = base.replace(input_dir, output_dir)
            os.mkdir(base_output)

            scripts = set(f for f in files if os.path.splitext(f)[-1] == '.sh')
            not_scripts = set(files).difference(scripts)

            for file in not_scripts:
                shutil.copy(os.path.join(base, file), base_output)

            for script in scripts:
                modern_script = os.path.join(base_output, script)
                old_script = os.path.join(base, script)
                self.convert_script(old_script, modern_script)

    def main(self):
        """
        Execute the app to convert the scripts.
        """

        if os.path.exists(self.output_dir):
            warn("Aborting: Output directory '{}' already exists.".format(
                self.output_dir))
            return 1

        self.crawl_and_modernize(self.input_dir, self.output_dir)

        return 0


def main():
    sys.exit(GMTModernizeApp(sys.argv).main())
