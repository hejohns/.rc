#!/bin/bash

# yes, I know this is horrible style

git submodule update --init --recursive
cd keys
git pull
cp ../*.conf /etc/openvpn/
cp *.key /etc/openvpn/
