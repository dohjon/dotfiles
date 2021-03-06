#!/bin/bash

set -e

if [[ $(uname) == "Darwin" ]]; then

    # https://brew.sh/
    if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
        echo "Installing: homebrew ..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # https://formulae.brew.sh/formula/ansible
    if ! command -v ansible &>/dev/null; then
        echo "Installing: ansible (via brew) ..."
        brew install ansible
    fi
fi

echo "Running: playbook.yml ..."
ansible-playbook playbook.yml
