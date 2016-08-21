function Set-RSVirtualDirectory
{
<#
.SYNOPSIS
Sets the name of the virtual directory for a given application.
.EXAMPLE
Set-RSVirtualDirectory -Application ReportManager -VirtualDirectory reports
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/bb630594(v=sql.110).aspx
SetVirtualDirectory(
    System.String Application, 
    System.String VirtualDirectory, 
    System.Int32 Lcid
)
#>
    [cmdletbinding()]
    param
    (
        [Parameter(
            HelpMessage = 'The computer hosting SSRS',
            Position    = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Server')]
        [string[]]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        # The name of application for which to set the virtual directory.
        [string]
        $Application,

        # The name of the virtual directory.
        [string]
        $VirtualDirectory
    )

    begin
    {
        # Build a hashtable for spallting that takes into account optional values
        $rsParam = @{}
        if($PSBoundParameters.Instancename)
        {
            $rsParam.Instancename = $PSBoundParameters.Instancename
        }
        if($PSBoundParameters.Credential)
        {
            $rsParam.Credential = $PSBoundParameters.Credential
        }
    }
    process
    {
        foreach($node in $ComputerName) 
        {
            Write-Verbose $node
            $rsParam.ComputerName = $node         
            $rsSettings = Get-RSConfigurationSettings @rsParam 

            $CimArguments = [ordered]@{
                Application      = $Application  
                VirtualDirectory = $VirtualDirectory
                Lcid             = [int32](Get-Culture).Lcid
            }

            Write-Verbose 'SetVirtualDirectory'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetVirtualDirectory -Arguments $CimArguments | Out-Null
        }
    }
}

