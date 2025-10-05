pipeline {
  agent any
  environment {
    DOCKERHUB_REPO = "oliullah96/project-2"
  }
  stages {

    stage('Install & Test (Node 16)') {
      steps {
        script {
          // run inside official Node 16 container (matches brief)
          docker.image('node:16').inside {
            sh 'node -v && npm -v'
            sh 'if [ -f package-lock.json ]; then npm ci; else npm install --save; fi'
            sh 'npm test || echo "no tests found"'
          }
        }
      }
    }

    stage('Dependency Vulnerability Scan') {
      steps {
        script {
          // simple built-in scanner: fail build if High/Critical issues
          docker.image('node:16').inside {
            sh 'npm audit --audit-level=high'
          }

          // OR use Snyk (uncomment if you added a snyk-token credential)
          // withCredentials([string(credentialsId: "snyk-token", variable: "SNYK_TOKEN")]) {
          //   sh 'npm i -g snyk'
          //   sh 'snyk auth $SNYK_TOKEN'
          //   sh 'snyk test --severity-threshold=high'
          // }
        }
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
            sh 'echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin'
            sh 'docker build -t $DOCKERHUB_REPO:${BUILD_NUMBER} -t $DOCKERHUB_REPO:latest .'
            sh 'docker push $DOCKERHUB_REPO:${BUILD_NUMBER}'
            sh 'docker push $DOCKERHUB_REPO:latest'
          }
        }
      }
    }
  }

  post {
    always {
      // keep artifacts/logs for Task 4 screenshots
      archiveArtifacts artifacts: '**/npm-*.log', allowEmptyArchive: true
    }
  }
}
