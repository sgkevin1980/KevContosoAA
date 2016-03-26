workflow New-ContosoADUser
{
	param(
		[Parameter(Mandatory=$true)]
		[string] $User,
		[Parameter(Mandatory=$true)]
		[string] $Password
	)
	
	$DC = Get-AutomationVariable -Name 'ContosoDC'
	$PSUserCred = Get-AutomationPSCredential -Name 'Contoso_DomainAdmin'
	
	InlineScript{
		$UserName = $using:User
		$Pass = $using:Password
		$SecPass = ConvertTo-SecureString $Pass -AsPlainText -Force
		
		$NewUser = New-ADUser -Name $UserName -AccountPassword $SecPass -PasswordNeverExpires $true -Enabled $true
		Get-ADUser -Identity $UserName
	}-PsComputerName $DC -PsCredential $PSUserCred	
}