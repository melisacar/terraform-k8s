# Setting up an EKS Cluster with Terraform and Connecting via kubectl

This repository will walk you through the process of creating an Amazon Elastic Kubernetes Service (EKS) cluster from scratch using Terraform and configuring kubectl on your local machine to manage it. 

## 🗂 Repository Structure

- **`main.tf`**: Main Terraform configuration file defining resources.
- **`variables.tf`**: Definitions of input variables, making the configuration flexible and reusable.
- **`.gitignore`**: Specifies files and directories to ignore in the repository, including sensitive information like terraform.tfvars.
- **`LICENSE`**: MIT License file.

---

## 🔑 Prerequisites

Before starting, ensure you have the following tools installed:

1. **Terraform**: Download and install Terraform from the official website.

2. **AWS CLI**: Install the AWS CLI and configure it using `aws configure`.

3. **kubectl**: Install kubectl following the instructions.

You should also have an AWS account with sufficient permissions to create an EKS cluster and associated resources.

## 🚀 Usage

### Clone the Repository

```bash
git clone https://github.com/melisacar/terraform-k8s.git
cd terraform-k8s
```

#### Steps to Apply Terraform

- `main.tf` is the Terraform configuration file to create an EKS cluster.

1. **Initialize Terraform:**

```bash
terraform init
```

2. **Validate Configuration:**

```bash
terraform validate
```

3. **Apply Terraform Plan:**

```bash
terraform apply
```

4. **Destroy Resources (When Needed)**

```bash
terraform destroy
```

## 🌐 Connecting to the EKS Cluster

Once the cluster is created, configure your local kubectl to access it.

1. **Generate kubeconfig**

Run the following command to generate the kubeconfig file for the cluster:

```bash
aws eks update-kubeconfig --region eu-north-1 --name eks-1-<random_suffix>
```

Replace <random_suffix> with the random string appended to your cluster name (e.g., eks-1-abc12345).

2. **Test the Connection**

Verify that kubectl is configured correctly by running:

```bash
kubectl get nodes
```

You should see a list of nodes from the cluster.

---

### Verifying IAM Identity: `aws sts get-caller-identity`

The command `aws sts get-caller-identity` is used to verify the IAM entity (user or role) making requests to AWS. This is helpful in ensuring that your AWS CLI is configured correctly and the identity has the required permissions.

- You can run:

```bash
aws sts get-caller-identity
```

- The output will look like this:

```bash
{
    "UserId": "AIDASAMPLE123456",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-user-name"
}
```
