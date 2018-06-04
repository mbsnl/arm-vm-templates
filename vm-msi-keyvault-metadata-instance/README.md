# Windows VM with MSI (Managed Service Identity) enabled, together with a KeyVault where the VM MSI has access

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmbsnl%2Fvm-msi-keyvault-metadata-instance%2Finitial%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmbsnl%2Fvm-msi-keyvault-metadata-instance%2Finitial%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to deploy a Windows VM with MSI (Managed Service Identity) enabled, together with a KeyVault where the VM MSI has access. Prerequisite is that a VNet already has been created.

In the _**script**_ directory you will find a PowerShell script that will:
- Retreive the VM Tags to determine the name of the KeyVault using the Metadata Instance Endpoint (the template deployment sets a Tag named: keyvaultName)
- Retreive an oauth2 access_token for KeyVault (vault.azure.com) using the Metadata Instance Endpoint (on 4-Jun-2018 this was still in Preview)
- Upload a secret value to the KeyVault