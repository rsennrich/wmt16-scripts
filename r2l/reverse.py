#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author: Rico Sennrich
# Distributed under MIT license

import sys

for line in sys.stdin:
    sys.stdout.write(' '.join(reversed(line.split())) + '\n')
