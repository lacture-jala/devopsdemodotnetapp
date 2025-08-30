pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '156172784305'
        AWS_REGION = 'ap-south-1'
        ECR_REPO_NAME = 'devopsdemodotnetapp'
        IMAGE_TAG = 'latest'  // You can dynamically set the build version
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
        EC2_INSTANCE_IP = '13.233.134.116'
        EC2_USER = 'ubuntu'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Checkout the code from Git/Bitbucket
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${ECR_URI}", ".")  // Build the Docker image
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    sh 'dotnet test'  // Run unit tests (adjust if needed for your project)
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-id']]) {
                        sh '''
                            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com", "aws-credentials-id") {
                        docker.image("${ECR_URI}").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_INSTANCE_IP} << 'EOF'
                    docker pull ${ECR_URI}
                    docker run -d -p 80:80 ${ECR_URI}
                    EOF
                    """
                }
            }
        }

        stage('Open EC2 Security Group Port 80') {
            steps {
                script {
                    sh '''
                    aws ec2 authorize-security-group-ingress --group-id sg-xxxxxxxx --protocol tcp --port 80 --cidr 0.0.0.0/0
                    '''
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "Build Success: ${JOB_NAME} - Build # ${BUILD_NUMBER}",
                body: "The build has completed successfully.\n\nView build: ${BUILD_URL}",
                to: "admin@example.com"
            )
        }
        failure {
            emailext(
                subject: "Build Failure: ${JOB_NAME} - Build # ${BUILD_NUMBER}",
                body: "The build has failed.\n\nView build: ${BUILD_URL}",
                to: "admin@example.com"
            )
        }
    }
}
