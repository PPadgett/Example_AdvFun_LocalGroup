Describe 'Show-AdminOnServer Valid Inputs' {
    BeforeAll { 
        function Show-AdminOnServer ([string]$TargetServer = '*') {
            $DNSCheck = ([System.Net.Dns]::GetHostByName(("$env:COMPUTERNAME")))         
            $Object = New-Object PSObject -Property ([ordered]@{ 
              
                        "Server name"             = $env:COMPUTERNAME
                        "FQDN"                    = $DNSCheck.hostname
                        "IP Address"              = $DNSCheck.AddressList[0]
         
            })
            $Object | Where-Object { $_.Name -or $_.'FQDN' -or $_.'IP Address' -like $TargetServer }
        }
    }
}

Describe 'Test for Vaild Connection Types' {
    $AllTargets = Show-AdminOnServer
    Function MockTest-Connection {Test-Connection -ComputerName $args[0] -Count 1 }
    It "Test for Vaild Short Name Connection" {
        $AllTargets.'Server Name' | Should Not BeNullOrEmpty
        $AllTargets.'Server Name' | Should BeOfType [string]
        MockTest-Connection $AllTargets.'Server Name'
    }
    It "Test for Vaild FQDN Name Connection" {
        $AllTargets.'FQDN' | Should Not BeNullOrEmpty
        $AllTargets.'FQDN' | Should BeOfType [string]
        MockTest-Connection $AllTargets.'FQDN'
    }
    It "Test for Vaild IP Address Connection" {
        $AllTargets.'IP Address' | Should Not BeNullOrEmpty
        $AllTargets.'IP Address' | Should BeOfType [ipaddress]
        MockTest-Connection $AllTargets.'IP Address'
    }
}
