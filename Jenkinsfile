pipeline {
    agent any

    environment {
        GOOGLE_CREDENTIALS = 'gcp-credentials-id' // Jenkins credentials ID for GCP Service Account
        PROJECT_ID = 'groovy-legacy-434014-d0' // GCP Project ID
        REGION = 'us-central1' // GCP Region
        IMAGE_NAME = 'us-central1-docker.pkg.dev/groovy-legacy-434014-d0/react-app/react-app' // Google Artifact Registry image path
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
				cleanWs()
                checkout scm // Check out code from the repository
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'whoami'
                    myimage = docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage("Push Docker Image to Artifact Registry") {
            steps {
                script {
                    echo "Push Docker Image to Google Artifact Registry"
                    withCredentials([file(credentialsId: 'gcp-credentials-id', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh "gcloud auth configure-docker us-central1-docker.pkg.dev"
                    }
                    myimage.push("${env.BUILD_ID}")
                }
            }
        }

        stage('Deploy to Cloud Run') {
            steps {
                script {
                    echo "Deploy to Google Cloud Run"
                    withCredentials([file(credentialsId: 'gcp-credentials-id', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh "gcloud run deploy react-app --image ${IMAGE_NAME}:${env.BUILD_ID} --region ${REGION} --platform managed --allow-unauthenticated --project ${PROJECT_ID}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Cleans workspace after build
        }
    }
}
