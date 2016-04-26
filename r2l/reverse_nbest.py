#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author: Rico Sennrich
# Distributed under MIT license

import sys

for line in sys.stdin:
    linesplit = line.split(' ||| ')
    linesplit[1] = ' '.join(reversed(linesplit[1].split()))
    sys.stdout.write(' ||| '.join(linesplit))
