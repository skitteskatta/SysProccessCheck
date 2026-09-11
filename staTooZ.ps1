if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Скрипт необходимо запустить от имени Администратора!"
    Write-Host "Перезапуск с правами администратора..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Clear-Host

$Host.UI.RawUI.ForegroundColor = 'Red'
Write-Host '         _.,,,.._'
Write-Host '       .,d$$$$$$$$SSIi:.'
Write-Host '      ,s$$$$$$$$$$$$$$SSIi:.'
Write-Host '     ji$$$$$$$$$$$$$$$$SISSi:.'
Write-Host '    ,s$$$$$$$$$$$$$$$$$$$$$$Ii:'
Write-Host '   j??$$$$$$$$$$$$$$$$$$*$$Ii'
Write-Host '   :  ?$$$$$$$$$$$$S?IISS$$I:'
Write-Host '  j_ /$$7`*4$$$$7:iiS$$$$I'''
Write-Host '  ?`"?$$:   `$k :iIIS$$$?'''
Write-Host '   i  ?$L,  ,d$     $$$7'''
Write-Host '  ,d._j$$$$S$$$L,_.`''$$'
Write-Host '  ?$$$$$k:?$$*`,  `'
Write-Host '  \: ''`**^'' :jIS?'
Write-Host '  j$k,i;/_.,oSSI'''
Write-Host '  ?SSS$$$$$?`'''
Write-Host '   ''`*o*`""'

$Host.UI.RawUI.ForegroundColor = 'Gray'
Write-Host "`n======================================================="
Write-Host "                     SERVICE STATUS"
Write-Host "======================================================="

$services = @("SysMain", "PcaSvc", "DPS", "EventLog", "Schedule", "Bam", "Dusmsvc", "Appinfo", "CDPSvc", "DcomLaunch", "PlugPlay", "wsearch", "DiagTrack", "Power")

foreach ($svcName in $services) {
    $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    
    if ($null -eq $svc) {
        $Host.UI.RawUI.ForegroundColor = 'DarkGray'
        Write-Host ("{0,-15} - NOT FOUND" -f $svcName)
        continue
    }

    if ($svcName -eq "Bam") {
        $startType = (Get-CimInstance -ClassName Win32_Service -Filter "Name='Bam'").StartMode
        if ($startType -eq "Disabled") {
            $Host.UI.RawUI.ForegroundColor = 'Red'
            Write-Host ("{0,-15} - STOPPED (Disabled)" -f $svcName)
        } else {
            $Host.UI.RawUI.ForegroundColor = 'Green'
            Write-Host ("{0,-15} - ENABLED" -f $svcName)
        }
        continue
    }

    if ($svc.Status -eq 'Running') {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        Write-Host ("{0,-15} - ACTIVE" -f $svcName)
    } else {
        $Host.UI.RawUI.ForegroundColor = 'Red'
        Write-Host ("{0,-15} - STOPPED" -f $svcName)
    }
}

$Host.UI.RawUI.ForegroundColor = 'Gray'
Write-Host "======================================================="
Write-Host "Check completed."
Read-Host "Press Enter to exit"
