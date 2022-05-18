﻿<# 
 .Synopsis
  Remove a PSSession for a NAV/BC Container
 .Description
  If a session exists in the session cache, it will be removed and disposed.
  Remove-BcContainer automatically removes sessions created.
 .Parameter containerName
  Name of the container for which you want to remove the session
 .Example
  Remove-BcContainerSession -containerName bcserver
#>
function Remove-BcContainerSession {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [string] $containerName = $bcContainerHelperConfig.defaultContainerName
    )

    Process {
        Write-Host "check $containerName session"
        if ($sessions.ContainsKey($containerName)) {
            Write-Host "Container has session"
            $session = $sessions[$containerName]
            
            Write-Host "Remove Session"

            try {
                $processID = Invoke-Command -Session $session -ScriptBlock { $PID }
                Write-Host "Process ID: $processID"
                Stop-Process -Id $processID
                Write-Host "process stopped"
            }
            catch {
                Remove-PSSession -Session $session
            }
            
            Write-Host "Remove from array"
            $sessions.Remove($containerName)
        }
        Write-Host "Returning"
    }
}
Set-Alias -Name Remove-NavContainerSession -Value Remove-BcContainerSession
Export-ModuleMember -Function Remove-BcContainerSession -Alias Remove-NavContainerSession
