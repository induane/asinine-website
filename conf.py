from datetime import date
import sphinx_rtd_theme

project = 'Asinine'
author = 'Asinine Media Inc.'
contributor = 'Brant A. P. Watson'
copyright = f'{date.today().strftime("%Y")}, {author}.'
version = '1.0.0'
release = '1'

extensions = ['sphinx.ext.autodoc', 'sphinx.ext.todo', 'sphinx.ext.coverage',
              'sphinx.ext.viewcode', 'sphinx.ext.imgmath']
templates_path = ["_templates"]
html_static_path = ["_static"]
exclude_patterns = []

html_theme = "sphinx_rtd_theme"
html_css_files = ["custom.css"]
html_title = "Harren Press/Asinine Media"
html_short_title = "Asinine"
