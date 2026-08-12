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

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        docker tag \
                            cloud-native-devops-app:${BUILD_NUMBER} \
                            $DOCKER_USERNAME/cloud-native-devops-app:${BUILD_NUMBER}

                        docker push \
                            $DOCKER_USERNAME/cloud-native-devops-app:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }
    }
}
