#!/bin/bash

# yes, I know this is horrible style

git submodule update --init --recursive
cd keys
git pull origin master
sudo cp ../*.conf /etc/openvpn/
sudo cp *.key /etc/openvpn/
