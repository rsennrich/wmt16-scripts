#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

for line in sys.stdin:
    sys.stdout.write(' '.join(reversed(line.split())) + '\n')
