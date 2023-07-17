# Amazon Simple Queue Service (SQS)

Amazon SQS was the first service introduced in AWS. It gives users access to message queues. This queue is used to keep messages while it waits to be processed. Amazon SQS enables services on the web to quickly queue messages that are sent by one component to be processed by another component. Ref: https://intellipaat.com/blog/what-is-aws-sqs/

## Getting started

**Available scripts are shell scripts that run in Linux/macOS operating systems. Use AWS commands directly if you are using Windows.**

1. Be sure that LocalStack is running.
2. Execute scripts available in the `scripts` folder.

```bash
$ scripts/01-get-attributes.sh
```

## Queue types

- Standard Queues
- FIFO queues

References: 
- https://aws.amazon.com/sqs/features/
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-queue-types.html
