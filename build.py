import os
import argparse
from pathlib import Path
from dotenv import dotenv_values

parser = argparse.ArgumentParser(description='Substitute secrets in files.')
parser.add_argument('directory', metavar='d', type=str,
                    help='the directory in which files are replaced')

args = parser.parse_args()

config = dotenv_values(".env")

for file in Path(args.directory).rglob('*'):
    if not os.path.isfile(file) or '.git/' in str(file):
        continue

    try:
        with open(file, 'r') as f:
            src = f.read()
    except UnicodeDecodeError:
        print(f'Could not read {file}')
        continue


    with open(file, 'w') as f:
        for param in config:
            src = src.replace(r'${' + param + '}', config[param])

        f.write(src)
