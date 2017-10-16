Rolling | gnireenignE esreveR
=======
##### Puzzle Author: Professor Plum
###### Writeup Author: L4mbd4

Description:
------------
```
goal: Find and decode the key
```
Files:
------
Executable - [rolling.exe](rolling.exe)

Solving:
---------
After downloading the executable the first step is to classify what version of assembly is being used.
```
╭─lambda@WMD ~/Downloads  
╰─$ file rolling.exe 
rolling.exe: PE32 executable (console) Intel 80386 Mono/.Net assembly, for MS Windows
```
Notice it is **Mono/.Net assembly**

Now that we know that the executable is using .NET Assembly we need to find a decompiler for it.
A quick DuckDuckGo search will yield good options and I decided to go with [ILSpy](http://ilspy.net/), a Windows based open-source .NET assembly browser and decompiler. 

After spinning up my Windows VM and launching **ILSpy** I loaded in the *rolling.exe* file and it was automaticly decompiled into a very readable format:
```VB.NET
using System;
using System.Linq;

namespace rollingxor
{
	internal class Program
	{
		private static byte[] answer = new byte[]
		{
			97,
			220,
			72,
			79,
			44,
			136,
			244,
			147,
			147,
			63,
			90,
			103,
			3,
			228,
			2,
			111,
			243,
			182,
			81,
			72,
			115,
			63,
			250,
			60,
			146,
			231
		};

		private static bool checkFlag(string flag)
		{
			uint num = 12345u;
			byte[] array = new byte[flag.Length];
			for (int i = 0; i < flag.Length; i++)
			{
				array[i] = (byte)((uint)flag[i] ^ num);
				num *= (uint)array[i];
				num = (num >> 3 | num << 29);
			}
			return Program.answer.SequenceEqual(array);
		}

		private static void Main(string[] args)
		{
			if (args.Length < 1)
			{
				Console.WriteLine("Guess the flag and I'll see if you are right");
				Console.WriteLine("Usage: " + AppDomain.CurrentDomain.FriendlyName + " [flag]");
				return;
			}
			if (Program.checkFlag(args[0]))
			{
				Console.WriteLine("You got it! flag: " + args[0]);
				return;
			}
			Console.WriteLine("Nope, try again");
		}
	}
}
```

Analysis
--------
In order to understand some of this code you will need to be familiar with bitwise operators. Here is a good whitepaper on the Python Wiki: [BitwiseOperators](https://wiki.python.org/moin/BitwiseOperators)
Upon execution of this binary the following will happen:
1. Verify there is an argument.
2. Run the checkFlag function with the given flag as an argument.
    * **Program.checkFlag(args[0])**
3. Create an unsigned int 12345u, "num"
    * **uint num = 12345u;**
4. Create a byte array the length of the flag, "array"
    * **byte[] array = new byte[flag.Length];**
5. Itterate through each character of the given flag.
    * **for (int i = 0; i < flag.Length; i++)**
    * XOR the unsigned int of the *i*th character of the given flag and "num" then save it to the "array".
        * **array[i] = (byte)((uint)flag[i] ^ num);**
    * Modify "num" for the next iteration by multiplying it by the previously generated XOR.
        * **num \*= (uint)array[i];**
    * Modify "num" again for the next iteration by ORing the bitwise shift of "num" three to the right and 29 to the left.
        * **num = (num >> 3 | num << 29);**
    * Continue to the next iteration of the loop.
6. Upon completion of the loop check if the generated "array" is equal to the "answer" array.
    *  **return Program.answer.SequenceEqual(array);**

Reversal
--------
Reversing the encoded flag should be as simple as doing the above steps backwards.

I wrote a Python script to do this:
```Python
#!/bin/python
import ctypes

#Array pulled directly from decompiled source.
answer = [97,220,72,79,44,136,244,147,147,63,90,103,3,228,2,111,243,182,81,72,115,63,250,60,146,231]

num = [12345]
result = ''

for i in range(len(answer)):
    #Append normalized XORed value to result string
    result += chr( (answer[i] ^ num[i]) %256)

    #Step 1 of generating next "num" in sequence, multiply the given iteration of the "answer" and the current "num"
    nextNum = ctypes.c_uint( answer[i] * num[i] ).value
    #Step 2 of generating next "num" in sequence, OR the bitwise shift of "num" three to the right and 29 to the left.
    nextNum = ( nextNum >> 3 | nextNum << 29 )
    num.append(nextNum)

print (result)
```
*NOTE: The ctypes library was used to properly handle the generation of "num" prior to the bitwise shift in order to prevent the bitwise operations from being executed on a signed long, which would produce descrepencies as "num" becomes larger **Example Below**.*
Result:
```
╭─lambda@WMD ~/Development/SaintCon/Regular/reverse/rolling  
╰─$ python3 reverse.py 
XorEncodingIsNotEncryption
```
What if we didn't use ctypes?
-----------------------------
Code example:
```
#!/bin/python
import ctypes

#Array pulled directly from decompiled source.
answer = [97,220,72,79,44,136,244,147,147,63,90,103,3,228,2,111,243,182,81,72,115,63,250,60,146,231]

num = [12345]
result = ''

for i in range(len(answer)):
    #Append normalized XORed value to result string
    result += chr( (answer[i] ^ num[i]) %256)

    #Step 1 of generating next "num" in sequence, multiply the given iteration of the "answer" and the current "num"
    #nextNum = ctypes.c_uint( answer[i] * num[i] ).value
    nextNum = answer[i] * num[i]
    #Step 2 of generating next "num" in sequence, OR the bitwise shift of "num" three to the right and 29 to the left.
    nextNum = ( nextNum >> 3 | nextNum << 29 )
    num.append(nextNum)

print ('\nRESULT W/O USING ctypes: \n\n')
print ('FLAG: '+result)

for i in range(len(result)):
    print ( result[i]+'-----'+str(num[i]) )

print ('\nRESULT USING ctypes: \n\n')

num = [12345]
result = ''

for i in range(len(answer)):
    #Append normalized XORed value to result string
    result += chr( (answer[i] ^ num[i]) %256)

    #Step 1 of generating next "num" in sequence, multiply the given iteration of the "answer" and the current "num"
    nextNum = ctypes.c_uint( answer[i] * num[i] ).value
    #Step 2 of generating next "num" in sequence, OR the bitwise shift of "num" three to the right and 29 to the left.
    nextNum = ( nextNum >> 3 | nextNum << 29 )
    num.append(nextNum)

print ('FLAG: '+result)

for i in range(len(result)):
    print ( result[i]+'-----'+str(num[i]) )

```
Result:
```
╭─lambda@WMD ~/Development/SaintCon/Regular/reverse/rolling  
╰─$ python reverse.py

RESULT W/O USING ctypes: 


FLAG: XorEncodingIsί��D��(�v
X-----12345
o-----642884126787763
r-----75932073240951412852969274
E-----2935131941586267415156474024455129354
n-----124487170044527919623095864622190326947213357378
c-----2940675783105874943705969917398949345682203686258036575979
o-----214711807403813006101552401323681029983618072814641232073304551914907
d-----28126495825679272887102947261900624594570389839379408564449107616299744225736439
i-----2219743727398604261344471329505911881196815835474087259904417135343466922280652195021279738
n-----175182228422954930860130138978348462527906899109137382857532351948701686929705561819604057088493863505
g-----5925165293800624280775235421439327383477868122858091140409460542462089522279981119655775477071504848318641805885
I-----286294400614669720722768328265211915809096636496274813230121469639552687576797426142416835990060666311418481291124533454638
s-----15831423004058044060397717025037577583438533828068840338569180406618554749135751663342869928507374282673017770671954911785820923203696
�-----25498291519383758148131677492532205301655201796565610980494574798513472892035977305845729768911168443013014986631396866414795458359183888750122
�-----3121158353315502161726603339509531747722564040522243957165245104586248617301404622750228315515305450607692248173665914243674371606493392795906736898537389
�-----3351318263281823738657233916607829275024797824889868168160669865202051595085112401676059077858185189468391217805832225075619952789312642283305981152542953096044011
�-----199714007458001058195050441396337366312910896034257367939820313229589431611642516799730366789537820803460464624883591725643180872049480116453935867058216446399444668653483804
D-----26054615845483181067434131004072409797153310772724641941506862547206025114606818109831522020190686995579831964381065233919839398567925889191200990598578522668240675355310592061593737714
-----2545809698030401581901075845665408781192992532523972416510330018965108039503145985461772765096783247537269436233878684555585199534709889717912270418392448357731346505883864804539964874115299221057
-----110708465148857799942920306311647832637684623312771190729988374401317214172130880908083483150997255398245937291162462979718158112813421451985016719256004086714016291051391776032222408444380989253624230105682
�-----4279403135186045199984678114171200951559095310257772130290124184017097631900921910390554104332150081918056449916748658500842597835950333082950095342762901639336230972769535777076731706571494345661023478853109181539554
-----264211012361037087564311028747762545555996554135483660202946370682415903232508085817571029426533581211045983855408562542158678963978586236208782777725233326476505949930572984361387316561468442726408991391190840275365090840300080
�-----8936374051509228437558357927800339625967788994395057763180505827776559272436488181786381886389964437191334777203129110619970929137633686239464207624518632357963700282597433280444361899828921886571760756809696118175903952373481803375429690
(-----1199419822025280778208307906389818653659328991611154407278405049940749399487301765312257520864460908441532138865386870239162384254034811749235476754244618871257645652065482401714094014927053057982219438268670222210156697352965977321710983336886153492
�-----38636016830455242522883634101183036362599160743326824210146961922848253531222906969453836798391164991316607173068321551594095475586210942062140118510629365167181259709710786274791414385173504235741040539392677484604602368851374732855585021380802865886631718934
v-----3028412824967226141731785003327251754092483863412895442740609200263617892040657255364724795024210717759255393936917180318433306195330761489995283497941892765228482621342180122692826189930401756828437595022645952243345266793917995210801698938417396478157729215520989085073

RESULT USING ctypes: 


FLAG: XorEncodingIsNotEncryption
X-----12345
o-----642884126787763
r-----1170600803597995834
E-----1312035174052350218
n-----1427132295014134082
c-----931698575609302763
o-----2003817726854757787
d-----1164522415555426039
i-----1798433763491140090
n-----476187842097955409
g-----2020596973841324605
I-----1402668073243592494
s-----1341989608495232112
N-----2232628360095982506
o-----1372146999470250093
t-----343036749867562523
E-----1877331127326056118
n-----1395470300759307480
c-----618068686213993010
r-----1646259428415549498
y-----981276787572879882
p-----270795762856759119
t-----403134349816903822
i-----1645194118685845333
o-----809740825284888317
n-----942711963754246025

```
