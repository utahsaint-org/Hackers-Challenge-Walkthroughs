# CAPTAIN 1

## Description
This web application was not designed to protect against cloud meta-data attacks. The purpose of the page is to track referral links and show a 'preview' of the page that made the referral. If you have attempted other challenges in this category the approach is comparable to the other challenges.

## Solution
The challenge is to identify the flag by leveraging the fact that the system designers are not guarding against cloud-targeted attacks. The app displays a preview of any URL that is placed in the HTTP Referer header, which can be used as a way to reflect data off the target.

Steps involved:
1. Leverage your preferred REST client (curl, insomnia, postman, etc...) and set an arbitrary 'Referer' header. Watch the results for where you can expect data to be reflected
2. Set the Referer header to `http://169.254.169.254/latest/meta-data/iam/security-credentials/default` and make a request  
This URL is the path for AWS cloud credentials running as EC2 instances in their cloud-compute environment
3. From the values displayed on the page, you should be able to identify the flag.

Note: There is another (slight) layer of indirection around the flag that should be surmountable if you have entered any flags for other challenges.
