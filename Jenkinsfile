pipeline {
    agent any

    environment {
        PROJECT_ID = 'groovy-legacy-434014-d0'
        IMAGE_NAME = 'us-central1-docker.pkg.dev/groovy-legacy-434014-d0/react-app/react-app'
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account') // Update with your GCP credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image to Artifact Registry') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'gcp-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}"
                        sh "gcloud auth configure-docker us-central1-docker.pkg.dev"
                        sh "docker push ${IMAGE_NAME}:${env.BUILD_ID}"
                    }
                }
            }
        }

        stage('Deploy to Cloud Run') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'gcp-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}"
                        sh "gcloud run deploy my-react-app --image ${IMAGE_NAME}:${env.BUILD_ID} --platform managed --region us-central1 --allow-unauthenticated"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
