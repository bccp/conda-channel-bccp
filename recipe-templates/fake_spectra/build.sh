#!/bin/bash
cp setup.py setup.py.bak
sed -e "s;'-ffast-math',;;" setup.py.bak > setup.py

python setup.py install
