### creating the jenkins server
Yoi have to first provisioned an ec2 instance that will house the jenkins server using terraform (IAc code)

![Image](https://github.com/user-attachments/assets/6c4ab5bd-57b9-4038-84e1-220ae9de50b0)

### below find the aws dashboard shoing the jenkins server created using terraform

![Image](https://github.com/user-attachments/assets/7ec4b6cc-93e7-4af3-ac4a-9eca60b492ad)

### shown below is the entry of the creaentioals jenkins dashbaord

![Image](https://github.com/user-attachments/assets/1a7618d7-bc21-456c-95df-d4e08527f8e5)


![Image](https://github.com/user-attachments/assets/75e3a6dd-9317-4634-9917-232bc42cf4c3)


![Image](https://github.com/user-attachments/assets/ef22ad8b-f888-45cc-8ef6-c089c1395a31)

### entering the accesskey and secret key in manage jenkins

![Image](https://github.com/user-attachments/assets/1e139a24-e145-4b95-9298-0aba4b24d3ce)



### Automating the process of cluster creattion using jenkins pipeline but firs configure that access key and secret on jenkins manage jenkins as seen below

![Image](https://github.com/user-attachments/assets/3efb5e4d-d2b5-4bc2-ae12-dceafcd8ab96)


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
**Alternatively you can equally set up or create the dynamoDb table using the command below**

👉  **DynamoDB table** named `terraform-eks-state-locks` for state locking. If not, create it:

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

**Now create the S3 bucket and DynamoDb within the Terraform Backend** run this command below:
```bash
terraform validate
terraform apply --auto-approve
```
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
aws eks list-clusters --region eu-west-2
```
or
```bash
terraform output
```
You should see your **EKS Cluster ID** and other outputs.


**📌 Step 9: Configure kubectl for EKS**
To use `kubectl` with your EKS cluster, update your kubeconfig:

```bash
aws eks update-kubeconfig --name YOUR_CLUSTER_NAME --region eu-west-2
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

**📌 Step 10: Cleaup Respources deployed**

This will destroy all the resources created **VPC, Subnets, Security Groups and EKS Cluster**.

**Now destroy the S3 bucket and DynamoDb within the Terraform Backend** run this command below:
```bash
cd EKS-Cluster/Backend
terraform destroy --auto-approve
```