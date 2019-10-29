# i object via S3

## Description
This vulnerable web application is packaged as a docker image and executed as an Amazon ECS Task. The web app attempts to provide an 'encoded' value for text entered in a text entry field on the page. Given that the site administrator is (in their own words) `new to this whole cloud thing`, it points to other cloud resources that can be exploited.

## Solution
<details>
  <summary>Show solution</summary>
The challenge is to identify the flag that is stored in cloud object storage (AWS S3) using the vulnerable web application as a front-door. If you have solved the `Spiders web -> env vars` challenge you are set on the right path to solve this challenge.

Steps to solve:
1. Obtain the environment variable $AWS_CONTAINER_CREDENTIALS_RELATIVE_URI
2. curl `http://169.254.170.2`+ value stored in the env var from step 1
3. Configure the `AWS CLI` to use the credentials
4. Find the flag file using an AWS CLI command (`aws s3api list-buckets --query "Buckets[].Name"` worked for me)

There may be an additional (yet straight-forward) step of indirection as you investigate/explore the S3 bucket and it's contents. If you get this far you are knocking at the door of the flag.
</details>
