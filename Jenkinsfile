node{
  
	stage('SCM Checkout'){
       git credentialsId: 'git-credentials', url: 'https://github.com/kctechnologies/DockerHubJenkinsIntegration', branch: 'development'
   }

   stage('Maven Packaging'){
     def mvnHome = tool name: 'maven-3', type: 'maven'
     def mvnCMD = "${mvnHome}/bin/mvn"
     sh "${mvnCMD} clean package"
   }

   stage('Building docker image'){
     sh 'docker build -t kctechnologies/docker-jenkins:1.0.0 .'
   }
    stage('Pushing docker image to docker hub'){
     withCredentials([string(credentialsId: 'docker-passwd', variable: 'dockerHubPasswd')]) {
        sh "docker login -u kctechnologies -p ${dockerHubPasswd}"
     }
     sh 'docker push kctechnologies/docker-jenkins:1.0.0'
   }
   stage('Removing old containers if any'){
	try{
		def dockerRemove = 'docker rm -f docker-jenkins'
		sshagent(['remote-server']) {
		sh "ssh -o StrictHostKeyChecking=no ec2-user@172.22.16.194 ${ dockerRemove }"
		}
	}catch(error){
		//  write the exception handling code here like sending notification.
	}
 }

   stage('Running docker container on remote server'){
     def runCommand = 'docker run -p 8080:8080 -d --name docker-jenkins kctechnologies/docker-jenkins:1.0.0'
     sshagent(['remote-server']) {
       sh "ssh -o StrictHostKeyChecking=no ec2-user@172.22.16.194 ${runCommand}"
     }
   }

}
