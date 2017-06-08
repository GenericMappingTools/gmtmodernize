# Build, package, test, and clean

TESTDIR=tmp-test-dir-with-unique-name
PYTEST_ARGS=--doctest-modules -v --pyargs
PYTEST_COV_ARGS=--cov-config=../.coveragerc --cov-report=term-missing

.PHONY: test

help:
	@echo "Commands:"
	@echo ""
	@echo "    develop       install in editable mode"
	@echo "    test          run the test suite (including doctests)"
	@echo "    check         run all code quality checks (pep8, linter)"
	@echo "    pep8          check for PEP8 style compliance"
	@echo "    lint          run static analysis using pylint"
	@echo "    coverage      calculate test coverage"
	@echo "    clean         clean up build and generated files"
	@echo ""

develop:
	pip install --no-deps -e .

test:
	mkdir -p $(TESTDIR)
	cd $(TESTDIR); python -c "import gmtmodernize; gmtmodernize.test()"
	rm -r $(TESTDIR)

coverage:
	mkdir -p $(TESTDIR)
	cd $(TESTDIR); pytest $(PYTEST_COV_ARGS) --cov=gmtmodernize $(PYTEST_ARGS) gmtmodernize
	cp $(TESTDIR)/.coverage* .
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
	find . -name ".*~" -exec rm -v {} \;
	rm -rvf build dist MANIFEST *.egg-info __pycache__ .coverage .cache
	rm -rvf $(TESTDIR)
	rm -rvf gmt-trunk *.tar.gz
