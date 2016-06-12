# query SQL function
function Invoke-SQL {
    param([string] $connstring,[string] $sqlCommand)
    $connectionString = $connstring
    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null
    $connection.Close()
    $dataSet.Tables
}

# get WAP connection string
$connstring = (Get-MgmtSvcSetting -Namespace adminsite | where {$_.name -eq 'ApplicationServicesConnectionstring'}).value
$connstring = $connstring.Split(';')[0] + ';' + $connstring.Split(';')[1] + "; Integrated Security=SSPI"

# get WAP websites
$adminsite = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'AdminSite' and Name = 'Authentication.Fqdn'" -connstring $connstring).value
$TenantSite = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'TenantSite' and Name = 'Authentication.Fqdn'" -connstring $connstring).value
$AuthSite = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'AuthSite' and Name = 'Authentication.Fqdn'" -connstring $connstring).value
$windowsauthsite = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'WindowsAuthSite' and Name = 'Authentication.Fqdn'" -connstring $connstring).value
$AdminAPI = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'AdminSite' and Name = 'Microsoft.Azure.Portal.Configuration.OnPremPortalConfiguration.RdfeAdminUri'" -connstring $connstring).value
$TenantAPI = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'TenantSite' and Name = 'Microsoft.Azure.Portal.Configuration.AppManagementConfiguration.RdfeUnifiedManagementServiceUri'" -connstring $connstring).value
$ClientRealm = (Invoke-SQL -sqlCommand "SELECT value FROM [Config].[Settings] where Namespace = 'AdminSite' and Name = 'Authentication.RelyingParty'" -connstring $connstring).value.Split(',')[1].replace('"Realm":"','').replace('"','')

# Check is cert is signed
$admin = $adminsite.Split(':')
$cert = !(New-Object System.Net.Security.SslStream((New-Object System.Net.Sockets.TcpClient($admin[1].Replace('/',''),$admin[2])).GetStream())).IsSigned

# get token
$token = Get-MgmtSvcToken -AuthenticationSite $windowsauthsite -ClientRealm $ClientRealm -Type Windows -DisableCertificateValidation:$cert

# get admin users
Get-MgmtSvcAdminUser -ConnectionString $connstring.Replace("PortalConfigStore","Store")

# get users
Get-MgmtSvcUser -AdminUri $AdminAPI -Token $token -DisableCertificateValidation:$cert

# get plans
Get-MgmtSvcPlan -AdminUri $adminapi -Token $token -DisableCertificateValidation:$cert

# get Subscriptions
Get-MgmtSvcSubscription -AdminUri $AdminAPI -Token $token -DisableCertificateValidation:$cert