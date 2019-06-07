pipeline {
    agent {
        label 'maven-jnlp'
    }
    stages {
        stage('Run docker') {
            steps {
                sh 'mvn exec:exec'
            }
        }
    }
}