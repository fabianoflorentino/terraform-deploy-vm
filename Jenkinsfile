pipeline {
	agent {
        any {}
	}
	stages {
		stage ('Bootstrap Terraform') {
			steps {
				script {
                    withCredentials([string(credentialsId: 'PROVIDER_USR', variable: 'PROVIDER_USR'), string(credentialsId: 'PROVIDER_PSW', variable: 'PROVIDER_PSW')]) {
                        sh "export TF_VAR_provider_address=${env.PROVIDER_SRV} \
                        && export TF_VAR_provider_user=${env.PROVIDER_USR} \
                        && export TF_VAR_provider_password=${env.PROVIDER_PSW} \
                        && export TF_VAR_name_new_vm=${env.NAME_NEW_VM} \
                        && export TF_VAR_vm_count=${env.VM_COUNT} \
                        && export TF_VAR_num_cpus=${env.NUM_CPUS} \
                        && export TF_VAR_num_mem=${env.NUM_MEM} \
                        && export TF_VAR_size_disk=${env.SIZE_DISK} \
                        && /var/jenkins_home/extras/terraform init \
    					&& /var/jenkins_home/extras/terraform plan -out deploy.tfplan"
                    }
				}
			}
		}
        stage ('Deploy VM') {
            steps {
                script {
                   if ("${env.TF_STATE}" == "APPLY") {
                        timeout(time: 3, unit: "MINUTES") {
                            input(id: 'chooseOptions', message: 'Criar a maquina virtual?', ok: 'Confirmar')
                            script {
                                sh '/var/jenkins_home/extras/terraform apply deploy.tfplan'
                            }
                        }
                    }
                }
            }
        }
        stage ('Destroy VM') {
            steps {
                script {
                   if ("${env.TF_STATE}" == "DESTROY") {
                        timeout(time: 3, unit: "MINUTES") {
                            input(id: 'chooseOptions', message: 'Destruir a maquina virtual?', ok: 'Confirmar')
                            script {
                                sh '/var/jenkins_home/extras/terraform destroy -auto-approve'
                            }
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