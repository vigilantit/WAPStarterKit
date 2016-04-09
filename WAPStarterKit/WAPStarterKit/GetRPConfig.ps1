#
# GetRPConfig.ps1
#
class rp
{
[string]$rpname
[string]$URI
}

Class GetResourceProviders
{
[array]$RP
GetResourceProviders()
{
$this.rp=Get-MgmtSvcResourceProviderConfiguration | foreach {$resp = [rp]::new(); $resp.rpName = $_.Name; $resp.URI =$_.AdminEndPoint.ForwardingAddress.AbsoluteUri; $resp} 
}
}
$res = [GetResourceProviders]::new()
$res