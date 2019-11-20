# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

import inspect
import sys
import traceback
from test import *
from test.utils import Test

import colorama
from colorama import Fore, Style

from populate_database import create_database

# Retrieve all test classes, i.e., those who inherit from Test
test_classes = Test.__subclasses__()

# Init stuff
passed_tests = failed_tests = 0
colorama.init()

classes_to_run = [x.lower() for x in sys.argv[1:]]

print("Resetting database...", end="")
create_database()
print(" done.")

for c in test_classes:
    test_class = c()
    c_name = c.__name__

    # If the user has specified which test classes to run,
    # check that the present class is in the list
    if classes_to_run and c_name.lower() not in classes_to_run:
        continue

    print(
        f"\nRunning tests from class {c_name}\n"
        "---------------------------------------"
    )

    # Find all test methods for the current class and run each of them
    test_methods = inspect.getmembers(test_class, predicate=inspect.ismethod)
    for m_name, m in test_methods:
        try:
            m()
            passed_tests += 1
            print(Fore.GREEN + f"\t• {c_name}.{m_name} - OK" + Style.RESET_ALL)
        except Exception:
            failed_tests += 1
            print(Fore.RED + f"\t• {c_name}.{m_name} - FAIL" + Style.RESET_ALL)
            traceback.print_exc()


# Display the results
print("\n=========================================================")
print(
    f"Ran {passed_tests + failed_tests} tests: "
    f"{passed_tests} {Fore.GREEN}passed{Style.RESET_ALL}, "
    f"{failed_tests} {Fore.RED}failed{Style.RESET_ALL}"
)
print("=========================================================")
