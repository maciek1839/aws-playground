# AWS playground

Amazon Web Services, Inc. is a subsidiary of Amazon that provides on-demand cloud computing platforms and APIs to individuals, companies, and governments, on a metered, pay-as-you-go basis. Founded: March 2006


## Getting started

**Example scripts are using AWS CLI.  
If you are using Windows, copy AWS commands from scripts and paste into a terminal directly as `.sh` scripts are not supported by default.**

Tested on AWS CLI: 2.5.2

1. Install AWS CLI 2.
2. Run `docker-compose.yml` which initializes AWS services.
   1. By default, resources are created in `eu-central-1` region.
3. (Optional) Ensure that LocalStack was properly initialized. You can log into a container and check logs.
4. Go to proper directories depending on your interests e.g. dynamodb or sqs.
5. Get familiar with a service by reading a `README.md` present in the directory you chose.
6. Execute scripts from a relevant `scripts` directory.

```bash
$ cd sqs
$ scripts/01-get-attributes.sh
```

**Available scripts are shell scripts that by default run in Linux/macOS operating systems.**

If you are using Windows, you can use Git Bash, any other shell supporting `.sh` files or use AWS commands directly.
