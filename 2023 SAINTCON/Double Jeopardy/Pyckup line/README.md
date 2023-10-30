# Pyckup line

I lost the source, but at least I have this. Can you help?

> Python 3.11.5 (tags/v3.11.5:cce6ba9, Aug 24 2023, 14:38:34) [MSC v.1936 64 bit (AMD64)] on win32


[challenge](./challenge)

## Solution

The first hint we're given in the challenge description indicates the challenge will have something to do with Python and could potentially have something to do with version 3.11.5 running on AMD64 architecture. After downloading and inspecting the contents of [challenge](./challenge), it's clear we aren't given a regular python script (.py) that can be executed with python.


```python
163           0 RESUME                   0

164           2 LOAD_CONST               1 (0)
...
```


Taking a closer look at the contents of the challenge file, it seems we're given Python [bytecode](https://en.wikipedia.org/wiki/Bytecode). A quick search for `Python LOAD_CONST` validates this hypothesis with a result linking to the Python standard library disassembler package `dis`.

> The dis module supports the analysis of CPython bytecode by disassembling it. The CPython bytecode which this module takes as an input is defined in the file Include/opcode.h and used by the compiler and the interpreter.

Okay, great. So it seems like we're on the right track. Let's look through the challenge file some more and try to make sense of what the byte code does.

