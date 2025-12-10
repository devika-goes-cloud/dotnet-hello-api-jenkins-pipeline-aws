pipeline {
    agent any
  
    /*********************************************************
     * GLOBAL CREDENTIAL VARIABLES ( Creds that hardly changes)
     *********************************************************/
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')   // username + password
        IMAGE_NAME = "devika12345/dotnet-hello-world"
        IMAGE_TAG = "v1.0"
    }
  
    /*********************************************************
     * PARAMETER FOR UAT / PROD DEPLOYMENT
     *********************************************************/
    parameters {
        choice(
            name: 'ENV',
            choices: ['UAT', 'PROD'],
            description: 'Select deployment environment'
        )
    }
    /*********************************************************
     * PIPELINE STAGES
     *********************************************************/
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/devika-goes-cloud/dotnet-cicd-jenkins-aws.git'
            }
        }
        stage('Set Environment Variables') {
            steps {
                script {
                    // Environment Variables for UAT and PROD EC2 servers
                    if (params.ENV == 'UAT') {
                        env.EC2_IP = "3.110.45.169"
                    }
                    if (params.ENV == 'PROD') {
                        env.EC2_IP = "13.200.250.92"
                    }
                    echo "Selected Environment: ${params.ENV}"
                    echo "Target EC2 IP: ${env.EC2_IP}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }
        stage('Login to Docker Hub') {
            steps {
                sh """
                echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin
                """
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        stage('Deploy to EC2 Server') {
            steps {
                
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'aws-ssh-key',
                    keyFileVariable: 'SSH_KEY_FILE',
                    usernameVariable: 'SSH_USER'
                )]) {
                    
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_FILE} ${SSH_USER}@${EC2_IP} '
                        docker pull ${IMAGE_NAME}:${IMAGE_TAG}

                        docker stop hello-world-api-container || true
                        docker rm -f hello-world-api-container || true

                        docker run -d --name hello-world-api-container -p 5000:5000 ${IMAGE_NAME}:${IMAGE_TAG}
                    '
                    """
                }
            }
        }
        stage('Health Check') {
            steps {
             sh """ 
             sleep 5  // pause for 5 seconds
             curl -v http://${EC2_IP}:5000/api/hello || echo "Health check failed" 
             """
            }
        }
    }
    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
    }
}
