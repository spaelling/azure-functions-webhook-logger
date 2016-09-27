# Azure Automation Runbook

Import or copy+paste the code from runbook.ps1 into an Azure Automation Runbook. It is recommended to create a brand new automation account and create a service principal (run as account) along with it as this is used to authenticate against Azure Keyvault.

You must also import the latest [AzureRM.KeyVault module](https://www.powershellgallery.com/items?q=AzureRM.KeyVault).