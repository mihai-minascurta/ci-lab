pipeline {
  agent any

  environment {
    IMAGE_NAME = "ci-lab-image"
    CONTAINER_NAME = "ci-lab1"
    URL = "http://127.0.0.1:5050/health"
  }

  stages {
    stage('Build docker image') {
      steps {
        sh "docker build -t $IMAGE_NAME ."
      }
    }

    stage('Run container') {
      steps {
        sh """
          echo "Removing old containers if exists.."
          docker rm -f $CONTAINER_NAME >/dev/null 2>&1 || true
        """
        sh "docker run -d --name $CONTAINER_NAME -p 5050:5050 $IMAGE_NAME"
        sh "sleep 5"
      }
    }

    stage('Healthcheck'){
      steps {
        sh """
          STATUS_CODE=\$(curl -s -o /dev/null -w "%{http_code}" "$URL") || STATUS_CODE="000"
          if [ "\$STATUS_CODE" = "200" ]; then
            echo "The request was send successfully with status code 200"
            exit 0
          fi
          echo "The request was FAILED"
          exit 1
        """
      }
    }
  }

  post {
    always {
      echo "Container was destroyed"
      sh "docker rm -f $CONTAINER_NAME >/dev/null 2>&1 || true"
    }
  }
}
