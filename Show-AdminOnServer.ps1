
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
[CmdletBinding(DefaultParameterSetName = 'Default')]
Param(
    # Param1 help description
    [Parameter(ParameterSetName = 'Default',
        Position = 0,
        Mandatory = $true)]
    [Alias("CN")]
    $ComputerName,

    # Param2 help description
    [Parameter(ParameterSetName = 'Default',             
        Position = 1,
        Mandatory = $false)]
    [Alias("CRED")]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.CredentialAttribute()]
    $Credential
)
function Show-AdminOnServer
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='low')]
    [Alias()]
    [OutputType([String])]
    Param(
        # Param1 help description
        [Parameter(ParameterSetName = 'Default',
            Position = 0,
            Mandatory = $false)]
        [Alias("CN")]
        $ComputerName = "$env:COMPUTERNAME",

        # Param2 help description
        [Parameter(ParameterSetName = 'Default',             
            Position = 1,
            Mandatory = $false)]
        [Alias("CRED")]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    Begin
    {
        Write-Verbose "Testing Connection to ComputerName"
        $ComputerName | ForEach-Object -Process {
            if (Test-Connection -ComputerName $_ -Quiet -count 1){
                $VerifiedComputerList += @("$_")
            }
            else {
                $NoConnectionComputerList += @("$_")
            }
            Write-Verbose "Test Connection Passed: $($VerifiedComputerList)"
            Write-Verbose "Test Connection Failed: $($NoConnectionComputerList)"
        }
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target: $ComputerName", "Retriving List of User in the Administartor Group"))
        {
            if ($VerifiedComputerList) {
                Write-Verbose "Retrieving Administrator ID from the Administrators Group"
                New-CimSession -Credential $Credential | Get-CimInstance  -ClassName win32_group -Filter "name = 'administrators'" | Get-CimAssociatedInstance -Association win32_groupuser | Format-Table -Property "Domain","Name"
                
            }
        }
    }
    End
    {
        Get-CimSession | Remove-CimSession
        if ($NoConnectionComputerList) {
            Write-Warning "Connection Failed: $($NoConnectionComputerList)"
        }
    }
}

Show-AdminOnServer -ServerName $ServerName -Credential $Credential