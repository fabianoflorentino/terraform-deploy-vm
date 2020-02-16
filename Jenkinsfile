pipeline {
	agent {
        any {}
	}
	stages {
        stage ('Configure connect for access provider') {
            steps {
                script {
                    tfProvider = """
# Managed by Jenkins
provider "${env.PROVIDER}" {
    vsphere_server       = "${env.PROVIDER_SRV}"
    user                 = "${env.PROVIDER_USR}"
    password             = "${env.PROVIDER_PSW}"
    allow_unverified_ssl = true
    version              = "1.15.0"
}
"""
                }
                writeFile file: "./provider.tf", text: tfProvider.trim()
            }
        }
        stage ('Configuration to instances') {
            steps {
                script {
                    tfVms = """
# Managed by Jenkins
variable "name_new_vm" {
    description = "Input a name for Virtual Machine Ex. new_vm"
    default     = "${env.NAME_NEW_VM}"
}
variable "vm_count" {
    description = "Number of instaces"
    default     = "${env.VM_COUNT}"
}

variable "num_cpus" {
    description = "Amount of vCPU's"
    default     = "${env.NUM_CPUS}"
}

variable "num_mem" {
    description = "Amount of Memory"
    default     = "${env.NUM_MEM}"
}

variable "size_disk" {
  default = "\$TF_VAR_size_disk"
}
"""
                }
                writeFile file: "./vms.tf", text: tfVms.trim()
            }
        }
		stage ('Bootstrap Terraform') {
			steps {
				script {
                    sh "export TF_VAR_size_disk=${env.SIZE_DISK} \
                    && echo \$TF_VAR_size_disk \
                    /var/jenkins_home/extras/terraform init"
					sh '/var/jenkins_home/extras/terraform plan -out deploy.tfplan'
				}
			}
		}
        stage ('Deploy VM') {
            steps {
                script {
                   if ("${env.TF_STATE}" == "APPLY") {
                        timeout(time: 3, unit: "MINUTES") {
                            input(id: 'chooseOptions', message: 'Do you want to create?', ok: 'Confirm')
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
                            input(id: 'chooseOptions', message: 'Do you want to destroy?', ok: 'Confirm')
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