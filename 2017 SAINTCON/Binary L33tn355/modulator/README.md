
# Description

The clue leads you to a website with the image below.

![m.gif](m.gif)

# Solution

The lights on the modem are blinking kinda strangely for a modem.
Maybe the lights are a message.  It turns out there are 75 frames
(individual images) in the animation shown by the Preview.app
screenshot below.

![frames.png](frames.png)

So, let's try treating each light as one bit in a byte: Green (ON) is 1
and White (OFF) is 0. Let the most significant bit be RD and least
significant bit by MR (we'll ignore PW).

Here's what we get when we decode the first 3 frames:

| bits     | hex | character |
| -------- | --- | --------- |
| 01011001 |  59 | Y         |
| 01101111 |  6f | o         |
| 01110101 |  75 | u         |

The program [modulator.go](modulator.go) is a
[go](https://golang.org/) program that samples one pixel of
each LED.  Note: I believe this may be my first go program.

# Result

`YourFlagIsInHereIPromiseHereItIs{...}`
