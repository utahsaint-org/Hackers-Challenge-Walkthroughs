# WS01 - User

## Challenge Description

This Category of Challenge is presented by The Keep Community at SAINTCON.

Have you ever wanted to come to a conference, hack a machine, and walk away
feeling like you own the world? Yeah, you can do that here.

If you get stuck or have any questions, don't hesitate to visit The Keep
Community for help or guidance!

========================================

Please Visit the HACKERS CHALLENGE BOOTH to spinup an environment for you!

This environment will be good for 3 hours.

(due to monetary costs, we won't keep it running longer, but can spin you up a
new environement when you need it)

========================================

Welcome to the Keep!

You have been tasked with running a pentest on this client's network.

They have placed a file flag.txt on the desktop of all the important users in
the network. This will allow them to see how far you have gone.

## Solution

First, we had to do some scanning to see what we had running. I scanned each
host and got the following:

```bash
nmap -Pn -A  WS01

Starting Nmap 7.60 ( https://nmap.org ) at 2023-10-26 05:33 UTC
Nmap scan report for URL
Host is up (0.043s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE       VERSION
445/tcp  open  microsoft-ds  Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=ws1.hc.local
| Not valid before: 2023-08-26T00:30:50
|_Not valid after:  2024-02-25T00:30:50
|_ssl-date: 2023-10-26T05:33:24+00:00; 0s from scanner time.
Service Info: OSs: Windows Server 2008 R2 - 2012, Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2023-10-26 05:33:25
|_  start_date: 2023-10-26 05:18:24

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 56.82 seconds
```

```bash
nmap -A -Pn WS02

Starting Nmap 7.60 ( https://nmap.org ) at 2023-10-26 06:03 UTC
Nmap scan report for URL
Host is up (0.039s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE       VERSION
445/tcp  open  microsoft-ds  Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=ws2.hc.local
| Not valid before: 2023-08-26T00:28:15
|_Not valid after:  2024-02-25T00:28:15
|_ssl-date: 2023-10-26T06:03:37+00:00; 0s from scanner time.
Service Info: OSs: Windows Server 2008 R2 - 2012, Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode:
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2023-10-26 06:03:40
|_  start_date: 2023-10-26 05:18:26

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 56.78 seconds
```


```bash
nmap -A -Pn DC

Starting Nmap 7.60 ( https://nmap.org ) at 2023-10-26 06:14 UTC
Nmap scan report for URL
Host is up (0.041s latency).
Not shown: 988 filtered ports
PORT     STATE SERVICE       VERSION
53/tcp   open  domain        Microsoft DNS
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2023-10-26 06:14:45Z)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: hc.local, Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds  Windows Server 2016 Datacenter 14393 microsoft-ds (workgroup: HC)
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3268/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: hc.local, Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=dc.hc.local
| Not valid before: 2023-08-25T01:42:01
|_Not valid after:  2024-02-24T01:42:01
|_ssl-date: 2023-10-26T06:14:50+00:00; 0s from scanner time.
Service Info: Host: DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-os-discovery:
|   OS: Windows Server 2016 Datacenter 14393 (Windows Server 2016 Datacenter 6.3)
|   Computer name: dc
|   NetBIOS computer name: DC\x00
|   Domain name: hc.local
|   Forest name: hc.local
|   FQDN: dc.hc.local
|_  System time: 2023-10-26T06:14:54+00:00
| smb-security-mode:
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: required
| smb2-security-mode:
|   2.02:
|_    Message signing enabled and required
| smb2-time:
|   date: 2023-10-26 06:14:51
|_  start_date: 2023-10-26 05:18:44

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 137.22 seconds
```

Oh interesting! DC has some LDAP available. Since I know absolutely nothing
about the users available, it would be worth the time to see if we can gather
any information about these systems:

```bash
ldapsearch -H ldap://localhost:389/ -x -b 'CN=Users,DC=hc,DC=local' "(objectClass=*)" "*" +
```

We try `CN=Users,DC=hc,DC=local` because that is the domain name that `nmap`
reported. We also try the `CN=Users` since that is common setup. Setting up LDAP
on your own will help you understand the typical layout.

While looking through the output, you'll see the following:

```
# Darkon, Users, hc.local
dn: CN=Darkon,CN=Users,DC=hc,DC=local
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: user
cn: Darkon
givenName: Darkon
distinguishedName: CN=Darkon,CN=Users,DC=hc,DC=local
instanceType: 4
whenCreated: 20230826022024.0Z
whenChanged: 20231005000227.0Z
displayName: Darkon
uSNCreated: 16433
info: Temp Pass -- goCougs123
memberOf: CN=Remote Desktop Users,CN=Builtin,DC=hc,DC=local
uSNChanged: 36894
name: Darkon
```

Ah! Temp password! I like that! We can use that to sign into the machine via RDP
and find the flag on the desktop!