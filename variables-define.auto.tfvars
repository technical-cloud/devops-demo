subscription_id = "3e2430ff-cf25-44b4-a264-a1fe5d99c39e"
tenant_id       = "702c8df7-5670-48f3-babc-3053e78a82f9"
client_id       = "2694799d-8ec2-46e4-ae11-a59937e4dd5f"
client_secret   = "Nnu8Q~mJgFQVm1b2gxZeha0_XCWH3LjcsILXga-."
region          = "eastus"
rgname          = "vipin-demo-resource-group"
vnetname        = "vipin-demo-vnet"
vnetaddr        = ["10.10.0.0/16"]
subnetname      = ["vipin-subnet-1"]
subnetaddr      = ["10.10.10.0/24"]
nicname         = "vipin-demo-nic"
org_url        = "https://dev.azure.com/vadapavsamosa/user19"
agent_pool     = "vadapav"
ado_pat = "8ZKfOrj4vWgA3AjeB5FOEF9VuiuWGCrTzJtmBvPViYqrerbDhYCCJQQJ99BJACAAAAAp9R4wAAASAZDO2obe"
#personal_access_token = "4sSzdH4CFyJWp3nSSoCWfiYaUotF4sZqlSu4tihSHTL5mgaHsbZPJQQJ99BJACAAAAAp9R4wAAASAZDO4fO3"
nsgrules = [{ "rulename" = "sshrule", "priority" = "100", "dport" = "22", "protocol" = "Tcp" },
  { "rulename" = "httprule", "priority" = "101", "dport" = "80", "protocol" = "Tcp" },
  { "rulename" = "httpsrule", "priority" = "102", "dport" = "443", "protocol" = "Tcp" },
  { "rulename" = "dbrule", "priority" = "103", "dport" = "3306", "protocol" = "Tcp" }
]