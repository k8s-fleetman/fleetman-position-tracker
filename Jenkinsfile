pipeline {
   agent any

   environment {
     // You must set the following environment variables
     // ORGANIZATION_NAME
     // YOUR_DOCKERHUB_USERNAME (it doesn't matter if you don't have one)

     SERVICE_NAME = "fleetman-position-tracker"
     REPOSITORY_TAG="${DOCKERHUB_URL}/${SERVICE_NAME}:${BUILD_ID}"
   }

   stages {
      stage('Preparation') {
         steps {
            cleanWs()
            git credentialsId: 'GitHub', url: "https://github.com/${ORGANIZATION_NAME}/${SERVICE_NAME}"
         }
      }
      stage('Build') {
         steps {
            sh '''mvn clean package'''
         }
      }

      stage('SonarQube') {
         steps {
            sh '''mvn sonar:sonar -Dsonar.projectKey=fleetman-position-tracker -Dsonar.host.url=http://sonarqube.eqslearning.com:9000 -Dsonar.login=a8a4647149103773dd31b05edb048b4cae6793c9'''
         }
      }
      stage('Build Image') {
         steps {
           sh 'scp -r ${WORKSPACE} jenkins@${DOCKER_HOST_IP}:/home/jenkins/docker/${BUILD_ID}'
           sh 'ssh jenkins@${DOCKER_HOST_IP} docker image build -t ${REPOSITORY_TAG} /home/jenkins/docker/${BUILD_ID}'
           sh 'ssh jenkins@${DOCKER_HOST_IP} docker image ls'
           sh 'ssh jenkins@${DOCKER_HOST_IP} rm -rf /home/jenkins/docker/${BUILD_ID}'
         }
      }
      stage('Push Image to repo') {
          steps {
           sh 'ssh jenkins@${DOCKER_HOST_IP} docker push ${REPOSITORY_TAG}'
          }
      }
      stage('Deploy to Cluster') {
          steps {
            //sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
            sh 'cat deploy.yaml'
            sh """sed -i 's+REPOSITORY_TAG+'"${REPOSITORY_TAG}"'+' deploy.yaml"""
            sh 'cat deploy.yaml'
            sh 'kubectl apply -f deploy.yaml'
          }
      }
   }
}
