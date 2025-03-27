local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local snippet = {
  python = {
    new_snippet(
      "env_python",
      t([[
#!/usr/bin/env python
]])
    ),

    new_snippet(
      "env_python3",
      t([[
#!/usr/bin/env python3
]])
    ),

    new_snippet(
      "env_python_uv",
      t([[
#!/usr/bin/env -S uv run --script
]])
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "bootstrap_with_logging",
      t([[
#!/usr/bin/env python3

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
]])
    ),

    new_snippet(
      "ordered_dict",
      fmt(
        [[
{} = OrderedDict[
    ('{}', '{}'),
]
]],
        {
          i(1, "dict_name"),
          i(2, "key"),
          i(3, "value"),
        }
      )
    ),

    new_snippet(
      "exception",
      fmt(
        [[
try:
    {}
except:
    logging.exception({})
]],
        {
          i(1, "code"),
          i(2, "message"),
        }
      )
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "exception_print_traceback",
      fmta(
        [[
try:
    <>
except Exception as ex:
    message = f'Exception happened. Traceback: {traceback.format_exc()}'
    print(message)
]],
        {
          i(1, ""),
        }
      )
    ),

    new_snippet(
      "class",
      fmt(
        [[
class {}({}):
    """{}"""
    def __init__(self, {}):
        {}
        self.{} = {}
        {}
]],
        {
          i(1, "ClassName"),
          i(2, "object"),
          i(3, "docstring for ClassName"),
          i(4, "arg"),
          i(5, "super(ClassName, self).__init__()"),
          i(6, "arg"),
          i(7, "arg"),
          i(8, ""),
        }
      )
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "pathlib_current_path",
      t([[
from pathlib import Path
current_path = str(Path().absolute())
print(f'current_path:{current_path}')
]])
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "pathlib_rootpath",
      t([[
from pathlib import Path
root_path = str(Path().absolute().parent)
print(f'root_path:{root_path}')
]])
    ),

    new_snippet(
      "fs",
      fmt(
        [[
f'{}'
]],
        {
          i(1, "string"),
        }
      )
    ),

    new_snippet(
      "timestamp_iso",
      t([[
from datetime import datetime
print(datetime.now().isoformat())
]])
    ),

    new_snippet(
      "datestr",
      t([[
from datetime import datetime
date_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')
]])
    ),

    new_snippet(
      "dateobj",
      t([[
from datetime import datetime
date_obj = datetime.strptime('2011-12-31 11:59:59', '%Y-%m-%d %H:%M:%S')
]])
    ),

    new_snippet(
      "today_and_date_objects",
      t([[
from datetime import datetime
today = datetime.today().date()  # this returns a date (not datetime) object
date_object = datetime(2023, 12, 31).date()  # this builds a date (not datetime) object, that can be compared with "today" above
]])
    ),

    new_snippet(
      "log",
      t([[
logger = logging.getLogger(__name__)
]])
    ),

    new_snippet(
      "ipy",
      t([[
__import__('IPython').embed()
]])
    ),

    new_snippet(
      "pdb",
      t([[
__import__('pdb').set_trace()
]])
    ),

    new_snippet(
      "pudb",
      t([[
__import__('pudb').set_trace()
]])
    ),

    new_snippet(
      "ipdb",
      t([[
__import__('ipdb').set_trace()
]])
    ),

    new_snippet(
      "celery-rdb",
      t([[
from celery.contrib import rdb
rdb.set_trace()
]])
    ),

    new_snippet(
      "pl",
      t([[
 # pylint: disable=
]])
    ),

    new_snippet(
      "ast",
      fmt(
        [[
import ast
print(ast.dump(ast.parse("{}")))
]],
        {
          i(1, "python_code_as_string"),
        }
      )
    ),

    new_snippet(
      "bash",
      t([[
import subprocess

def run(cmd: str):
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
        universal_newlines=True,
    )
    std_out, std_err = proc.communicate()
    return proc.returncode, std_out, std_err
]])
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "ic",
      t([[
from icecream import ic
ic.configureOutput(prefix='icecream debug-> ')
ic('world')
]])
    ),

    new_snippet(
      "pprint_to_console",
      fmt(
        [[
print('\n'); __import__('pprint').pprint({}, width=2); print('\n');  # noqa: E702, E703
]],
        {
          i(1, "var_name"),
        }
      )
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "pprint_to_str",
      t([[
def custom_serializer(obj):
    from datetime import datetime
    if isinstance(obj, datetime):
        return obj.isoformat()  # Converts datetime to ISO 8601 string format
    raise TypeError(f"Type {type(obj)} not serializable")
dict_name_str = __import__('json').dumps(dict_name,
                                         indent=2,
                                         default=custom_serializer)
]])
    ),

    new_snippet(
      "ifmain",
      fmt(
        [[
if __name__ == '__main__':
    {}{}
]],
        {
          i(1, "main()"),
          i(0, ""),
        }
      )
    ),

    new_snippet(
      "uuid",
      t([[
import uuid, sys
sys.stdout.write(str(uuid.uuid4()))
]])
    ),

    new_snippet(
      "random_number",
      fmt(
        [[
{}import random
import os

def generate_random_number(start: int, finish: int, seed_bytes:int=128) -> str:
    random.seed(os.urandom(seed_bytes))
    return random.randint(start, finish)
]],
        {
          i(1, ""),
        }
      )
    ),

    new_snippet(
      "stdout_write",
      fmt(
        [[
sys.stdout.write('{}')
]],
        {
          i(1, ""),
        }
      )
    ),

    new_snippet(
      "function_type_hint_example",
      t([[
from typing import Callable
GreetingReader = Callable[[], str]
#                         |   |
#                         |   |> return value
#                         |
#                         |> arguments
]])
    ),

    new_snippet(
      "immutable_sort_randomization",
      t([[
import random
test_list = [12, 34, 234, 452, -1]
sorted_list = sorted(test_list)  # you will create a new list, not changing test_list values
shuffled_list = random.sample(sorted_list, k=len(sorted_list))  # you will create a new list, not changing test_list values
]])
    ),

    new_snippet(
      "mutable_sort_randomization",
      t([[
import random
test_list = [12, 34, 234, 452, -1]
test_list.sort()  # this will change test_list values
print(test_list)
random.shuffle(test_list)   # this will change test_list
print(test_list)
]])
    ),

    new_snippet(
      "set-union",
      fmt(
        [[
{} | {}
]],
        {
          i(1, "set1"),
          i(2, "set2"),
        }
      )
    ),

    new_snippet(
      "set-intersection",
      fmt(
        [[
{} & {}
]],
        {
          i(1, "set1"),
          i(2, "set2"),
        }
      )
    ),

    new_snippet(
      "set-difference",
      fmt(
        [[
{} - {}
]],
        {
          i(1, "set1"),
          i(2, "set2"),
        }
      )
    ),

    new_snippet(
      "heap",
      t([[
import heapq
heap = [1, 2, 65, 78, 98, 3, 6, 7, 99]  # it is not ordered
heapq.heapify(heap)  # this will mutate heap to be ordered
heapq.nlargest(3, heap)  # 3 max numbers
heapq.nsmallest(3, heap)  # 3 minor numbers
heapq.heappush(heap, -9)  # add a number on the heap (keeping it on the right order)
heapq.heappop(heap)  # remove the smallest number on the heap (keeping it on the right order)
heapq.heappushpop(heap, 12)  # add a new number and return the smallest one (keeping it on the right order)
heap[0]  # O(1) way to get the smallest number
heapq.nlargest(1, heap)  # get the greatest number (it will NOT necessarily be the last one on the array)
]])
    ),

    new_snippet(
      "binary_search",
      t([[
import bisect
index_that_has_555_on_an_array = bisect.bisect(my_array, 555)
bisect.insort(my_array, 666)  # insert element on the binary tree
]])
    ),

    new_snippet(
      "super",
      t([[
super().__init__()
]])
    ),

    new_snippet(
      "pytest_parametrize",
      t([[
@pytest.mark.parametrize('var1,var2',
    [
        ('tuple1-var1', 'tuple1-var2',),
        ('tuple2-var1', 'tuple2-var2',),
    ],
)
def test_name(var1, var2):
    # use var1 and var2 here
]])
    ),

    new_snippet(
      "pytest_run_on_condition",
      fmt(
        [[
@pytest.mark.skipif({}, reason="{}")
]],
        {
          i(1, "bool_condition"),
          i(2, "string_describing_condition"),
        }
      )
    ),

    -- Using text node for snippets with complex string content
    new_snippet(
      "pytest_raises",
      t([[
with pytest.raises(IntegrityError) as exception_instance:
    pass  # code that triggers the exception, in this example SQLAlchemy when an attribute is None

assert exception_instance.type is IntegrityError
expected_exception_value = '(pymysql.err.IntegrityError) (1048, "Column \'company_id\' cannot be null")'
assert exception_instance.value.args[0] == expected_exception_value
]])
    ),

    new_snippet(
      "pytest_skip_decorator",
      fmt(
        [[
@pytest.mark.skip(reason="{}")
]],
        {
          i(1, ""),
        }
      )
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "function_info",
      t([[
# fun below can be any function object.
# e.g. fun = print
info = f'module: {fun.__module__} , name: {fun.__qualname__}'
print(info)
]])
    ),

    new_snippet(
      "md5_hash",
      t([[
# Works only on strings
# To use on dicts, just use cast them to a string - str(your_dict)
import hashlib
hashlib.md5("YOUR-STRING-GOES-HERE".encode('utf-8')).hexdigest()
]])
    ),

    new_snippet(
      "traceback_print_current_stack",
      t([[
__import__('traceback').print_stack()
]])
    ),

    new_snippet(
      "pathlib_get_files_in_directory",
      t([[
from pathlib import Path

def get_files(path='.', filetype = ".py"):
    # globs notation:
    # **/* : search on subdirectories
    # *    : search on current directory
    files = Path(path).glob('**/*' + filetype)
    for file_name in files:
        print(file_name)
]])
    ),

    new_snippet(
      "loop_on_list_popping_elements",
      t([[
while my_list:
    # pop the first element from the list, when finished exits the loop
    elem = my_list.pop(0)
    print(elem)
]])
    ),

    -- Using text node for snippets with f-strings
    new_snippet(
      "cli_args",
      t([[
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("name", type=str, help="type the person name here")
parsed_arguments = parser.parse_args()
message = f"The 'name' arg has this value: {parsed_arguments.name}"
print(message)
]])
    ),

    new_snippet(
      "stdlib_http_post_request",
      t([[
import http.client, urllib
conn = http.client.HTTPSConnection("api.pushover.net:443")
conn.request("POST", "/1/messages.json",
    urllib.parse.urlencode({
        "token": "abc123",
        "user": "user123",
        "message": "hello world",
    }), { "Content-type": "application/x-www-form-urlencoded" })
conn.getresponse()
]])
    ),

    new_snippet(
      "sort_list_items_alphabetically",
      t([[
# the "key" param below makes sort ignore the case,
# as if all strings on the list are lowercase.
sorted(lst, key=str.lower)

# to sort in reverse order and ignoring the case
sorted(lst, key=str.lower, reverse=True)
]])
    ),

    new_snippet(
      "json_dict_to_file",
      fmt(
        [[
with open("/tmp/output.json", "w+") as output_file:
    output_file.write(__import__('json').dumps({}, indent=2))
]],
        {
          i(1, "dict_var_name"),
        }
      )
    ),
  },
}

return snippet
