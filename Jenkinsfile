pipeline {
    agent any

    stages {

        stage('Test') {
            steps {
                sh '''
                    pytest app/tests/test_app.py
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t cloud-native-devops-app:${BUILD_NUMBER} .
                '''
            }
        }
    }
}
