# Kubernetes on AWS / EKS

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html) - communicates with AWS services
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - communicates with the cluster API server
- [AWS-IAM-Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) - allow IAM authentication with the Kubernetes cluster
- Terraform >= 1.1.4

## Steps

### Note: Currently, if planning to use EC2 instances for nodes only, comment out the code in fargate.tf. If planning to use Fargate and not EC2 instances only, comment out all code under the "worker node group" heading in eks.tf. 

- Apply any necessary variables to terraform.tfvars

- Initialize the Terraform
```text
terraform init
```

- View the planned infrastructure buildout
```text
terraform plan -out=tfplan
```

- Apply the plan
```text
terraform apply tfplan
```

- Run the following command to retrieve the access credentials for your cluster and automatically configure kubectl.

```text
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

- Deploy a service to your cluster
```text
kubectl apply <your config file>.yaml
```

- Verify that the nodes are running
```text
kubectl get nodes --all-namespaces
```

- Verify that the pods are running
```text
kubectl get pods --all-namespaces
```

- Verify that the services are running
```text
kubectl get services --all-namespaces
```
### Notes
If using EC2 node groups, the code will dynamically place one EC2 instance in each
availibility zone within the chosen region. 
