# Configure the vSphere Provider
provider "vsphere" {
  vsphere_server       = "esxi-node-1.br.horto.local"
  user                 = "fabiano"
  password             = "@1234qwer"
  allow_unverified_ssl = true
}
