# Setting up an EKS Cluster with Terraform and Connecting via kubectl

This guide will walk you through the process of creating an Amazon Elastic Kubernetes Service (EKS) cluster from scratch using Terraform and configuring kubectl on your local machine to manage it. We will address common challenges encountered during the setup and provide solutions.

## Prerequisites

Before starting, ensure you have the following tools installed:

1. **Terraform**: Download and install Terraform from the official website.

2. **AWS CLI**: Install the AWS CLI and configure it using `aws configure`.

3. **kubectl**: Install kubectl following the instructions.

You should also have an AWS account with sufficient permissions to create an EKS cluster and associated resources.

## Terraform Configuration

`main.tf` is the Terraform configuration file to create an EKS cluster.

## Steps to Apply Terraform

1. Initialize Terraform:

```t
terraform init
```

1. Validate Configuration:

```t
terraform validate
```

1. Apply Terraform Plan:

```t
terraform apply
```

## Connecting to the EKS Cluster

Once the cluster is created, configure your local kubectl to access it.

### Generate kubeconfig

Run the following command to generate the kubeconfig file for the cluster:

```t
aws eks update-kubeconfig --region eu-north-1 --name eks-1-<random_suffix>
```

Replace <random_suffix> with the random string appended to your cluster name (e.g., eks-1-abc12345).

## Notes

### Test the Connection

Verify that kubectl is configured correctly by running:

```t
kubectl get nodes
```

You should see a list of nodes from the cluster.

### Verifying IAM Identity: `aws sts get-caller-identity`

The command `aws sts get-caller-identity` is used to verify the IAM entity (user or role) making requests to AWS. This is helpful in ensuring that your AWS CLI is configured correctly and the identity has the required permissions.

You can run:

```bash
aws sts get-caller-identity
```

The output will look like this:

```bash
{
    "UserId": "AIDASAMPLE123456",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-user-name"
}
```