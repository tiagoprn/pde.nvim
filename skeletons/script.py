# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "typer",
#   "requests"
# ]
# ///

"""
The headers above are defined on PEP 723,
and they allow a script to run with uv running:

    uv run script.py


If you want to run the script directly, you can also include the following on your shebang line:

    #!/usr/bin/env -S uv run --script

(on my vim snippets this is "env_python_uv")

Then, chmod the file to be executable (e.g. chmod 755 script.py)

Given all this, the shell will run "uv run --script" with the file as the argument.

"""

import logging
import os
import sys

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FORMAT = (
    "[%(asctime)s PID %(process)s "
    "%(filename)s:%(lineno)s - %(funcName)s()] "
    "%(levelname)s -> \n"
    "%(message)s\n"
)
# Configure the logging both to file and to console. Works from python 3.3+
logging.basicConfig(
    format=LOG_FORMAT,
    level=logging.INFO,
    handlers=[
        logging.FileHandler(f"{CURRENT_SCRIPT_NAME}.log"),
        logging.StreamHandler(sys.stdout),
    ],
)


if __name__ == "__main__":
    print("Hello world!")
