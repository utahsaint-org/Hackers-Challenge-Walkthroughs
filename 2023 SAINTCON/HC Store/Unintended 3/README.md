# HC Store - Unintended 3

This web store has a least one vulnerability that you can exploit to get the flag. The store is at https://hcstore-unintended3.youcanhack.me.


## Solution

Send a POST request to /order/place with a total set to a positive value that is less than the remaining credit.