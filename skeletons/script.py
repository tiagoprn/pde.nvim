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
