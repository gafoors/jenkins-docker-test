pipeline {
    agent {
        label 'maven'
    }
    stages {
        stage('Run docker') {
            steps {
                sh 'mvn exec:exec'
            }
        }
    }
}