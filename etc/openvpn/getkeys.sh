#!/bin/bash

# yes, I know this is horrible style

cd keys
git pull
cp ../*.conf /etc/openvpn/
cp *.key /etc/openvpn/
