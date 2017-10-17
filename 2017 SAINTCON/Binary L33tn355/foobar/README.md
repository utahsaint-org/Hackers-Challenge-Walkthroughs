# foobar #

## DESCRIPTION ##

Goal: Download the file and execute it.

Given the file, finding this key should be pretty simple. Just read what it says.
No strings attached, Linux does not rule the world.

## WALKTHROUGH ##

(by voldemortensen)

To solve this one, I ran strings on the binary and saw this was meant for a FreeBSD system. I spun up a FreeBSD box on Digital Ocean, ran the binary, and there was the flag.
