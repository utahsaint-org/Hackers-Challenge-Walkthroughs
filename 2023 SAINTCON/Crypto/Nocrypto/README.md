# Nocrypto

I was using this encoding software, but it seems it is broken. I know it switched all instances of a symbol for another, but I don't know which one. If you can decode the text, you will find a flag.

> JRXXE0LNEBEXA43VNUQGS40AONUW24DMPEQGI5LNNV4SA5DFPB2CA33GEB2GQ0JAOB0GS3TUNFXGOIDBN0SCA5D0OBSXG0LUORUW400ANFXGI5LTOR0HSLRAJRXXE0LNEBEXA43VNUQGQYLTEBRGK0LOEB2GQ0JANFXGI5LTOR0HSJ3TEB0XIYLOMRQXE0BAMR2W23L0EB2GK6DUEBSXM0LSEB0WS3TDMUQHI2DFEAYTKMBQOMWCA53IMVXCAYLOEB2W423ON53W4IDQOJUW45DFOIQHI33PNMQGCIDHMFWGY0L0EBXWMIDUPFYGKIDBN0SCA43DOJQW2YTMMVSCA2LUEB2G6IDNMFVWKIDBEB2HS4DFEB0XA0LDNFWWK3RAMJXW620OEBTGYYLHHV5WMYLVNR2HSYTBONSTGMT5FYQES5BANBQXGIDTOV0HM2LWMVSCA3TPOQQG63TMPEQGM2LWMUQGG0LOOR2XE2LFOMWCAYTVOQQGC3DTN4QHI2DFEBWGKYLQEBUW45DPEBSWY0LDOR0G63TJMMQHI6LQMV0WK5DUNFXGOLBAOJSW2YLJN0UW400AMV0XG0LOORUWC3DMPEQHK3TDNBQW403FMQXCASLUEB3WC40AOBXXA5LMMF0GS43FMQQGS3RAORUGKIBRHE3DA40AO5UXI2BAORUGKIDSMVWGKYLTMUQG60RAJRSXI4TBONSXIIDTNBSWK5DTEBRW63TUMFUW42LOM4QEY33SMVWSASLQON2W2IDQMF0XGYLHMV0SYIDBN0SCA3LPOJSSA4TFMNSW45DMPEQHO2LUNAQGI0LTNN2G64BAOB2WE3DJONUGS3THEB0W60TUO5QXE0JANRUWW0JAIFWGI5LTEBIGC03FJVQWW0LSEBUW4Y3MOVSGS3THEB3GK4TTNFXW440AN5TCATDPOJSW2ICJOB0XK3I=

## Solution

