# pipebashed

## Brief

```
Do this and get bashed with a pipe.

Install this app to get the flag.

http://install.garth.tech:8080/setup.bash
```

## Walkthrough

Never, ever, ever, pipe a curl into bash. Just don't. It's a great way to get your computer hacked.

But we're going to anyway!

Let's first inspect the payload:

```
>>  curl http://install.garth.tech:8080/setup.bash
sleep 3
echo
echo
echo "Hmmm.. Keep looking."
echo
echo
```

Ooooh, boy.  It looks like they're smart, and anticipated this. Perhaps we actually need to pipe this to bash?

**WARNING: DO THIS IN A VM**

In a VM, let's run this:

```
>>  curl http://install.garth.tech:8080/setup.bash | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 1267k    0 1267k    0     0   267k      0 --:--:--  0:00:04 --:--:--  267k

Must be run as root
```

Oh wow.  It gets even worse.

Alright, in a VM that you really, really don't care about:

```
root@kali:~# curl http://install.garth.tech:8080/setup.bash | bash

FLAG{HOPEFULLY_YOU_RAN_THIS_IN_A_VM}
```

**Caveat:** It seems like this isn't 100% reliable. You may have to run it multiple times to get the flag.  Keep trying!

