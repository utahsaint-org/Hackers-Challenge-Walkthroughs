# OPVault

## Description

The password to this vault is a number below 1000000.

## File

![crackme.opvault2.zip](crackme.opvault2.zip)

## Solution

The file `crackme.opvault2.zip` is a zip archive containing a password vault in 1Password OPVault format. More info can be found here: https://support.1password.com/opvault-design/

I stumbled upon a script to generate hashcat input from the OPVault `profile.js`. The format is `hash:salt:iterations:data`. The salt and interations are easy to find but the hash and data must be parsed from the _masterKey_. The hash resides in the last 32 bytes of _masterKey_, and the remaining bytes are data. 


https://github.com/Pwn-Collective/CTF-writeups/blob/master/NeverLan-CTF-2018-writeup/Passwords/The-Password-Manager/op2hashcat.py

I modified the script to work with this challenge: 

```
import json
import binascii
import base64

if __name__ == "__main__":

        #import json
        with open('crackme.opvault/default/profile.js') as f:
                profile = json.loads(f.read()[12:-1])

        #get data for hashcat input
        out = list()
        #hash - last 32 bytes of masterKey - decode from base64 and save as hex
        out.append(binascii.hexlify(base64.decodestring(profile['masterKey'])[-32::]))
        #salt - decode from base64 and save as hex
        out.append(binascii.hexlify(base64.decodestring(profile['salt'])))
        #iterations
        out.append(str(profile['iterations']))
        #data - rest of the masterKey - decode from base64 and save as hex
        out.append(binascii.hexlify(base64.decodestring(profile['masterKey'])[0:-32]))

        #create output
        out_str = ':'.join(out)

        with open('in.txt','w+') as f:
                f.write(out_str)

        print out_str
```

Running the script `python op2hashcat.py` produces the following: 

`e1f28e1655b9b9e0a5b10863ab15a7a0019de632da8a739329cc4d4ea893a56c:582972927cf68b9f87ea2c11ac224564:100000:6f7064617461303100010000000000007a5f1049a12c817457edf30c651c5c149fa23da21d73e0df3109e6f91695e99ae6e26247e19ab278fbd758439897c7f7bddcc4f7bc39dbe949f70ce2fef01c8f24393a05a21a25ed042072e60f559094b23ba82be1b36d2865c5d8127d1ff1bb0f6efc5c583169085da33bd50c9d8f75f3c0c0f3bdb10f7565b9bd1dcc582ac5b2346bb325b43d9cfebc82cfca5a424001f10eeb0edd98658ccbcbe079d33fbe341e1e1090e3ee94e6ff689eb2ca4e2aad325383192e5e6e8a8aee92be9b1100ce3fed7aa217517d2f3991547072d86209c3eb36fce6f83be60c571c25b516cb85015311a4d6647d37fbb5af377f3ee8783d51990c81035be06325d9dd61b761d5931120ad76c82f951668f48104efef0cef2b52ae5ff6980d4b374ca419e27e`

I know the password is a number < 1000000 so I just need to brute force up to 6 digits. I started high, using the mask attack with 6 digits. 

`hashcat -m 8200 -a 3 in.txt ?d?d?d?d?d?d`

`-m 8200` tells hashcat to use the `1Password, cloudkeychain` mode, `-a 3` tells it to use the mask attack, `in.txt` is the file containing our hash, and `?d?d?d?d?d?d` tells it our password is 6 digits long. We could attempt 1-6 digits using the `--increment` flag, but I wanted to try a shorter attack first. Lucily, in this case, the password is 6 digits long! This only took 7 minutes on my workstation. :smile: I reattempted the crack with the `--increment` flag, and it only took 8 minutes with my GPU. 

