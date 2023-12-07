terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0.0"
    }
  }
}

# secret variables encrypted using sops in secrets.auto.tfvars.json
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = "./oci.pem" # key is encrypted using sops
  region           = "us-phoenix-1"
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  name           = "compartment01"
  description    = "The root Compartment of the tenancy"
}

resource "oci_core_virtual_network" "vcn" {
  compartment_id = oci_identity_compartment.compartment.id
  cidr_block     = "10.0.0.0/16"
  display_name   = "vcn-20210515-1507"
}

resource "oci_core_subnet" "subnet" {
  cidr_block     = "10.0.1.0/24"
  vcn_id         = oci_core_virtual_network.vcn.id
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "subnet01"
}

resource "oci_core_instance" "vm_instance" {
  count        = 3
  display_name = format("oracle%02d", count.index + 1)

  # Create 2 free x86 VMs & 1 free Arm VM
  shape = count.index == 2 ? "VM.Standard.A1.Flex" : "VM.Standard.E2.1.Micro"
  availability_domain = "TMcl:PHX-AD-2"
  compartment_id      = oci_identity_compartment.compartment.id

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_ed25519.pub")
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet.id
  }
}

output "vm_public_ips" {
  value = oci_core_instance.vm_instance[*].public_ip
}
