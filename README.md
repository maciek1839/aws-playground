# AWS playground

Amazon Web Services, Inc. is a subsidiary of Amazon that provides on-demand cloud computing platforms and APIs to individuals, companies, and governments, on a metered, pay-as-you-go basis. 

Founded: March 2006

## Getting started

Tested on AWS CLI: 2.5.2 and Windows 10

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

If you are using Windows, you can use Git Bash, any other shell supporting `.sh` files.  
Alternatively you can copy AWS commands from scripts and paste into a terminal.

## awslocal vs aws

This package provides the awslocal command, which is a thin wrapper around the aws command line interface for use with LocalStack.

Instead of the following command ...

```
aws --endpoint-url=http://localhost:4566 kinesis list-streams
```

... you can simply use this:

```
awslocal kinesis list-streams
```

Ref: https://github.com/localstack/awscli-local
