#!/usr/bin/env python
import os

for fn in os.listdir("."):
    if "%20" in fn:
        os.rename(fn, fn.replace("%20", "-"))
