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
---

## Troubleshooting Notes

### Resolving Errors After `terraform destroy`

- **Issue**

```java
Error: deleting **EC2 Subnet** (subnet-03e...): operation error EC2: DeleteSubnet, https response error StatusCode: 400, RequestID: 429c6..., api error DependencyViolation: The subnet 'subnet-03e...' has dependencies and cannot be deleted.
```

```java
Error: deleting **EC2 Internet Gateway** (igw-04a...): detaching EC2 Internet Gateway (igw-04a...) from VPC (vpc-04f...): operation error EC2: DetachInternetGateway, https response error StatusCode: 400, RequestID: 66e97..., api error DependencyViolation: Network vpc-04f198515baf8ac52 has some mapped public address(es). Please unmap those public address(es) before detaching the gateway.
```

#### **Resolution Steps**

- **Run `terraform plan` with `-destroy` flag**
This will help you plan the destruction of resources.

```bash
terraform plan -destroy
```

- **Create a plan file for destruction**
This stores the plan output into a file named `tfplan`.

```bash
terraform plan -destroy -out=tfplan
```

- **Apply the destruction plan**
After confirming the destruction plan is correct, apply it.

```bash
terraform apply “tfplan” 
```

**Still Facing Errors?**

If the issue persists with the same errors regarding **EC2 Subnet** and **Internet Gateway**, follow these additional steps:

- **Inspect the resources in Terraform state**
This helps you check the resources that Terraform is managing.

```bash
terraform state list
```

**Expected Output Example:**

```bash
- module.vpc.aws_internet_gateway.this[0]
- module.vpc.aws_subnet.public[0]
- module.vpc.aws_vpc.this[0]
```

- **Manually remove problematic resources from Terraform state**

Sometimes, resources need to be manually removed from the state to ensure Terraform does not try to manage them anymore.

Example command to remove an Internet Gateway from the state:

```bash
terraform state rm module.vpc.aws_internet_gateway.this[0]
```

You can remove any other resources that are causing issues in a similar manner. Ensure that no other resources depend on the ones you're removing.

#### References

- Terraform `state rm` documentation for more details on removing resources from Terraform state:

- [Terraform State Remove](https://developer.hashicorp.com/terraform/cli/commands/state/r)