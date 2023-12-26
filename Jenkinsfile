pipeline {
  agent any
    tools {
    maven 'M2_HOME'
     }
  stages {
        stage('Checkout') {
            steps {
                // Checking out code from a GitHub repository
                git branch: 'main', credentialsId: 'git-testing', url: 'https://github.com/Satyam-V/CI-CD-jenkins-ansible-terraform.git'
                }
            }
    // Package the application
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
            }
        sh 'docker push satyamv/bankapp:latest'
            }
    } 
    
    }
}

//         stage ('Configure Test-server with Terraform, Ansible and then Deploying'){
//             steps {
//                 dir('my-serverfiles'){
//                 sh 'sudo chmod 600 BabucKeypair.pem'
//                 sh 'terraform init'
//                 sh 'terraform validate'
//                 sh 'terraform apply --auto-approve'
//                 }
//             }
//         }
// /*        stage ('Deploy into test-server using Ansible') {
//            steps {
//              ansiblePlaybook credentialsId: 'BabucKeypair', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'finance-playbook.yml'
//            }
//                }*/
//      }
// }
