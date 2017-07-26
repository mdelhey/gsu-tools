import os

for fn in os.listdir("."):
    if fn.detect("%20"):
        os.rename(fn, fn.replace("%20", "-"))
