#   Basics
company     = "Example"
environment = "Production"
location    = "westeurope"

#   HUB-shared Virtual Network
name_hub                        = "shared"
network_address_space_hub       = "10.0.0.0/22"

#   Spoke(s) Virtual Network(s) with default route to firewall
name_spoke                              = ["example1", "example2"]
network_address_space_spoke             = ["10.100.0.0/22", "10.110.0.0/22"]
spoke_endpoint_subnet_name              = "snet-endpoints"
spoke_privatelinkendpoints_subnet_name  = "snet-privatelinkendpoints"

#   Azure Firewall
network_address_space_firewall  = ["10.0.1.0/24"]