pipeline {
    agent {
        docker {
            image 'piomin/jenkins-slave-dind-jnlp'
            args '--privileged'
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