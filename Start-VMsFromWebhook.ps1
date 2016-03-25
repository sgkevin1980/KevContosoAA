workflow Start-VMsFromWebhook
{
	param(
		[object] $WebhookData
	)
	#If runbook was called from webhook, webhookdata should not be null.
	if($WebhookData -ne $null){
		#Collect properties of webhookdata object
		$WebhookName = $WebhookData.WebhookName
		$WebhookHeader = $WebhookData.RequestHeader
		$WebhookBody = $WebhookData.RequestBody
		
		#Collect individual headers. VMList converted from Json
		$From = $WebhookHeader.from
		$VMList = convertFrom-Json -InputObject $WebhookBody
		Write-output "Runbook started from webhook $WebhookName by $From"
		
		$Cred = Get-AutomationPSCredential -Name "KevContosoAA"
		Add-AzureAccount -Credential $Cred
		
		Foreach ($VM in $VMList){
			Write-output "Starting $VM.Name"
			Start-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName
		}
	}else{
		Write-Error "Runbook meant to be started only from a webhook."
	}
}