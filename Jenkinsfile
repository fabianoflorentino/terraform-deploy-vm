pipeline {
	agent { 
        any {} 
	}
	stages {
		stage('Bootstrap Terraform') {
			steps {
				script {
					sh '/usr/local/bin/terraform init'
					sh '/usr/local/bin/terraform plan -out deploy.tfplan'
				}
			}
		}
        stage ('Deploy New VM') {
            steps {
				timeout(time: 3, unit: "MINUTES") {
                    input(id: 'chooseOptions', message: 'Do you want to create?', ok: 'Confirm')
                    script{
                        if (${env.TF_STATE} == "APPLY"){
                            sh '/usr/local/bin/terraform apply deploy.tfplan'
                        }
                    }
                }
            }
        }
        stage ('Destroy Infraestructure') {
            steps {
				timeout(time: 3, unit: "MINUTES") {
                    input(id: 'chooseOptions', message: 'Do you want to destroy?', ok: 'Confirm')
                    script{
                        if (${env.TF_STATE} == "DESTROY"){
                            sh '/usr/local/bin/terraform apply deploy.tfplan'
                        }
                    }
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