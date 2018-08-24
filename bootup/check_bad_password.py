#!/usr/bin/python3.5

import re
import crypt

line = ""
with open('/etc/shadow') as f:
    for l in f.readlines():

        if re.match('^pi:\$', l):
            line = l
            break

if 0 == len(line):
    print('good(not found pi)')
    exit(0)  # nothing to do.

hash = line.split(":")[1]

_, id, salt, _encrypted = hash.split("$")

encrypted_password = crypt.crypt("raspberry", salt="$%s$%s" % (id, salt))

# print(encrypted_password)
# print(hash)

if encrypted_password == hash:
    # found default password!
    print("bad")
else:
    # not found default password, good boy
    print("good")
