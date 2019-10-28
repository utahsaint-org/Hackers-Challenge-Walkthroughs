1. Use steghide and password 541N7C0N to extract jpeg with flag
2. steghide extract -sf [FILENAME]

This challenge is a classic. First, you download the image from dropbox. Like any challenge where you’re given a file, you do some basic investigation. Running the `file` command reveals that it is indeed a JPG file. Opening it in a text editor also reveals the JPG header. The next thing I noticed is how large the simple image was. There is no reason to have an image that large (I forget how big it was, but it was devastatingly huge.)

This can mean only one thing. Steganography. Luckily, there is a sweet tool in Kali Linux (you can install it elsewhere too) called “steghide”. It’s a command line utility that detects hidden files in images. Running `steghide extract –sf SAINTONCON2016.jpg` prompted for a password. Some guess work got me that password, which was “541N7C0N”.

PROTIP: Whenever any challenge asks for a password, its usually “saintcon” or some variation on that theme.

Steghide extracted an image file named “WhiteRabbit.jpg”. Opening this image showed us this:
https://cloudup.com/caZyLxNbkOG

Tada.
