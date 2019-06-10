pipeline {
    agent {
        docker {
            image 'piomin/jenkins-slave-dind-jnlp'
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