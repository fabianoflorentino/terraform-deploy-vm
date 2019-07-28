#
# Variables with default values, alter according to the your environment.
#
variable "data_center" {
  default = "ha-datacenter"
}

variable "data_store" {
  default = "vmdt-1"
}

variable "mgmt_lan" {
  default = "VM Network"
}

variable "net_adapter_type" {
  default = "vmxnet3"
}

variable "guest_id" {
  default = "centos7_64Guest"
}
variable "custom_iso_path" {
  default = "iso_images/custom-centos7-v7.iso"
}
