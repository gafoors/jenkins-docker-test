pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Run docker') {
            steps {
                sh 'mvn exec:exec'
            }
        }
    }
}