#!/usr/bin/env python3

import sys
from dotenv import dotenv_values

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


config = dotenv_values(".env")
sample_config = dotenv_values("sample.env")
diff = len(sample_config) - len(config)

if diff > 0:
    print(f'{bcolors.FAIL}Error: .env has {diff} less entries than sample.env.{bcolors.ENDC}')
    print(f'{bcolors.FAIL}This will likely produce errors.{bcolors.ENDC}')
    sys.exit(1)
else:
    print(f'{bcolors.OKGREEN}.env file is valid.{bcolors.ENDC}')
