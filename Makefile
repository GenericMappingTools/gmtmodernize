TESTDIR=test_modern

help:
	@echo "Commands:"
	@echo ""
	@echo "    test          run the test suite (including doctests)"
	@echo "    check         run all code quality checks (pep8, linter)"
	@echo "    pep8          check for PEP8 style compliance"
	@echo "    lint          run static analysis using pylint"
	@echo "    clean         clean up build and generated files"
	@echo ""

test: clean
	./gmtmodernize test $(TESTDIR)

pep8:
	flake8 gmtmodernize

lint:
	pylint gmtmodernize

check: pep8 lint

clean:
	find . -name "*.pyc" -exec rm {} \;
	rm -rf build dist MANIFEST *.egg-info __pycache__ .coverage .cache
	rm -rf $(TESTDIR)
