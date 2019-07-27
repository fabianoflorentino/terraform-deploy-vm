# Configure the vSphere Provider
provider "vsphere" {
  vsphere_server       = "192.168.0.108"
  user                 = "fabiano"
  password             = "@1234qwer"
  allow_unverified_ssl = true
}
