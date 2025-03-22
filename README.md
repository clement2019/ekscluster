# EKS-Cluster
Step-by-step guide to initializing EKS cluster using Terraform
---

**📌 Step 1: Create IAM User**
Create **IAM user** and attached **AdministratorAccess** policy.

**📌 Step 2: Configure AWS CLI**
Now, configure the AWS CLI on local machine using the IAM credentials:

```bash
Run: aws configure
```

**Provide the following details:**
- **AWS Access Key ID**: `YOUR_ACCESS_KEY`
- **AWS Secret Access Key**: `YOUR_SECRET_KEY`
- **Default region**: (e.g., `us-east-1`)
- **Output format**: (default: `json`)

Verify authentication:
```bash
aws sts get-caller-identity
```
If correctly configured, you should see your AWS **Account ID, User ID, and ARN**.

**📌 Step 3: Initialize Terraform Backend (S3 & DynamoDB)**
Before running Terraform commands, make sure **Backend/main.tf** file correctly sets up the remote backend (S3 & DynamoDB for state locking).

👉 Ensure you have a **DynamoDB table** named `terraform-eks-state-locks` for state locking. If not, create it:

```bash
aws dynamodb create-table \
    --table-name terraform-eks-state-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```

**Initialize Terraform Backend**
Now, initialize the backend inside the **Backend/** directory:
```bash
cd EKS-Cluster/Backend
terraform init
```
🚀 This will connect your Terraform setup to the **remote state stored in S3**.

**📌 Step 4: Initialize Main Terraform Configuration**
Next, initialize the Terraform config in **root directory** where `main.tf` is located.

```bash
cd ../  # Move back to EKS-Cluster directory
terraform init
```

**📌 Step 5: Validate Terraform Code**
Before applying the changes, validate your Terraform configuration:

```bash
terraform validate
```

If everything is correct, you’ll see **"Success! The configuration is valid."**.

**📌 Step 6: Plan the Terraform Deployment**

Run:
```bash
terraform plan
```
This will show you the resources that Terraform is about to create.

**📌 Step 7: Deploy the EKS Cluster**
Now, apply the changes to create the cluster:

```bash
terraform apply -auto-approve
```
✅ This will create **VPC, Subnets, Security Groups and EKS Cluster**.

**📌 Step 8: Verify the EKS Cluster**
Once Terraform completes, verify that the cluster is created:

```bash
aws eks list-clusters --region us-east-1
```
or
```bash
terraform output
```
You should see your **EKS Cluster ID** and other outputs.


**📌 Step 9: Configure kubectl for EKS**
To use `kubectl` with your EKS cluster, update your kubeconfig:

```bash
aws eks update-kubeconfig --name YOUR_CLUSTER_NAME --region us-east-1
```
Test connectivity:
```bash
kubectl get nodes
```
If everything is set up correctly, you’ll see your cluster nodes.

---

**✅ Summary of Steps**
1. **Create IAM User** with **AdministratorAccess**.
2. **Configure AWS CLI** with IAM credentials.
3. **Initialize Terraform Backend** (S3 & DynamoDB).
4. **Initialize Terraform Configuration**.
5. **Validate Terraform Code**.
6. **Run Terraform Plan**.
7. **Apply Terraform to Create EKS**.
8. **Verify EKS Cluster**.
9. **Configure kubectl for EKS**.

Happy Learning......
