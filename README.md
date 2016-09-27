# azure-functions-webhook-logger
Processes webhook calls and registers an event in OMS log analytics

# Setup

Will need the following resources in Azure
- Resource Group
- Automation Account
- Key Vault
- Function App
 - App Service
 - App Service Plan (can use existing).
- OMS workspace

Other resources needed is a Github account. 

## Github
Fork this repository and integrate it with the *Function App*. See [Hello Azure Functions - Integrating with Github](https://codebeaver.blogspot.dk/2016/09/hello-azure-functions-integrating-with.html) for help.

## Resource group

I recommend creating a new resource group for this purpose alone.

## Automation Account

Details on how to setup is found [here](./AzureAutomation/README.md).

## Key Vault

The Azure Automation service principal must be added to the *access policies* in the Key vault and have at least *get* in the *secret permissions*.

## Function App

This requires an **app service plan* which is the only resource that is ok reusing an existing one. If not, a free one (shared tier) is available which is fine for this purpose.