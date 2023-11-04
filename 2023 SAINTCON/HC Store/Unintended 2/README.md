# HC Store - Unintended 2

This web store has a least one vulnerability that you can exploit to get the flag. The store is at https://hcstore-unintended2.youcanhack.me.

## Solution

Use the endpoints /cart/addto and /cart/updatein to add a negative number of flag products. Then add a number of random products such that the total number of items in the cart is positive and the total amount in the cart is less than the credit that the user has.