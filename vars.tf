#
# Variables with default values, alter according to the your environment.
#
variable "data_center" {
  default = "ha-datacenter"
}

variable "data_store" {
  default = "vol1"
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
  default = "iso/custom-centos7-size-disk-min45GB-v1.iso"
}
