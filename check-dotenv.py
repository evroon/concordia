#!/usr/bin/env python3

from dotenv import dotenv_values

config = dotenv_values(".env")
sample_config = dotenv_values("sample.env")
diff = len(config) - len(sample_config)

if diff < 0:
    print(f'Error: .env has {diff} less entries than sample.env.')
    print('This will likely produce errors.')
