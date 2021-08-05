#!/usr/bin/env python3

from dotenv import dotenv_values

config = dotenv_values(".env")
sample_config = dotenv_values("sample.env")

if len(config) < len(sample_config):
    print('Error: .env has less entries than sample.env.')
    print('This will likely produce errors.')
