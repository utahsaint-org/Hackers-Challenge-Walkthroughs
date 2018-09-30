# Title

Here's something new..

# hint

https://re.voldemortensen.com/


# solution

I'm not a web programmer, so I groaned audibly when I saw this. Ugh. Web.

So let's fetch it...

```
curl -o index.html https://re.voldemortensen.com/
```

This html refers to a java script: index.js

```
curl -o index.js https://re.voldemortensen.com/index.js
```

This javascript does some funky stuff, but ultimately, it provides a runtime environment for running
a C++ program retargetted for [WebAssembly (WASM)](https://webassembly.org/). The associated WASM
file is: index.wasm.

```
curl -o index.wasm https://re.voldemortensen.com/index.wasm
```

Ok, I don't know anything about wasm except that, like Java, it's a virtualized environment. Like Java,
I bet there are decompilers for it. Sure, enough, I found:
[WABT: The WebAssembly Binary Toolkit](https://github.com/WebAssembly/wabt). I cloned it, built it, and
then I used their utility (wasm2c)[https://github.com/WebAssembly/wabt/blob/master/wasm2c/README.md]
to translate the wasm file to a almost recognizable C program: [first.c](first.c).

That C program is ~22000 lines long... ugh! But let's look at just "main". The l* variables are stack variables, and the g* variables are globals. To read and write "main memory", this WASM thing calls out to a
function called "i32_store(Z_envZ_memory, addr, value);

```c
static u32 _main(u32 p0, u32 p1) {
  u32 l0 = 0, l1 = 0, l2 = 0, l3 = 0, l4 = 0, l5 = 0, l6 = 0, l7 = 0, 
      l8 = 0, l9 = 0, l10 = 0, l11 = 0, l12 = 0, l13 = 0, l14 = 0, l15 = 0, 
      l16 = 0, l17 = 0, l18 = 0, l19 = 0, l20 = 0, l21 = 0, l22 = 0, l23 = 0, 
      l24 = 0, l25 = 0, l26 = 0, l27 = 0, l28 = 0, l29 = 0, l30 = 0, l31 = 0, 
      l32 = 0, l33 = 0, l34 = 0, l35 = 0, l36 = 0, l37 = 0, l38 = 0, l39 = 0, 
      l40 = 0, l41 = 0, l42 = 0, l43 = 0, l44 = 0, l45 = 0, l46 = 0, l47 = 0, 
      l48 = 0, l49 = 0, l50 = 0, l51 = 0, l52 = 0, l53 = 0, l54 = 0, l55 = 0, 
      l56 = 0, l57 = 0, l58 = 0, l59 = 0, l60 = 0, l61 = 0, l62 = 0, l63 = 0, 
      l64 = 0, l65 = 0, l66 = 0, l67 = 0, l68 = 0, l69 = 0, l70 = 0, l71 = 0, 
      l72 = 0, l73 = 0, l74 = 0, l75 = 0, l76 = 0, l77 = 0, l78 = 0, l79 = 0, 
      l80 = 0, l81 = 0, l82 = 0, l83 = 0, l84 = 0, l85 = 0, l86 = 0, l87 = 0, 
      l88 = 0, l89 = 0, l90 = 0, l91 = 0, l92 = 0, l93 = 0, l94 = 0, l95 = 0, 
      l96 = 0, l97 = 0, l98 = 0, l99 = 0, l100 = 0, l101 = 0, l102 = 0, l103 = 0, 
      l104 = 0, l105 = 0, l106 = 0, l107 = 0, l108 = 0, l109 = 0, l110 = 0, l111 = 0, 
      l112 = 0, l113 = 0, l114 = 0, l115 = 0, l116 = 0, l117 = 0, l118 = 0, l119 = 0, 
      l120 = 0, l121 = 0, l122 = 0, l123 = 0, l124 = 0, l125 = 0, l126 = 0, l127 = 0, 
      l128 = 0, l129 = 0, l130 = 0, l131 = 0, l132 = 0, l133 = 0, l134 = 0, l135 = 0, 
      l136 = 0, l137 = 0, l138 = 0, l139 = 0, l140 = 0, l141 = 0, l142 = 0, l143 = 0, 
      l144 = 0, l145 = 0, l146 = 0;
  FUNC_PROLOGUE;
  u32 i0, i1, i2;
  i0 = g10;
  l146 = i0;
  i0 = g10;
  i1 = 272u;
  i0 += i1;
  g10 = i0;
  i0 = g10;
  i1 = g11;
  i0 = (u32)((s32)i0 >= (s32)i1);
  if (i0) {
    i0 = 272u;
    (*Z_envZ_abortStackOverflowZ_vi)(i0);
  }
  i0 = l146;
  i1 = 144u;
  i0 += i1;
  l117 = i0;
  i0 = l146;
  i1 = 32u;
  i0 += i1;
  l116 = i0;
  i0 = l146;
  l43 = i0;
  i0 = 0u;
  l28 = i0;
  i0 = p0;
  l39 = i0;
  i0 = p1;
  l50 = i0;
  i0 = 4u;
  l61 = i0;
  i0 = 14u;
  l72 = i0;
  i0 = 3u;
  l83 = i0;
  i0 = 5u;
  l94 = i0;
  i0 = 57u;
  l105 = i0;
  i0 = 21u;
  l0 = i0;
  i0 = 39u;
  l11 = i0;
  i0 = 32u;
...
  i0 = l116;
  i1 = l106;
  i32_store(Z_envZ_memory, (u64)(i0), i1);
  i0 = l116;
  i1 = 4u;
  i0 += i1;
  l118 = i0;
  i0 = l118;
  i1 = l107;
  i32_store(Z_envZ_memory, (u64)(i0), i1);
  i0 = l116;
  i1 = 8u;
  i0 += i1;
  l129 = i0;
  i0 = l129;
  i1 = l108;
  i32_store(Z_envZ_memory, (u64)(i0), i1);
...
  i0 = 3965u;
  i1 = l117;
  i0 = f70(i0, i1);
  i0 = l146;
  g10 = i0;
  i0 = 0u;
  goto Bfunc;
  Bfunc:;
  FUNC_EPILOGUE;
  return i0;
}
```

I ditched everything except main and took out bits that I didn't quite understand. And built a C
program that would compile. For i32_store, I just print the "value" argument as a character and
the key pops out. The final program is here: [final.c](final.c).

# Author

[jason@thought.net](mailto:jason@thought.net), [@risenrigel](https://twitter.com/risenrigel)

