pipeline {
    agent any

    stages {

        stage('Test') {
            steps {
                sh 'pytest app/tests/test_app.py'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t phanikumard/cloud-native-devops-app:${BUILD_NUMBER} .'
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

        stage('Deploy to AWS Kubernetes') {
            steps {
                sh '''
                    ssh -i /root/.ssh/cloud-keypair.pem \
                        -o StrictHostKeyChecking=no \
                        ubuntu@3.144.6.205 \
                        "cd ~/cloud-native-devops-deployment && \
                         helm upgrade --install cloud-native-devops-app \
                         helm/cloud-native-devops-app \
                         --set image.tag=${BUILD_NUMBER} && \
                         kubectl rollout status deployment/cloud-native-devops-app --timeout=120s"
                '''
            }
        }
    }
}
