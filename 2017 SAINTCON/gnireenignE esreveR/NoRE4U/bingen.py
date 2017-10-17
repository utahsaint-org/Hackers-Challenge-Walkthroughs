import itertools
import os
import subprocess

offsets = [
 0x9ad,
 0x9b7,
 0x9c1,
 0x9d6,
 0x9e0,
 0x9ea,
 0x9f4,
 0x9fe,
 0xa08,
 0xa12,
 0xa1c,
 0xa26,
 0xa30,
 0xa3a,
 0xa44,
 0xa4e,
]

perms = [
 [0x21],
 [0xe2, 0xf6],
 [0x22, 0x32],
 [0xdf, 0xfb],
 [0xc5, 0xa1],
 [0x52],
 [0x1d, 0xf1],
 [0xfb, 0x44],
 [0x3a, 0x11],
 [0x73],
 [0x34, 0xb0],
 [0xb6, 0xa1],
 [0x2f, 0x3a],
 [0x57],
 [0x96, 0x63],
 [0x22, 0x1a],
]

logfile = open('log.txt','w')

with open('NoRE4U.patch.exe','rb') as f:
    data = bytearray(f.read())

for i,mapping in enumerate([zip(offsets, x) for x in itertools.product(*perms)]):
    # Do substitutions
    for k,v in mapping:
        data[k] = v

    # Write exe to disk
    fname = 'NoRE4U.patch.{}.exe'.format(i)
    with open(fname, 'wb') as f:
        f.write(data)
    print('Wrote {}'.format(fname))

    # execute and look for "Flag:"
    output = subprocess.check_output([fname])
    logfile.write(output)
    if 'Flag:' in output:
        print('EUREKA!! ' + output)
        break
    else:
        os.unlink(fname)
