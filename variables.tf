variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "adhoc-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vm_sku" {
  description = "The size of the Azure Linux VM"
  type        = string
  default     = "Standard_B1s"  # Free Tier eligible
}


variable "admin_username" {
  description = "Admin username for Linux VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Path to your SSH public key"
  type        = string
  default     = "/home/lakunzy/.ssh/id_rsa.pub"
}