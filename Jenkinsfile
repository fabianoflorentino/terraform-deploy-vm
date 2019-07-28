def def_name_new_vm = "${env.NAME_NEW_VM}"
def def_vm_count    = "${env.VM_COUNT}"
def def_num_cpus    = "${env.NUM_CPUS}"
def def_num_mem     = "${env.NUM_MEM}"
def tfCodeFilePath  = "./vms.tf"

pipeline {
	agent { 
        any {} 
	}
	stages {
        stage ('Write Custom .tf') {
            steps {
                script {
                    tfCode = """
                        variable "name_new_vm" {
                            description = "Input a name for Virtual Machine Ex. new_vm"
                            default     = "${def_name_new_vm}"
                        }
                        variable "vm_count" {
                            description = "Number of instaces"
                            default     = "${def_vm_count}"
                        }

                        variable "num_cpus" {
                            description = "Amount of vCPU's"
                            default     = "${def_num_cpus}"
                        }

                        variable "num_mem" {
                            description = "Amount of Memory"
                            default     = "${def_num_mem}"
                        }
                    """
                }
                writeFile file: tfCodeFilePath, text: tfCode
            }
        } 
		stage ('Bootstrap Terraform') {
			steps {
				script {
					sh '/usr/local/bin/terraform init'
					sh '/usr/local/bin/terraform plan -out deploy.tfplan'
				}
			}
		}
        stage ('Deploy New VM') {
            steps {
                script {
                   if ("${env.TF_STATE}" == "APPLY") {
                        timeout(time: 3, unit: "MINUTES") {
                            input(id: 'chooseOptions', message: 'Do you want to create?', ok: 'Confirm')
                            script {
                                sh '/usr/local/bin/terraform apply deploy.tfplan'
                            }
                        }
                    } 
                }
            }
        }
        stage ('Destroy New VM') {
            steps {
                script {
                   if ("${env.TF_STATE}" == "DESTROY") {
                        timeout(time: 3, unit: "MINUTES") {
                            input(id: 'chooseOptions', message: 'Do you want to destroy?', ok: 'Confirm')
                            script {
                                sh '/usr/local/bin/terraform destroy -auto-approve'
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