import os
from pathlib import Path
from dotenv import dotenv_values

config = dotenv_values(".env")

for file in Path().rglob('*'):
    if not os.path.isfile(file) or '.git' in str(file):
        continue

    with open(file, 'r') as f:
        src = f.read()

    with open(file, 'w') as f:
        for param in config:
            src = src.replace(r'${' + param + '}', config[param])

        f.write(src)
