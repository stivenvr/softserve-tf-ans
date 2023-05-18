pipeline {
    agent any

    stages {
        stage ("terraform init") {
            steps {
                sh ('terraform -chdir="Terraform/" init -reconfigure') 
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
                sh ('terraform -chdir="Terraform/" ${action} --auto-approve') 
           }
        }
    }
}