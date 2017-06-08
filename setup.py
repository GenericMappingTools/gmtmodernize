from setuptools import setup, find_packages

# PACKAGE METADATA
# #############################################################################
NAME = 'gmtmodernize'
FULLNAME = 'gmtmodernize'
DESCRIPTION = "Tool to convert GMT scripts to the new modern execution mode"
AUTHOR = "Leonardo Uieda"
AUTHOR_EMAIL = 'leouieda@gmail.com'
MAINTAINER = AUTHOR
MAINTAINER_EMAIL = AUTHOR_EMAIL
VERSION = '0.1a1'
with open("README.rst") as f:
    LONG_DESCRIPTION = ''.join(f.readlines())
PACKAGES = find_packages(exclude=['doc', 'ci', 'test', 'example'])
LICENSE = "BSD License"
URL = "https://github.com/GenericMappingTools/gmtmodernize"
PLATFORMS = "Any"
SCRIPTS = []
PACKAGE_DATA = {
    'gmtmodernize.tests': [
        'data/classic/*',
        'data/modern/*',
        'data/mirror_directory/*',
        'data/mirror_directory/subfolder/*',
        'data/mirror_directory/level1/*',
        'data/mirror_directory/level1/level2/*',
    ],
}
CLASSIFIERS = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Science/Research",
    "Intended Audience :: Developers",
    "Intended Audience :: Education",
    "Topic :: Scientific/Engineering",
    "Topic :: Software Development :: Libraries",
    "Programming Language :: Python :: 3.6",
    "License :: OSI Approved :: {}".format(LICENSE),
]
KEYWORDS = ''
ENTRY_POINTS = {
    'console_scripts': ['gmtmodernize=gmtmodernize.cli:main', ]
}

# DEPENDENCIES
# #############################################################################
INSTALL_REQUIRES = [
    'docopt',
    # 'tqdm',
]

if __name__ == '__main__':
    setup(name=NAME,
          fullname=FULLNAME,
          description=DESCRIPTION,
          long_description=LONG_DESCRIPTION,
          version=VERSION,
          author=AUTHOR,
          author_email=AUTHOR_EMAIL,
          maintainer=MAINTAINER,
          maintainer_email=MAINTAINER_EMAIL,
          license=LICENSE,
          url=URL,
          platforms=PLATFORMS,
          scripts=SCRIPTS,
          packages=PACKAGES,
          package_data=PACKAGE_DATA,
          classifiers=CLASSIFIERS,
          keywords=KEYWORDS,
          install_requires=INSTALL_REQUIRES,
          entry_points=ENTRY_POINTS)
