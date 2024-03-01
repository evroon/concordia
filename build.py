#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os

from utils import process


def get_secrets(args: argparse.Namespace) -> list[str]:
    secrets_file = 'secrets.enc' if not args.ci else 'secrets.ci.yml'
    return [secrets_file, 'inventory.yml', 'installed_versions.yml']


def get_hosts(args: argparse.Namespace) -> list[str]:
    return ['hosts' if not args.ci else 'hosts-ci']


def get_environment(args: argparse.Namespace) -> dict[str, str]:
    environment = {
        'ANSIBLE_CONFIG': 'ansible.cfg',
    }
    if not args.ci:
        environment['ANSIBLE_VAULT_PASSWORD_FILE'] = '.vault_pass'  # nosec

    return environment


def change_working_directory() -> None:
    working_dir = os.getcwd()
    os.chdir(working_dir + '/ansible')


def build_all(args: argparse.Namespace) -> None:
    extras = get_secrets(args)
    environment = get_environment(args)
    inventories = get_hosts(args)
    command = ['ansible-playbook']

    for extra in extras:
        command.extend(['-e', f'@{extra}'])

    for inventory in inventories:
        command.extend(['-i', inventory])

    if args.vvv:
        command.append('-vvv')

    if args.tags:
        command.extend(['--tags', args.tags])

    if args.limit:
        command.extend(['--limit', args.limit])

    command.append('provision.yml')

    change_working_directory()
    process.run_checked(command, env=environment)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Provision ansible.')
    parser.add_argument('-vvv', action='store_true', help='whether to print verbose output')
    parser.add_argument('--ci', action='store_true', help='whether to debug or not')
    parser.add_argument('--tags', type=str, help='which tags/roles to run')
    parser.add_argument('--limit', type=str, help='limit hosts to run on')
    args_parsed = parser.parse_args()

    build_all(args_parsed)