```
hashcat (v3.5.0) starting...

* Device #1: WARNING! Kernel exec timeout is not disabled.
             This may cause "CL_OUT_OF_RESOURCES" or related errors.
             To disable the timeout, see: https://hashcat.net/q/timeoutpatch
OpenCL Platform #1: NVIDIA Corporation
======================================
* Device #1: GeForce GTX 1060 6GB, 1519/6077 MB allocatable, 10MCU

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates

Applicable optimizers:
* Zero-Byte
* Single-Hash
* Single-Salt
* Brute-Force

Watchdog: Temperature abort trigger set to 90c
Watchdog: Temperature retain trigger disabled.

Cracking performance lower than expected? Append -w 3 to the commandline.

Approaching final keyspace - workload adjusted.           

e1f28e1655b9b9e0a5b10863ab15a7a0019de632da8a739329cc4d4ea893a56c:582972927cf68b9f87ea2c11ac224564:100000:6f7064617461303100010000000000007a5f1049a12c817457edf30c651c5c149fa23da21d73e0df3109e6f91695e99ae6e26247e19ab278fbd758439897c7f7bddcc4f7bc39dbe949f70ce2fef01c8f24393a05a21a25ed042072e60f559094b23ba82be1b36d2865c5d8127d1ff1bb0f6efc5c583169085da33bd50c9d8f75f3c0c0f3bdb10f7565b9bd1dcc582ac5b2346bb325b43d9cfebc82cfca5a424001f10eeb0edd98658ccbcbe079d33fbe341e1e1090e3ee94e6ff689eb2ca4e2aad325383192e5e6e8a8aee92be9b1100ce3fed7aa217517d2f3991547072d86209c3eb36fce6f83be60c571c25b516cb85015311a4d6647d37fbb5af377f3ee8783d51990c81035be06325d9dd61b761d5931120ad76c82f951668f48104efef0cef2b52ae5ff6980d4b374ca419e27e:XXXXXX
                                                          
Session..........: hashcat
Status...........: Cracked
Hash.Type........: 1Password, cloudkeychain
Hash.Target......: e1f28e1655b9b9e0a5b10863ab15a7a0019de632da8a739329c...19e27e
Time.Started.....: Thu Oct 24 22:07:09 2019 (7 mins, 48 secs)
Time.Estimated...: Thu Oct 24 22:14:57 2019 (0 secs)
Guess.Mask.......: ?d?d?d?d?d?d [6]
Guess.Queue......: 1/1 (100.00%)
Speed.Dev.#1.....:     1968 H/s (5.03ms)
Recovered........: 1/1 (100.00%) Digests, 1/1 (100.00%) Salts
Progress.........: 912640/1000000 (91.26%)
Rejected.........: 0/912640 (0.00%)
Restore.Point....: 56320/100000 (56.32%)
Candidates.#1....: ###### -> ######
HWMon.Dev.#1.....: Temp: 75c Fan: 54% Util: 97% Core:1822MHz Mem:3802MHz Bus:16

Started: Thu Oct 24 22:07:06 2019
Stopped: Thu Oct 24 22:14:57 2019
```

I cracked the password (XXXXXX)!

After the password was cracked, I attempted to open the vault. I failed to reveal the secret using the opvault-cli (https://github.com/OblivionCloudControl/opvault), but I did manage to get a file listing. 

```
$ opvault-cli ./crackme.opvault -l
1Password master password: XXXXXX
flag
```

My second attempt was a success. I used this code: https://hg.icculus.org/icculus/1pass/file/1390348facc7/opvault.c

```
$ ./opvault ./crackme.opvault XXXXXX
profile : {
  uuid : "3F082EE1F9904E93BCEA1A4E82A8BCBD", 
  updatedAt : 1571733551.000000, 
  createdAt : 1571733551.000000, 
  tx : 1571733551.000000, 
  passwordHint : "", 
  lastUpdatedBy : "MSI-GS75", 
  profileName : "crackme", 
  iterations : 100000.000000, 
  salt : "WClyknz2i5+H6iwRrCJFZA==", 
  overviewKey : "b3BkYXRhMDFAAAAAAAAAANEWggnhLpRNKgdG6YvRe3ijEHR0LzRIqv67QK16F6AT+K1F6B4PssUViYIviQUKpkt8EOajtDaYsIkP999KgNSnvXIWGVkjgF5iXsoOrvL6KIQCnHGmpcbA1R7tuPVpdN4VdpDiTYlu0D4S3Rg5JVLfGfJDe9PLnJNJRdOwJkva", 
  masterKey : "b3BkYXRhMDEAAQAAAAAAAHpfEEmhLIF0V+3zDGUcXBSfoj2iHXPg3zEJ5vkWlema5uJiR+Gasnj711hDmJfH973cxPe8OdvpSfcM4v7wHI8kOToFohol7QQgcuYPVZCUsjuoK+GzbShlxdgSfR/xuw9u/FxYMWkIXaM71Qydj3XzwMDzvbEPdWW5vR3MWCrFsjRrsyW0PZz+vILPylpCQAHxDusO3ZhljMvL4HnTP740Hh4QkOPulOb/aJ6yyk4qrTJTgxkuXm6Kiu6SvpsRAM4/7XqiF1F9LzmRVHBy2GIJw+s2/Ob4O+YMVxwltRbLhQFTEaTWZH03+7WvN38+6Hg9UZkMgQNb4GMl2d1ht2HVkxEgrXbIL5UWaPSBBO/vDO8rUq5f9pgNSzdMpBnifuHyjhZVubngpbEIY6sVp6ABneYy2opzkynMTU6ok6Vs"
}

(no folders.)

Band band_0.js...

uuid 0569204D98E543779ED56302B8B00120:
 category: Password
 created: Tue Oct 22 02:39:49 2019
 updated: Tue Oct 22 02:39:49 2019
 last tx: Tue Oct 22 02:39:49 2019
 trashed: false
 folder uuid: [none]
 fave: [no]
 hmac: +TX6ge9d1a/HWpomZQZcjQl7aagwvJWWdxD/oe3sxlM= [valid]
 o: {"title":"flag","ainfo":"10/22/2019","url":"","ps":28}
 d: {"password":"XXXXXX"}
```

Turns out the encrypted password (flag) is the same value as the vault's passphrase. :grin: I submitted the flag XXXXXX and success!

--\
m4rr0w

