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
	rm -rf docs
	mkdir docs
	mv build/html/* docs/
	touch docs/.nojekyll
	rm -rf build
