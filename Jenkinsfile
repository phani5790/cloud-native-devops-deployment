pipeline {
    agent any

    environment {
        KUBECONFIG = '/var/jenkins_home/.kube/config'
        IMAGE_NAME = 'phanikumard/cloud-native-devops-app'
    }

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
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
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
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl set image deployment/cloud-native-devops-app \
                    cloud-native-devops-app=${IMAGE_NAME}:${BUILD_NUMBER}

                    kubectl rollout status deployment/cloud-native-devops-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl get deployment cloud-native-devops-app
                    kubectl get pods
                    kubectl get service cloud-native-devops-app
                '''
            }
        }
    }
}
