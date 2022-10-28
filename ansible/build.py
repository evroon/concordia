#!/usr/bin/env python3
import argparse
import os
from utils import process


def get_secrets(args: argparse.Namespace) -> None:
    secrets_file = 'secrets.enc' if not args.ci else 'secrets.ci.yml'
    return [secrets_file, 'inventory.yml', 'installed_versions.yml']


def get_environment(args: argparse.Namespace) -> None:
    environment = {
        'ANSIBLE_CONFIG': 'ansible.cfg',
    }
    if not args.ci:
        environment['ANSIBLE_VAULT_PASSWORD_FILE'] = '.vault_pass'

    return environment


def get_environment(args: argparse.Namespace) -> None:
    environment = {
        'ANSIBLE_CONFIG': 'ansible.cfg',
    }
    if not args.ci:
        environment['ANSIBLE_VAULT_PASSWORD_FILE'] = '.vault_pass'
        environment['PATH'] = os.environ['PATH'] + ':/usr/local/bin:/usr/bin'

    return environment


def build_all(args: argparse.Namespace) -> None:
    extras = get_secrets(args)
    environment = get_environment(args)
    inventories = ['hosts']
    command = ['ansible-playbook']

    for extra in extras:
        command.extend(['-e', f'@{extra}'])

    for inventory in inventories:
        command.extend(['-i', inventory])

    if args.vvv:
        command.append('-vvv')

    command.append('provision.yml')
    process.run_checked(command, env=environment)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Provision this machine.')
    parser.add_argument('--ci', action='store_true', help='whether to debug or not')
    parser.add_argument('-vvv', action='store_true', help='whether to print verbose output')
    args = parser.parse_args()

    build_all(args)
