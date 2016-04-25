#!/usr/bin/env python3

#
# Normalise Romanian s-comma and t-comma
#
# author: Barry Haddow

import io
import sys
istream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')

for line in istream:
  line = line.replace("\u015e", "\u0218").replace("\u015f", "\u0219")
  line = line.replace("\u0162", "\u021a").replace("\u0163", "\u021b")
  print(line, end="")
