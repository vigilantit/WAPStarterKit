#
# GetRPConfig.ps1
#
class rp
{
[string]$rpname
[string]$URI
[string]$AdminUser
}

Class GetResourceProviders
{
[array]$RP
GetResourceProviders()
{
$this.rp=Get-MgmtSvcResourceProviderConfiguration | foreach {$resp = [rp]::new(); $resp.rpName = $_.Name; $resp.URI =$_.AdminEndPoint.ForwardingAddress.AbsoluteUri; $resp.AdminUser = $_.adminendpoint.authenticationusername; $resp} 
}
}
$res = [GetResourceProviders]::new().rp
$res