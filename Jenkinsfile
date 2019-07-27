pipeline {
	agent {
		any
	}
	stages {
		stage('Deploy VM') {
      steps {
      	scripts {
	  sh 'terraform init'
	  sh 'terraform plan'
	  sh 'terraform apply'
     	}
      }
    }
  }
	post {
  	success {
    	slackSend (
      	color: '#088A29', 
        message: ":white_check_mark: SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
    failure {
    	slackSend (
      	color: '#DF0101', 
        message: ":rotating_light: FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
  }
}
