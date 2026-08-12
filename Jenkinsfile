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
                    docker tag cloud-native-devops-app:${BUILD_NUMBER} phanikumard/cloud-native-devops-app:${BUILD_NUMBER}
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push phanikumard/cloud-native-devops-app:${BUILD_NUMBER}
                        docker logout
                    '''
                }
            }
        }
    }
}
