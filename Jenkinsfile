pipeline {
    agent any

    stages {
        stage('Terraform apply'){
            steps{
                sh 'terreform -chdir="Terraform/" apply -auto-approve'
            }
        }
        stage('Ansible exec'){
            steps{
                sh 'ansible-playbook -i Ansible/hosts.txt Ansible/playbook_docker.yml'
            }
        }
    }
}