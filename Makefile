# Makefile for building doc

PYTHON=python3
ENV_DIR=.env_$(PYTHON)
IN_ENV=. $(ENV_DIR)/bin/activate &&
EPUB_ENV=export EPUB_ENV=True &&

# You can set these variables from the command line.
SPHINXOPTS    ?=
SPHINXBUILD   ?= $(IN_ENV) sphinx-build
SOURCEDIR     = .
BUILDDIR      = build

# Common env setup
BASEBUILD = $(IN_ENV) $(SPHINXBUILD) -E

# User-friendly check for sphinx-build
# ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
# 	$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don\'t have Sphinx installed, grab it from http://sphinx-doc.org/)
# endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

env: $(ENV_DIR)

$(ENV_DIR):
	$(PYTHON) -m venv .env_$(PYTHON)

build-reqs: env
	$(IN_ENV) pip install -r requirements.txt

update:
	$(IN_ENV) pip install -U -r requirements.txt

freeze: env
	$(IN_ENV) pip freeze

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)/*
	-rm -rf $(BUILDDIR)/*
	-rm -rf $(BUILDDIR)
	-rm -rf _static/css/theme.css
	-rm -rf _static/css/badge_only.css
	-rm -rf _static/fonts
	-rm -rf _static/js
	- @find . -name '*.DS_Store' -delete
	- @find . -name '*.pyc' -delete
	- @find . -name '*.pyd' -delete
	- @find . -name '*.pyo' -delete
	- @find . -name '*__pycache__*' -delete

.PHONY: env-clean
env-clean:
	-rm -rf .env*
	-rm -rf .env_python2.6
	-rm -rf .env_python2.7

.PHONY: prep-html
prep-html: build-reqs
	cp -r $(ENV_DIR)/lib/python*/site-packages/sphinx_rtd_theme/static/* _static/
	cat _static/css/custom.css >> _static/css/theme.css
	$(BASEBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	cp -r resources _build/html/

	@echo
	@echo "Post build find/replace..."
	- find _build/ -type f -print0 | xargs -0 sed -i 's/Search docs/Search/g'
	- find _build/ -type f -print0 | xargs -0 sed -i 's/border="1"//g'
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	cp -r resources build/html/
	cp -r _static/* build/html/_static/
	- find build/ -type f -print0 | xargs -0 sed -i 's/Search docs/Search/g'
	- find build/ -type f -print0 | xargs -0 sed -i 's/border="1"//g'
