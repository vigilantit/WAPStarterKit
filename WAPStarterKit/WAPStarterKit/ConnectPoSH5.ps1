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
	[string]$TenantPublicAPI
	[string]$AdmimClientRealm
	WapConStrings()
	{
	Import-Module -Name MgmtSvcAdmin
	Import-Module -Name MgmtSvcConfig

	# Get the AdminSiteURL
	$this.AdminAPI = (Get-MgmtSvcEndpoint | where {$_.Name -eq "AdminAPI"}).Address
	
	# Get the AuthenticateSiteUrl
	$this.AdminAuth = "https://{0}/" -f ([System.Uri](get-mgmtsvcendpoint -namespace "WindowsAuthSite" | where {$_.name -eq 'PassiveRequestorAddress'}).Address).Authority
	
	# Get the ClientRealmUrl
	$this.AdminClientRealm = (ConvertFrom-Json -InputObject (Get-MgmtSvcDatabaseSetting -Namespace "AdminAPI" -ConnectionString (get-mgmtsvcsetting -Namespace "AdminAPI" | where {$_.Name -eq 'ManagementStore'}).Value | where {$_.Name -eq 'Authentication.RelyingParty.Secondary'}).Value).Realm

	# Get the TenantSiteURL
	$this.TenantAPI = (Get-MgmtSvcEndpoint | where {$_.Name -eq "TenantAPI"}).Address

	# Get the TenantPublicAPI
	$this.TenantPublicAPI = (Get-MgmtSvcEndpoint | where {$_.Name -eq "TenantPublicAPI"}).Address

	# Get the TenantURI
	$this.TenantURI = (get-mgmtsvcendpoint -namespace "TenantSite" | where {$_.name -eq 'CallbackAddress'}).Address

	# Get the AdminURI
	$this.AdminURI = (get-mgmtsvcendpoint -namespace "AdminSite" | where {$_.name -eq 'CallbackAddress'}).Address

	# Get the TenantAuthSite
	$this.TenantAuth = "https://{0}/" -f ([system.uri](get-mgmtsvcendpoint -namespace "AuthSite" | where {$_.name -eq 'PassiveRequestorAddress'}).Address).Authority
	}
}

$wap=[WapConStrings]::new()
