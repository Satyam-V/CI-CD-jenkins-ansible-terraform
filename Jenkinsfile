pipeline {
  agent any
    tools {
    maven 'M2_HOME'
     }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS')
    }
  stages {
        stage('Checkout') {
            steps {
                // Checking out code from a GitHub repository
                git branch: 'main', credentialsId: 'git-testing', url: 'https://github.com/Satyam-V/CI-CD-jenkins-ansible-terraform.git'
                }
            }
    
  stage('Package the Application') {
      steps {
        echo " Packaing the Application"
        sh 'mvn clean package'
            }
    }
    
    stage('Publish Reports using HTML') {
      steps {
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/bankapp/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }
    stage('Docker Image Creation') {
      steps {
        sh 'docker build -t satyamv/bankapp:latest .'
            }
    }
    stage('Push Image to DockerHub') {
      steps {
          withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                sh 'docker push satyamv/bankapp:latest'
            }
        }
    } 
    stage ('create and configure Test-server with Terraform, Ansible and then Deploy'){
            steps {
                dir('my-serverfiles'){
                sh 'sudo -S chmod 600 jenkinsuse.pem'
                sh 'terraform init'
                sh 'terraform validate'
                
                sh 'terraform apply --auto-approve'
                }
            }
    }
    //  or you can use this way also to authenticate aws account  and to apply the infrastructure.
    //  stage('Terraform Apply') {
    //         steps {
    //             dir('my-serverfiles')
    //             script {
    //                 withCredentials([[
    //                     $class: 'AmazonWebServicesCredentialsBinding',
    //                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    //                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
    //                     credentialsId: 'aws'
    //                 ]]) {
    //                     sh 'terraform apply -var="region=${AWS_DEFAULT_REGION}"'
    //                 }
    //             }
    //         }
    //     }
    stage ('Deploy into test-server using Ansible') {
          steps {
             ansiblePlaybook credentialsId: 'jenkinsuse', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
          }
        }
   }
}
