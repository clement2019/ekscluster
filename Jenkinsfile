
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
    