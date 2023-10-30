from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import random

msg = b'\xf1\xb3\xf0"\x8e\xe8\xd3\xb3R\x89\xdb\x99\x97\xbe\xfb\x970\xe3\x16\xe2\xe9\xae\xae\xaf\xea{J0\xd4\xee\x88|\xeb\xb0\xc3|\xcf&\x87\xfbT\xf0mG\xe3\xa5\x08\x1cc\xa6\xba\xae\xfeL\x08>\xa5\xea\x84\xe2\x97\x06L\xc7\xba^B\xf6X\x10\xc7\xd0\xda"\xc5\x00\xd3\xcbW\x87'

random.seed(12345)
x = random.randbytes(48)

print('bytes: {}'.format(x))

# BINARY_SUBSCR = arr[indx]
i3 = x[39]
i47 = x[29]
i45 = x[17]
i21 = x[42]
i23 = x[3]
i43 = x[12]
i44 = x[26]
i35 = x[23]
i30 = x[37]
i24 = x[2]
i41 = x[7]
i42 = x[47]
i40 = x[43]
i10 = x[1]
i1 = x[24]
i15 = x[22]
i6 = x[5]
i16 = x[6]
i38 = x[19]
i0 = x[32]
i29 = x[33]
i25 = x[38]
i20 = x[18]
i31 = x[44]
i28 = x[46]
i13 = x[45]
i11 = x[34]
i46 = x[31]
i37 = x[9]
i39 = x[10]
i33 = x[16]
i36 = x[20]
i8 = x[8]
i5 = x[27]
i18 = x[35]
i19 = x[36]
i27 = x[40]
i12 = x[13]
i17 = x[4]
i4 = x[15]
i26 = x[0]
i32 = x[30]
i22 = x[25]
i2 = x[21]
i7 = x[28]
i14 = x[14]
i9 = x[41]
i34 = x[11]

i30 = i22 * i0
i25 = i7 - i1
i6 = i44 * i2
i5 = i30 * i3
i1 = i18 + i4
i34 = i23 - i5
i41 = i4 ^ i6
i23 = i20 ^ i7
i22 = i46 * i8
i8 = i3 ^ i9
i38 = i43 - i10
i46 = i33 * i11
i12 = i16 * i12
i45 = i1 + i13
i10 = i10 * i14
i14 = i5 * i15
i29 = i35 - i16
i40 = i38 ^ i17
i0 = i45 ^ i18
i33 = i12 + i19
i24 = i17 ^ i20
i44 = i47 ^ i21
i16 = i40 * i22
i39 = i15 - i23
i21 = i42 ^ i24
i37 = i36 + i25
i3 = i27 ^ i26
i32 = i25 + i27
i20 = i31 * i28
i42 = i2 + i29
i9 = i21 * i30
i4 = i11 + i31
i27 = i9 + i32
i43 = i13 * i33
i7 = i28 * i34
i11 = i6 ^ i35
i17 = i34 + i36
i35 = i41 + i37
i19 = i32 ^ i38
i31 = i14 - i39
i2 = i37 - i40
i47 = i39 - i41
i15 = i29 * i42
i13 = i24 + i43
i28 = i0 * i44
i18 = i8 - i45
i26 = i26 * i46
i36 = i19 + i47

x = list()
x.append(i26)
x.append(i4)
x.append(i35)
x.append(i36)
x.append(i17)
x.append(i43)
x.append(i32)
x.append(i6)
x.append(i42)
x.append(i1)
x.append(i33)
x.append(i44)
x.append(i16)
x.append(i45)
x.append(i14)
x.append(i27)
x.append(i7)
x.append(i24)
x.append(i46)
x.append(i39)
x.append(i15)
x.append(i34)
x.append(i28)
x.append(i31)
x.append(i40)
x.append(i10)
x.append(i19)
x.append(i47)
x.append(i38)
x.append(i12)
x.append(i23)
x.append(i25)
x.append(i3)
x.append(i37)
x.append(i5)
x.append(i41)
x.append(i2)
x.append(i22)
x.append(i11)
x.append(i29)
x.append(i13)
x.append(i0)
x.append(i21)
x.append(i8)
x.append(i9)
x.append(i18)
x.append(i20)
x.append(i30)


x = [i % 256 for i in x]
x = bytearray(x)
d = Cipher(algorithms.AES(x[:32]), modes.CBC(x[32:48])).decryptor()
print(d.update(msg) + d.finalize())

