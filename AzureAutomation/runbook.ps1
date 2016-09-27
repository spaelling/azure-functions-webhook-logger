param(
    [object]$WebhookData
)

$WebhookName = $WebhookData.WebhookName
$RequestBody = $WebhookData.RequestBody
$RequestHeader = $WebhookData.RequestHeader

"Webhook name: $($WebhookName)"
"Webhook body: $($RequestBody)"
"Webhook header: $($RequestHeader)"

$connectionName = "AzureRunAsConnection"
try
{
   # Get the connection
   $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

   "Logging in to Azure..."
   Add-AzureRmAccount `
     -ServicePrincipal `
     -TenantId $servicePrincipalConnection.TenantId `
     -ApplicationId $servicePrincipalConnection.ApplicationId `
     -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint | Out-Null
   "Setting context to a specific subscription"  
   Set-AzureRmContext -SubscriptionId $servicePrincipalConnection.SubscriptionId | Out-Null
}
catch {
    if (!$servicePrincipalConnection)
    {
       $ErrorMessage = "Connection $connectionName not found."
       throw $ErrorMessage
     } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
     }
}

# https://www.powershellgallery.com/packages/AzureRM.KeyVault/2.1.0
Import-Module -Name "AzureRM.KeyVault"
$tenantId        = (Get-AzureKeyVaultSecret -VaultName webhooks -Name tenantId -ErrorAction Stop).SecretValueText
$appPrincipalId  = (Get-AzureKeyVaultSecret -VaultName webhooks -Name weblogAppPrincipalId -ErrorAction Stop).SecretValueText
$appPrincipalKey = (Get-AzureKeyVaultSecret -VaultName webhooks -Name weblogAppPrincipalKey -ErrorAction Stop).SecretValueText
$WebhookURI      = (Get-AzureKeyVaultSecret -VaultName webhooks -Name weblogwebhookuri -ErrorAction Stop).SecretValueText

<#
"$tenantId"
"$appPrincipalId"
"$appPrincipalKey"
"$WebhookURI"
#>

$Hash = @{}
foreach($Pair in $RequestBody.Split("&"))
{
    $Name, $Value = $Pair.Split("=")
    $Hash[$Name] = $Value
}

$postParams = @{
    tenantId = $tenantId
    appPrincipalId = $appPrincipalId
    appPrincipalKey = $appPrincipalKey
    OMSLogAnalyticsPayload = @(
        @{
            Text = $Hash.text
            ChannelName = $Hash.channel_name
            UserName = $Hash.user_name
            Token = $Hash.token
        }
    )
}

$Response = Invoke-WebRequest -Uri $WebhookURI -Method POST -Body ($postParams | ConvertTo-Json) -ContentType "application/json" -UseBasicParsing | Select-Object -ExpandProperty Content
"Response`n$Response"