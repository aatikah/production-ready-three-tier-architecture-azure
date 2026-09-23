variable "subscription_id" {
  description = "Azure subscription ID used for deployment."
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region for the deployment."
  type        = string
  default     = "West US 2"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "prod"
}

variable "vnet_cidr" {
  description = "CIDR range for the Azure VNet."
  type        = string
  default     = "10.20.0.0/16"
}

variable "web_subnet_cidr" {
  description = "CIDR range for the web subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR range for the app subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the delegated PostgreSQL subnet."
  type        = string
  default     = "10.20.3.0/24"
}

variable "admin_cidr" {
  description = "Trusted CIDR allowed to SSH to the VMs. Use a fixed /32 where possible."
  type        = string
  default     = "203.0.113.0/24"
}

variable "admin_username" {
  description = "Local administrator username for the Linux VMs."
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key contents installed on the Linux VMs."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Azure VM size for web and app tiers."
  type        = string
  default     = "Standard_D2als_v7"
}

variable "postgres_version" {
  description = "PostgreSQL major version supported by Flexible Server."
  type        = string
  default     = "16"
}

variable "postgres_sku" {
  description = "Flexible Server SKU."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL Flexible Server. Supply through a protected tfvars file or CI/CD secret."
  type        = string
  sensitive   = true
  nullable    = false
}
