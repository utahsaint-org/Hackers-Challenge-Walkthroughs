# Super Cool Secret Project

I built this service to automatically deploy my application to all the servers that want to run it.

All you have to do is provide a SSH username, and host, and I will connect and give you a copy of the app. Please accept my public key.

http://deployserver.youcanhack.me/

![deployserver.youcanhack.me](./deployserver.jpg)

## Solution

We're given access to deployserver which will deploy an application to a server under our control. A public SSH key is provided that we need to add to a user's .ssh/authorized_keys file on our server. This will allow the deployserver to authenticate with our server over ssh. After the public key is added - we provide the username, hostname, port number and then submit the form. After doing so, we see the message '--- SSH Attempted ---'. Let's go take a look at the user's home directory and see if it deployed anything.

```
➜ ls -1
HC2023-SuperCoolSecretProject
```

We see that it did in fact deploy an app called 'HC2023-SuperCoolSecretProject' to our user's home directory. When we change into the directory and list the contents, we see that it's a git repository with a README:

```
➜ cd HC2023-SuperCoolSecretProject && ls -lah
total 20K
drwxr-xr-x. 3 hc hc 4.0K Nov  1 02:10 .
drwx------. 7 hc hc 4.0K Nov  1 02:48 ..
drwxrwxr-x. 8 hc hc 4.0K Nov  1 02:47 .git
-rw-r--r--. 1 hc hc   24 Nov  1 02:10 .gitignore
-rw-r--r--. 1 hc hc   25 Nov  1 02:10 README.md
```

Not much in the README:
```bash
➜  cat README.md
# SuperCoolSecretProject
```

A quick grep reveals a .flag file is being ignored via the gitignore.
```bash
➜  HC2023-SuperCoolSecretProject git:(main) grep -R 'flag' .
./.gitignore:.flag
```

Hm, well let's take a look at the git log and see what history exists in version control. It's possible the file was committed to the repo at one point and then was later removed. If that's the case there's a chance it wasn't removed properly from the repo and we may be able to recover it.

```bash
➜  git log
78aba76 - (grafted, HEAD, origin/main, origin/HEAD, main) oops! remove secret (Sat Oct 21 21:11:41 2023 -0600) <zevlag>
```

It looks like zevlag removed a secret from the repo. Perhaps our flag? Let's take a look at the git diff for that commit and see what changed. If we're lucky, he didn't remove it from the repo the proper way and we may be able to see it.

```diff
➜  git show 78aba76
diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..5b11eb4
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,3 @@
+.flag
+id_rsa
+id_rsa.pub
diff --git a/README.md b/README.md
new file mode 100644
index 0000000..2308fa5
--- /dev/null
+++ b/README.md
@@ -0,0 +1 @@
+# SuperCoolSecretProject
```

Dang, no flag and there are no other commits. It seems it was removed the proper way. That's good. So.. there must be something else. Let's think about this. Git repositories generally have a 'remote' that specifies where it's hosted and can be fetched and pushed. Perhaps the secret still exists in the remote repository? Let's check and see what this repository's remotes are set to:

```bash
➜  git remote -v
origin	git@github.com:SAINTCON-HC2023/SuperCoolSecretProject.git (fetch)
origin	git@github.com:SAINTCON-HC2023/SuperCoolSecretProject.git (push)
```

Great, that's something. It's host on github and has an ssh origin url. That means the repository can be pulled and pushed to over ssh with public key authentication. We know the deployserver used ssh to securely copy the repository onto our server. Let's re-evaluate the commands that were used to do that:

```bash
git clone --depth 1 {censored URL}
scp -P {port} -rCA ~/SuperCoolSecretProject {user}@{host}:~/HC2023-SuperCoolSecretProject
```

Interesting.. The repository was cloned down with the same user that then securely copied the repository onto our server. In order to clone the repository, the user must have authenticated over ssh since the remote origin urls are ssh urls. Let's take a look at the options that were passed to the `scp` command (`-rCA`) to fully understand what it's doing. The `r` option means copy recursively and the `C` option enables compression which reduces the total bandwidth needed for the transfer. The `A` option doesn't appear to be a valid / documented scp option. However, if you use ssh often, you may know that `-A` is a valid option for `ssh`: If we RTFM:

```bash
-A      Enables forwarding of connections from an authentication agent such as ssh-agent(1).  This can also be specified on a per-host basis in a configuration file.

        Agent forwarding should be enabled with caution.  Users with the ability to bypass file permissions on the remote host (for the agent's UNIX-domain socket) can access the local agent through the forwarded connection.  An attacker cannot obtain key
        material from the agent, however they can perform operations on the keys that enable them to authenticate using the identities loaded into the agent.  A safer alternative may be to use a jump host (see -J).
```

If someone is able to access the forwarded SSH_AUTH_SOCK, they could export it and use it as their own. We may be able to do exactly that. Just from experience, we know SSH_AUTH_SOCK is exported to /tmp by default with the pattern 'ssh-XXXXXXXXXX/agent.%d'. Let's take a look in /tmp on the server and see if the deployserver forwarded it's SSH_AUTH_SOCK:

```bash
➜  ls -lah /tmp/ssh-ARAGypNoQ0/agent.1303
srwxr-xr-x. 1 hc hc 0 Nov  2 03:12 /tmp/ssh-ARAGypNoQ0/agent.1303
```

Yep! It is. From here.. All we need to do is export SSH_AUTH_SOCK to that path in our environment.

```bash
➜  export SSH_AUTH_SOCK=/tmp/ssh-ARAGypNoQ0/agent.1303
```

Now let's see if we can use this forwarded auth socket to authenticate with the remote repository and pull down any extra history that might exists:

```bash
➜  git pull
```

TODO