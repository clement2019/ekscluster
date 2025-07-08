
### Project Introduction

This is a project that deploys an nginx webserver as the end product using terraform commnands runing in a jenkins pipeline. The project is in two phases initially, i had to provision the jenkins server using terraform (IAC) and within the script that produces the jenkins software i inserted some scripts to install terraform and aws cli

In the secoond phase once jenkins is configured now using jenkins pipeline,to run another terraform commands that will first create an aws eks cluster and chenge directory to the menifest folder to deploy the nginx to aws cloud managed kubernetes cluster(aws-eks).


### Project overview

1.IAM User Setup: Create an IAM user on AWS with the necessary permissions to facilitate deployment and management activities.

2.Infrastructure as Code (IaC): Use Terraform and AWS CLI to set up the Jenkins server (EC2 instance) on AWS.

3.Installing Jenkins: Through the jenkins-script.sh install jenkins software and aws cli

4.Jenkins Server Configuration: Through the manage jenkins menu, install and configure essential plugins and tools such as terraform

5.Jenkins Pipelines: Create Jenkins pipelines for deploying nginx websers application to the EKS cluster.

6.AWS CLI - installed on the jenkins server,enable you to interface with AWS infrastructure.

8.AWS configure - to insert Access-key and Secret-key, including Region and json format.

9.EKS Cluster Deployment: Utilize eksctl commands to create an Amazon EKS cluster, a managed Kubernetes service on AWS.


#### Prerequisites:

Before starting the project, ensure you have the following prerequisites:

-An AWS account with the necessary permissions to create resources.

-Terraform and AWS CLI installed on your local machine.

-Basic familiarity with Kubernetes, terraform, Jenkins, and best DevOps principles.

-Vscode - code editor installed locally on your machine.

- GitHub - a repository for your project code

https://github.com/clement2019/ekscluster.git



### creating the jenkins server
I have to first provisioned an ec2 instance that will house the jenkins server using terraform (IAc code)

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


**📌 Step 10: Jenkinsfile pipeline**

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'eu-west-2'
    }
    parameters {
        
        
        choice choices: ['apply', 'destroy'], description: '''Choose your terraform action
        ''', name: 'action'
    }
    stages{
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dajari1/a.git']])
                }
            }
        }
        stage('Initializing backend'){
            steps{
                script{
                    dir('backend'){
                         sh 'terraform init'
                         sh 'terraform fmt'
                         sh 'terraform validate'
                         sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        stage('Initializing teraform'){
            steps{
                script{
                    dir('terraform-files'){
                         sh 'terraform init'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform-files'){
                         sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the infrastructure'){
            steps{

                script{

                    dir('terraform-files'){

                        sh 'terraform plan'
                    }
                    input(message: "Approve?", ok: "proceed")
                }
            }
        }

        stage('Terraform Apply') {
            steps {
               /// withAWS(credentials: 'aws-key', region: 'us-east-1') { 
                script {
                    if (params.'action' == 'apply') {

                        echo "You have chosen to ${params.'action'} the resources"
                        dir('terraform-files'){
                            sh 'terraform $action --auto-approve'
                                
                    
                        }
                    }
                }
        

            }
        }
        stage('Deploypment into kubernetes cluster') {
            steps {
               /// withAWS(credentials: 'aws-key', region: 'us-east-1') { 
                script {
                    if (params.'action' == 'apply') {

                        dir('manifests') {
                            sh ('aws eks update-kubeconfig --name aws-eks-cluster --region eu-west-2')
                            sh "kubectl get ns"
                            sh "kubectl apply -f deployment.yaml"
                            sh "kubectl apply -f service.yaml"
                        }

                       
                    }
                }
        

            }
        }
        stage('Terraform Destroy') {
            steps {
               /// withAWS(credentials: 'aws-key', region: 'us-east-1') { 
                script {
                    if (params.'action' == 'destroy') {

                        echo "You have chosen to ${params.'action'} the resources"
                        dir('terraform-files'){
                            sh 'terraform $action --auto-approve'
                        
                        }
                    }
                }
        

            }
        }
    }
}
    

**📌 Step 11: Cleaup Respources deployed**

This will destroy all the resources created **VPC, Subnets, Security Groups and EKS Cluster**.

**Now destroy the S3 bucket and DynamoDb within the Terraform Backend** run this command below:
```bash
cd EKS-Cluster/Backend
terraform destroy --auto-approve
```