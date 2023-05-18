pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_KEY = credentials('AWS_SECRET_KEY')
    }
    stages {
        stage ("terraform init") {
            steps {
                sh ('terraform -chdir="Terraform/" init') 
            }
        }
        stage ("terraform plan") {
            steps {
                sh ('terraform -chdir="Terraform/" plan') 
            }
        }
                
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform -chdir="Terraform/" ${action} -auto-approve') 
           }
        }
    }
}