﻿<# 
 .Synopsis
  Uninstall Nav App in Nav container
 .Description
  Creates a session to the Nav container and runs the Nav CmdLet Uninstall-NavApp in the container
 .Parameter containerName
  Name of the container in which you want to uninstall the app (default navserver)
 .Parameter appName
  Name of app you want to uninstall in the container
 .Example
  Uninstall-NavContainerApp -containerName test2 -appName myapp
#>
function UnInstall-NavContainerApp {
    Param(
        [Parameter(Mandatory=$false)]
        [string]$containerName = "navserver",
        [Parameter(Mandatory=$false)]
        [string]$tenant = "default",
        [Parameter(Mandatory=$true)]
        [string]$appName,
        [Parameter()]
        [string]$appVersion
    )

    $session = Get-NavContainerSession -containerName $containerName
    Invoke-Command -Session $session -ScriptBlock { Param($appName, $appVersion, $tenant)
        Write-Host "Uninstalling $appName from $tenant"
        $parameters = @{
            "ServerInstance" = "NAV";
            "Name" = $appName;
            "Tenant" = $tenant
        }
        if ($appVersion)
        {
            $parameters += @{ "Version" = $appVersion }
        }
        Uninstall-NavApp @parameters
    } -ArgumentList $appName, $appVersion, $tenant
    Write-Host -ForegroundColor Green "App successfully uninstalled"
}
Export-ModuleMember -Function UnInstall-NavContainerApp
