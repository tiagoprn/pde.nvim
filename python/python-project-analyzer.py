#!/usr/bin/env python3

"""
This script generates a file named definitions.txt,
that has a list of all classes, methods and functions
on a python project.

It was created because the python LSP servers I use
(pylsp and jedi) do not have "workspace_symbols" functionality,
which could provide that.

This can be used in conjuntion with my custom telescope picker
"python_project_search", that parses the definitions.txt
file and allows searching on the whole project.
"""

import ast
import argparse
from pathlib import Path


def extract_definitions(filepath, source_dir):
    with filepath.open('r', encoding='utf-8') as f:
        tree = ast.parse(f.read(), str(filepath))

    definitions = []

    for node in ast.walk(tree):
        if isinstance(node, ast.ClassDef):
            definitions.append(
                {
                    'type': 'class',
                    'name': node.name,
                    'file': str(
                        filepath.relative_to(source_dir)
                    ),  # use relative path
                    'line': node.lineno,
                }
            )

            for item in node.body:
                if isinstance(item, ast.FunctionDef):
                    definitions.append(
                        {
                            'type': 'method',
                            'name': f'{node.name}.{item.name}',
                            'file': str(
                                filepath.relative_to(source_dir)
                            ),  # use relative path
                            'line': item.lineno,
                        }
                    )
        elif isinstance(node, ast.FunctionDef):
            definitions.append(
                {
                    'type': 'function',
                    'name': node.name,
                    'file': str(
                        filepath.relative_to(source_dir)
                    ),  # use relative path
                    'line': node.lineno,
                }
            )

    return definitions


def main():
    parser = argparse.ArgumentParser(
        description="Extract Python class, method, and function definitions."
    )
    parser.add_argument(
        'source_dir',
        type=str,
        help="Directory containing the Python source files.",
    )
    args = parser.parse_args()

    source_dir = Path(
        args.source_dir
    ).resolve()  # Resolve to get absolute path

    if not source_dir.exists():
        print(f"The directory {source_dir} does not exist.")
        return

    # Exclude directories like .venv, venv, and node_modules
    excluded_dirs = {'.venv', 'venv', 'node_modules'}

    all_definitions = []

    # Recursively traverse all Python files in the directory excluding unwanted subdirectories
    for filepath in source_dir.rglob('*.py'):
        if any(excluded in filepath.parts for excluded in excluded_dirs):
            continue
        all_definitions.extend(extract_definitions(filepath, source_dir))

    # Sort definitions by the 'name' key
    all_definitions.sort(key=lambda x: x['name'])

    if not all_definitions:
        print("No Python files found.")
        return

    output_file = source_dir / 'definitions.txt'  # Renamed to output_file and the filename
    with open(output_file, 'w', encoding='utf-8') as file:
        for definition in all_definitions:
            # Use spaces as separators
            line = f"{definition['type']} {definition['name']} {definition['file']} {definition['line']}\n"
            file.write(line)

    print(f"Definitions saved to '{output_file}'.")


if __name__ == "__main__":
    main()
