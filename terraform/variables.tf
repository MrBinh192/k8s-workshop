variable "client_id" {
    description = "This is your Azure Service Provider ID. If you need to create one, ask subscription Owner/User Access Admin"
}
variable "subscription_id" {
    description = "Your subscription AD"
}
variable "tenant_id" {
  description = "Tenant ID (Your Azure AD id)"
}
variable "client_secret" {
    description = "This is your Azure Service Provider ID. If you need to create one, ask subscription Owner/User Access Admin"
}

variable "agent_count" {
    default = 2
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable location {
    default = "West Europe"
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "westeurope"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}