# Build, package, test, and clean

TESTDIR=tmp-test-dir-with-unique-name

help:
	@echo "Commands:"
	@echo ""
	@echo "    develop       install in editable mode"
	@echo "    test          run the test suite (including doctests)"
	@echo "    gmt           update and install GMT from source"
	@echo "    check         run all code quality checks (pep8, linter)"
	@echo "    pep8          check for PEP8 style compliance"
	@echo "    lint          run static analysis using pylint"
	@echo "    coverage      calculate test coverage"
	@echo "    clean         clean up build and generated files"
	@echo ""

develop:
	pip install --no-deps -e .

gmt:
	cd tools; ./install_gmt_trunk.sh

test:
	# Run a tmp folder to make sure the tests are run on the installed version
	# of Fatiando
	mkdir -p $(TESTDIR)
	cd $(TESTDIR); python -c "assert True"
	rm -r $(TESTDIR)

coverage:
	# Run a tmp folder to make sure the tests are run on the installed version
	# of Fatiando
	mkdir -p $(TESTDIR)
	cd $(TESTDIR); python -c "assert True"
	rm -r $(TESTDIR)

pep8:
	flake8 gmtmodernize setup.py

lint:
	pylint gmtmodernize setup.py

check: pep8 lint

package:
	python setup.py sdist --formats=gztar

clean:
	find . -name "*.pyc" -exec rm -v {} \;
	rm -rvf build dist MANIFEST *.egg-info __pycache__ .coverage .cache
	rm -rvf $(TESTDIR)
	rm -rvf gmt-trunk *.tar.gz