At first glance this looks like it could be Base64 encoding. However, the Base64 alphabet consists of lower and upper case letters. The encoded message we were given is all uppercase which is the first big clue. What encoding looks like Base64 but only consists of upper-case alpha and digits? Well, [Base32](https://en.wikipedia.org/wiki/Base32).

Now that we've deduced this encoding is more than likely B32.. We need to figure out what symbol was replaced and with which other character so we can decode successfully and capture the flag. To do so, we can look at the unique occurrences of each character in the message and see if there are any characters missing.


```python
>>> encoded = "JRXXE0LNEBEXA43VNUQGS40AONUW24DMPEQGI5LNNV4SA5DFPB2CA33GEB2GQ0JAOB0GS3TUNFXGOIDBN0SCA5D0OBSXG0LUORUW400ANFXGI5LTOR0HSLRAJRXXE0LNEBEXA43VNUQGQYLTEBRGK0LOEB2GQ0JANFXGI5LTOR0HSJ3TEB0XIYLOMRQXE0BAMR2W23L0EB2GK6DUEBSXM0LSEB0WS3TDMUQHI2DFEAYTKMBQOMWCA53IMVXCAYLOEB2W423ON53W4IDQOJUW45DFOIQHI33PNMQGCIDHMFWGY0L0EBXWMIDUPFYGKIDBN0SCA43DOJQW2YTMMVSCA2LUEB2G6IDNMFVWKIDBEB2HS4DFEB0XA0LDNFWWK3RAMJXW620OEBTGYYLHHV5WMYLVNR2HSYTBONSTGMT5FYQES5BANBQXGIDTOV0HM2LWMVSCA3TPOQQG63TMPEQGM2LWMUQGG0LOOR2XE2LFOMWCAYTVOQQGC3DTN4QHI2DFEBWGKYLQEBUW45DPEBSWY0LDOR0G63TJMMQHI6LQMV0WK5DUNFXGOLBAOJSW2YLJN0UW400AMV0XG0LOORUWC3DMPEQHK3TDNBQW403FMQXCASLUEB3WC40AOBXXA5LMMF0GS43FMQQGS3RAORUGKIBRHE3DA40AO5UXI2BAORUGKIDSMVWGKYLTMUQG60RAJRSXI4TBONSXIIDTNBSWK5DTEBRW63TUMFUW42LOM4QEY33SMVWSASLQON2W2IDQMF0XGYLHMV0SYIDBN0SCA3LPOJSSA4TFMNSW45DMPEQHO2LUNAQGI0LTNN2G64BAOB2WE3DJONUGS3THEB0W60TUO5QXE0JANRUWW0JAIFWGI5LTEBIGC03FJVQWW0LSEBUW4Y3MOVSGS3THEB3GK4TTNFXW440AN5TCATDPOJSW2ICJOB0XK3I="
>>> sorted(set([c for c in encoded]))
['0', '2', '3', '4', '5', '6', '=', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y']
```

We can see that there are no occurrences of 7 and Z. Base 32 alphabet doesn't define 1, 8, or 9 so it's fine that those are missing. With this information, we can write a small script to iterate through the encoded message replacing occurrences of other characters with 7 and Z. The script will then attempt to decode the modified copy of the encoded string and output the result if it was able to do so successfully.

```python
import base64
import copy
import string

encoded = "JRXXE0LNEBEXA43VNUQGS40AONUW24DMPEQGI5LNNV4SA5DFPB2CA33GEB2GQ0JAOB0GS3TUNFXGOIDBN0SCA5D0OBSXG0LUORUW400ANFXGI5LTOR0HSLRAJRXXE0LNEBEXA43VNUQGQYLTEBRGK0LOEB2GQ0JANFXGI5LTOR0HSJ3TEB0XIYLOMRQXE0BAMR2W23L0EB2GK6DUEBSXM0LSEB0WS3TDMUQHI2DFEAYTKMBQOMWCA53IMVXCAYLOEB2W423ON53W4IDQOJUW45DFOIQHI33PNMQGCIDHMFWGY0L0EBXWMIDUPFYGKIDBN0SCA43DOJQW2YTMMVSCA2LUEB2G6IDNMFVWKIDBEB2HS4DFEB0XA0LDNFWWK3RAMJXW620OEBTGYYLHHV5WMYLVNR2HSYTBONSTGMT5FYQES5BANBQXGIDTOV0HM2LWMVSCA3TPOQQG63TMPEQGM2LWMUQGG0LOOR2XE2LFOMWCAYTVOQQGC3DTN4QHI2DFEBWGKYLQEBUW45DPEBSWY0LDOR0G63TJMMQHI6LQMV0WK5DUNFXGOLBAOJSW2YLJN0UW400AMV0XG0LOORUWC3DMPEQHK3TDNBQW403FMQXCASLUEB3WC40AOBXXA5LMMF0GS43FMQQGS3RAORUGKIBRHE3DA40AO5UXI2BAORUGKIDSMVWGKYLTMUQG60RAJRSXI4TBONSXIIDTNBSWK5DTEBRW63TUMFUW42LOM4QEY33SMVWSASLQON2W2IDQMF0XGYLHMV0SYIDBN0SCA3LPOJSSA4TFMNSW45DMPEQHO2LUNAQGI0LTNN2G64BAOB2WE3DJONUGS3THEB0W60TUO5QXE0JANRUWW0JAIFWGI5LTEBIGC03FJVQWW0LSEBUW4Y3MOVSGS3THEB3GK4TTNFXW440AN5TCATDPOJSW2ICJOB0XK3I="
b32_chars = [c for c in ("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=")]
uniq_chars = sorted(set([c for c in encoded]))
missing_chars = [c for c in b32_chars if c not in uniq_chars]

encoded_copy = copy.copy(encoded)
for uniq in uniq_chars:
    for missing in missing_chars:
        encoded_copy = encoded_copy.replace(uniq, missing)
        try:
            decoded = base64.b32decode(encoded_copy)
            print(f"\nswapped {uniq} with {missing}: \n{decoded}")
        except Exception as e:
            pass
    encoded_copy = copy.copy(encoded)
```

The script successfully decodes and outputs the following message after replacing occurrences of 0 with Z or 7. Replacing either results in the same decoded message.

```
> python3 solve.py

swapped 0 with Z:
b"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. flag={faultybase32}. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"

swapped 0 with 7:
b"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. flag={faultybase32}. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
```