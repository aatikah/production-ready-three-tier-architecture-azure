# Azure Three-Tier Equivalent

This folder maps the AWS three-tier deployment to Azure using Terraform and the `azurerm` provider.

## Contents

- `aws-to-azure-mapping.md` maps the AWS services to Azure equivalents.
- `COMPARISON.md` compares the platforms and gives a recommendation.
- `terraform/` contains the Azure infrastructure code.

## Prerequisites

- Azure CLI authenticated with `az login`
- Terraform 1.6 or later
- An Azure subscription and a region with Availability Zone support
- An existing SSH public key file

## Deploy

```powershell
cd azure/terraform
terraform init
terraform fmt
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

You do not need to create or commit a `terraform.tfvars` file. Terraform also reads variables from `TF_VAR_*` environment variables. For example, this PowerShell flow uses the currently selected Azure CLI subscription, your local SSH key, and a concealed password prompt:

```powershell
$env:TF_VAR_subscription_id = az account show --query id --output tsv
$env:TF_VAR_ssh_public_key = (Get-Content "$HOME\.ssh\id_ed25519.pub" -Raw).Trim()
$securePassword = Read-Host "PostgreSQL admin password" -AsSecureString
$passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
	$env:TF_VAR_postgres_admin_password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
}
finally {
	[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
}

terraform plan -out tfplan
terraform apply tfplan
```

The required variables are:

- `subscription_id`
- `ssh_public_key`
- `postgres_admin_password`

`admin_username`, `admin_cidr`, and the other optional settings use the defaults in `terraform/variables.tf`. You can override any of them with another `TF_VAR_*` environment variable or a `-var` argument. Clear sensitive environment variables when finished:

```powershell
Remove-Item Env:TF_VAR_subscription_id, Env:TF_VAR_ssh_public_key, Env:TF_VAR_postgres_admin_password
```

The database uses private access and is not publicly reachable. The sample Linux VMs install Nginx and Node.js through `custom_data`; use a proper image or deployment pipeline for production applications.

## Test

After deployment, retrieve the load balancer public IP:

```powershell
$ip = terraform output -raw load_balancer_public_ip
Invoke-WebRequest "http://$ip/" | Select-Object -ExpandProperty Content
```

The response should come from the web tier. Test the app tier from a web VM or through an application-specific route after adding the application deployment. The Azure Load Balancer in this baseline exposes port 80 only and does not provide Layer 7 path routing.

## Cleanup

```powershell
terraform destroy
```

Destroying the resource group removes the deployed Azure resources and can incur charges until cleanup completes.
