pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install --upgrade pip
                    pip install -r app/requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    . .venv/bin/activate
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
