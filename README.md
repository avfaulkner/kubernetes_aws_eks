# Kubernetes on AWS / EKS

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) - communicates with AWS services
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - communicates with the cluster API server
- [AWS-IAM-Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) - allow IAM authentication with the Kubernetes cluster
- eksctl - command line utility for creating and managing Kubernetes clusters on Amazon EKS
- wget (required for the eks module)
- Terraform >= 1.1.4

## Steps

- Run the following command to retrieve the access credentials for your cluster and automatically configure kubectl.

```text
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```
