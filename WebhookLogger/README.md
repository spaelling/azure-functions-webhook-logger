# Webhook Logger

Describes the webhook logger code for an Azure Functions App function.

## function.json

Most of the content in this file is set in stone for this particular use. The `name` can be changed how you like and describes the name of the PowerShell variable for input and output. The input is written to a file, and output is also written to a file. The variable contains the path to that file.

I am not entirely sure, but the method can be both *POST* and *GET*. To me it made most sense to have it as a *POST* as I am not really returning any data (of consequence).

## run.ps1

This code is automatically imported into an Azure Functions App function. The file must be named run.ps1 in order for this to work.

This is the code that is run when someone makes a *POST* to the webhook that is generated.

The webhook is called:

``
Invoke-WebRequest -Uri $WebhookURI -Method POST -Body ($postParams | ConvertTo-Json) -ContentType "application/json" -UseBasicParsing``
