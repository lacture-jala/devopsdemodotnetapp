pipeline{
    agent any 
    // triggers{
    //     pollSCM ('* * * * *')
    // }

    stages{
        stage('first stage'){
            steps{
                echo "Welcome to first stage"
            }
        }
        stage('build docker file stage'){
            steps{
                sh '''
                    docker build -t ashish142/devopsdemodotnetapp:V1 .
                '''
            }
        }
    }
}