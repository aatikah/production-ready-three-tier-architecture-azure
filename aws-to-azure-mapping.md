# AWS to Azure Service Mapping

| AWS service | Azure equivalent | Key difference |
| --- | --- | --- |
| VPC | Azure Virtual Network (VNet) | Both provide isolated private networking, but Azure subnets are first-class VNet resources and commonly use explicit service endpoints, delegations, and route tables. |
| EC2 | Azure Virtual Machines | Both provide IaaS compute; Azure VM networking is commonly split across a NIC, NSG, public IP, and subnet resources. |
| ALB | Azure Standard Load Balancer | AWS ALB is an application-layer HTTP load balancer with listeners and path routing; Azure Standard Load Balancer is primarily Layer 4 TCP/UDP, so HTTP behavior is represented with probes and rules here. Azure Application Gateway would be the closer Layer 7 equivalent. |
| RDS for PostgreSQL | Azure Database for PostgreSQL Flexible Server | Both are managed PostgreSQL services; Azure Flexible Server uses delegated subnets and private DNS for private access, while RDS uses DB subnet groups and VPC security groups. |
| Security Groups | Network Security Groups (NSGs) | AWS security groups are stateful interfaces/subnet controls; Azure NSGs are stateful rule collections associated with NICs or subnets. This implementation associates one NSG with each tier subnet. |
| NAT Gateway | Azure NAT Gateway | Both provide outbound-only internet access for private resources; Azure NAT Gateway is attached to one or more subnets and uses public IP resources or prefixes. |
| IAM Roles | Azure Managed Identities | AWS roles are assumed through instance profiles; Azure managed identities are attached directly to resources and obtain Entra ID tokens without stored credentials. |
| Secrets Manager | Azure Key Vault | Azure Key Vault provides the closest managed secret store and integrates with managed identities for passwordless access. |
| Availability Zones | Azure Availability Zones | Both spread resources across physically separate datacenters within a region, but zone support and SKU availability vary by Azure region and resource. |

## Architecture translation

- A single Azure VNet replaces the AWS VPC.
- Web, app, and database subnets replace the corresponding private AWS subnet tiers.
- The public Standard Load Balancer distributes TCP port 80 traffic to web VMs.
- Web VMs are allowed to reach app VMs on port 3000.
- App VMs are allowed to reach PostgreSQL Flexible Server on port 5432.
- PostgreSQL Flexible Server is deployed with private access in the delegated database subnet and linked to a private DNS zone.
- Azure NAT Gateway provides outbound connectivity for the private web and app subnets.
- The Terraform includes Linux VM extensions only through `custom_data`; production workloads should use images or a deployment pipeline rather than embedding application code in Terraform.
