#
# Script.ps1
#
Class WapConStrings
{
	[string]$AdminAPI
	[string]$AdminAuth
	[string]$AdminURI
	[string]$TenantAPI
	[string]$TenantAuth
	[string]$TenantURI
	[string]$AdmimClientRealm
	WapConStrings([string]$ComputerName)
	{

	}
}

$wap=[WapConStrings]::new()
