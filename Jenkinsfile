pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t us-central1-docker.pkg.dev/groovy-legacy-434014-d0/react-app/react-app:2 .'
                }
            }
        }

        stage('Push Docker Image to Artifact Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'gcr-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'docker login -u $USERNAME -p $PASSWORD https://us-central1-docker.pkg.dev'
                        sh 'docker push us-central1-docker.pkg.dev/groovy-legacy-434014-d0/react-app/react-app:2'
                    }
                }
            }
        }

        stage('Deploy to Cloud Run') {
            steps {
                script {
                    // Add deployment steps here
                }
            }
        }
    }
}
