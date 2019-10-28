# Masks

## Description

This password is 8 characters in length and consists only of characters in uppercase hexadecimal. Can you crack the password?
44a21e6d78a469804b228ac74ced47d7

## Solution
<details>
  <summary>Show solution</summary>
  
  ```javascript
    function whatIsLove() {
      console.log('Baby Don't hurt me. Don't hurt me');
      return 'No more';
    }
  ```
The problem outlined defines a fairly specific password policy for this hash we are suppose to break, combined with the name of the challenge, using hashcat's masking attack sounds like the perfect application to break this.

`hashcat -a 3 -1 ?H 44a21e6d78a469804b228ac74ced47d7 ?1?1?1?1?1?1?1?1`

`-a 3` tells hashcat to use a mask attack, `-1 ?H` tells it the charset to use for the mask with `?H` representing the hexadecimal range, the hash is next in the command, `?1?1?1?1?1?1?1?1` explicitly states the layout of the password with each `?1` representing a single character pulled from the first custom charset defined (in this case it is any hexadecimal number we defined before).
</details>
