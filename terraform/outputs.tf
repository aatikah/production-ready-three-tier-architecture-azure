output "resource_group_name" {
  description = "Azure resource group name."
  value       = azurerm_resource_group.main.name
}

output "load_balancer_public_ip" {
  description = "Public IPv4 address of the Azure Load Balancer."
  value       = azurerm_public_ip.load_balancer.ip_address
}

output "web_private_ips" {
  description = "Private IP addresses of the web VMs."
  value       = azurerm_network_interface.web[*].private_ip_address
}

output "app_private_ips" {
  description = "Private IP addresses of the app VMs."
  value       = azurerm_network_interface.app[*].private_ip_address
}

output "postgres_fqdn" {
  description = "Private FQDN of Azure Database for PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}
