# BL 100  

The challenge provided us with 1785491543b4e22f655b247d064401ae.bin and no other hint aside from the challenge being named Binary Foo and knowing that l34n was the author.  

Upon receiving an unknown binary running file and strings against it are a good first step. Using either of these commands would find the flag.  File reveals that the file is actually a zip file and strings shows the flag FileForTheWin  

```
[viking@x1 100]$ file 1785491543b4e22f655b247d064401ae.bin 
1785491543b4e22f655b247d064401ae.bin: Zip archive data, at least v1.0 to extract
[viking@x1 100]$ strings 1785491543b4e22f655b247d064401ae.bin 
97f0b371d1de4578a6e7ccf6f079ded0.txtUT	
FileForTheWin
97f0b371d1de4578a6e7ccf6f079ded0.txtUT
[viking@x1 100]$ unzip 1785491543b4e22f655b247d064401ae.bin 
Archive:  1785491543b4e22f655b247d064401ae.bin
 extracting: 97f0b371d1de4578a6e7ccf6f079ded0.txt  
[viking@x1 100]$ cat 97f0b371d1de4578a6e7ccf6f079ded0.txt 
FileForTheWin
```
