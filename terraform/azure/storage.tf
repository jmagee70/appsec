resource "azurerm_storage_account" "test_blob" {
  name                          = var.st.name
  resource_group_name           = var.rg_shared_name
  location                      = var.rg_shared_location
  account_tier                  = var.st.tier
  account_replication_type      = var.st.replication
  public_network_access_enabled = true
  tags = {
    yor_trace = "8a7102ec-03b4-47f3-b8f5-d3bb89cd5e5b"
  }
}