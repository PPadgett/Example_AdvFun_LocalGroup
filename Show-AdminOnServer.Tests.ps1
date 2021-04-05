$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

BeforeAll { 
    function Show-AdminOnServer ([string]$TargetServer = '*') {
        $ServerList = @(
            @{ 'ServerName' = $env:COMPUTERNAME }
            @{ 'FQDN' = ([System.Net.Dns]::GetHostByName(($env:COMPUTERNAME))).HostName}
            @{ 'IP Address' = [ipaddress[]]([System.Net.Dns]::GetHostByName(($env:COMPUTERNAME))).AddressList}
        ) | ForEach-Object { [PSCustomObject] $_ }    

        $ServerList | Where-Object { $_.ServerName -or $_.FQDN -or $_.'IP Address' -like $TargetServer }
    }
}

Describe 'Show-AdminOnServer' {
    It 'Given no Target Server in parameters, it lists all 4 vaild connection Names' {
        $allGroups = List-AdminOnServer
        $allGroups | Should -be $true
    }
}

# Describe "List-AdminOnServer.ps1" {
#     It "does something useful" {
#         $true | Should Be $false
#     }
# }
