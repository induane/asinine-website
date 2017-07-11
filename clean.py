#!/bin/python
import sys
import os

IGNORE = (
    __name__,
    os.path.abspath(__file__),
    os.path.basename(__file__),
)

rmap = (
    (u' \u2026', '...'),
    (u'\u2026', '...'),
    (u'\u201c', '"'),
    (u'\u201d', '"'),
    (u'\u2019', "'"),
    (u'\u2018', "'"),
    (u'\n', '\n\n'),  # Comment out for newline ready files
)


def clean_file(filename):
    """Clean up quotes and shit."""
    with open(filename, 'r+b') as f:
        data = f.read().decode('utf-8')
        for a, b in rmap:
            data = data.replace(a, b)
        f.seek(0)
        f.truncate()
        f.write(data.encode('utf-8'))


if __name__ == "__main__":

    for item in sys.argv:
        if item not in IGNORE:
            path = os.path.abspath(item)
            break
    else:
        sys.stdout.write("Missing required filename argument.\n")
        sys.exit(1)

    if not os.path.exists(path):
        sys.stdout.write("Error: File doesn't exist.\n")
        sys.exit(1)

    clean_file(path)
