# title
Logic Bomb

# hint

Tick, Tick,

(logicbomb.jar)[logicbomb.jar]

# solution

Java. Yeck. Ok, jar files are just zip files, so let's unzip it.

```bash
$ unzip ../logicbomb.jar
Archive:  ../logicbomb.jar
  inflating: META-INF/MANIFEST.MF
   creating: org/
   creating: org/eclipse/
   creating: org/eclipse/jdt/
   creating: org/eclipse/jdt/internal/
   creating: org/eclipse/jdt/internal/jarinjarloader/
  inflating: org/eclipse/jdt/internal/jarinjarloader/JIJConstants.class
  inflating: org/eclipse/jdt/internal/jarinjarloader/JarRsrcLoader$ManifestInfo.class
  inflating: org/eclipse/jdt/internal/jarinjarloader/JarRsrcLoader.class
  inflating: org/eclipse/jdt/internal/jarinjarloader/RsrcURLConnection.class
  inflating: org/eclipse/jdt/internal/jarinjarloader/RsrcURLStreamHandler.class
  inflating: org/eclipse/jdt/internal/jarinjarloader/RsrcURLStreamHandlerFactory.class
   creating: bomb/
  inflating: bomb/LogicBomb.class
```

Hrmph, only one interesting class: bomb/LogicBomb.class. The problem is that a class file
is the compiled version of java code. While we could reverse engineer by looking at the
java byte code... Um, no. Let's decompile it back to something like the original java
code. Fortunately, there are online resources for this. I used
[javadecompilers.com](http://www.javadecompilers.com/) and it returned the
following java code: [LogicBomb.java](LogicBomb.java).

Looking at the decompiled java code, there's an encrypted flag "encflag". It is encrypted with
the SHA256 hash of a timestamp and then there's a string:
_Sorry, flag can only be decrypted with ephemeral key that was created and destroyed around build time... your loss_

Well, how do we know the build time of this class file? Examine the modification time:

```
$ ls -l --time-style=full-iso
total 4
-rwxrwxrwx 1 rigel rigel 3630 2018-07-04 11:13:12.000000000 -0600 LogicBomb.class
```

So, July 4, 2018 at 11:13:12 is our approximate build time. The next step is to brute force all of the possible time stamp values on July 4, 2018... For which I wrote a java program.  There are a bunch of false positives to wade through, but the key is obvious when you find it.

Here's my solution finder: [logicbomb-solve.java](logicbomb-solve.java)


# Author

[jason@thought.net](mailto:jason@thought.net), [@risenrigel](https://twitter.com/risenrigel)

