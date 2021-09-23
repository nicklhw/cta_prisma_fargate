# Prisma Cloud Fargate Integration

This repo is a demo of how one can create a Primsa sidecar container in Fargate

1. start up mountebank mock server in http-mock
2. run terraform apply
3. check fargate task definition, there should be a definition called service-testing with 2 container definitions