#!/usr/bin/env python3
from __future__ import annotations

import argparse
from glob import glob

from utils import process

PYTHON_MODULE_COMMAND = ['python3', '-m']


def get_python_files() -> list[str]:
    return glob('**/*.py')  # + glob('ansible/roles/munin/templates/plugins/*.py.j2')


def run_mypy(check: bool) -> None:
    command = PYTHON_MODULE_COMMAND + ['mypy']
    if check:
        command.append('--check')

    command.append('.')
    process.run_checked(command)


def run_black(check: bool) -> None:
    command = PYTHON_MODULE_COMMAND + ['black']
    if check:
        command.append('--check')

    command.append('.')
    process.run_checked(command)


def run_pylint() -> None:
    command = PYTHON_MODULE_COMMAND + ['pylint']
    command.extend(get_python_files())
    process.run_checked(command)


def run_isort(check: bool) -> None:
    command = PYTHON_MODULE_COMMAND + ['isort']
    if check:
        command.append('--check')

    command.append('.')
    process.run_checked(command)


def run_autoflake(check: bool) -> None:
    command = PYTHON_MODULE_COMMAND + ['autoflake']
    if check:
        command.append('--check')
    else:
        command.extend(['--in-place', '--remove-all-unused-imports'])

    command.extend(['--quiet', '-r', '.'])
    process.run_checked(command)


def run_bandit() -> None:
    command = PYTHON_MODULE_COMMAND + ['bandit']
    command.extend(
        [
            '-r',
            '-q',
            '-c',
            'pyproject.toml',
            '.',
            '--format',
            'xml',
            '--output',
            '.junit_report.xml',
        ]
    )
    process.run_checked(command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Provision this machine.')
    parser.add_argument('--check', action='store_true', help='Check only, don\'t fix issues')
    parser.add_argument('--mypy', action='store_true', help='Run mypy')
    parser.add_argument('--black', action='store_true', help='Run black')
    parser.add_argument('--pylint', action='store_true', help='Run pylint')
    parser.add_argument('--isort', action='store_true', help='Run isort')
    parser.add_argument('--autoflake', action='store_true', help='Run autoflake')
    parser.add_argument('--bandit', action='store_true', help='Run bandit')
    args_parsed = parser.parse_args()

    run_all = (
        not args_parsed.mypy
        and not args_parsed.black
        and not args_parsed.pylint
        and not args_parsed.isort
        and not args_parsed.autoflake
        and not args_parsed.bandit
    )

    if run_all or args_parsed.mypy:
        run_mypy(args_parsed.check)

    if run_all or args_parsed.black:
        run_black(args_parsed.check)

    if run_all or args_parsed.pylint:
        run_pylint()

    if run_all or args_parsed.isort:
        run_isort(args_parsed.check)

    if run_all or args_parsed.autoflake:
        run_autoflake(args_parsed.check)

    if run_all or args_parsed.bandit:
        run_bandit()
