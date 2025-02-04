
<#
.SYNOPSIS
Update a printer

.DESCRIPTION
Update an existing printer

.PARAMETER Name
Name of the printer 

.PARAMETER ComputerName
Computer name of the printer such as local host, domain name or fqdn of Computer name

.PARAMETER Share
Share the printer, if no set it will not unshare a printer

.PARAMETER AsNewPrinter
Create a new instance of the printer so we don't affect the original printer

.PARAMETER NewPrinterName
New printer Name to use, the default will be {name}{n+1}

.EXAMPLE
$name = 'Printer Name'
$newPrinterName = "$name (shared)"
Get-printer -Name $name
Update-Printer -Name $name -Share -AsNewPrinter -NewPrinterName $newPrinterName

.NOTES
General notes
#>
#
function Update-Printer {
    param(
        [string] $Name,
        [string] $ComputerName, # TODO , Note this cannot be used with some other args like connection name
        [switch] $Share,
        [string] $ShareName,
        [switch] $AsNewPrinter,
        [string] $NewPrinterName,
        [switch] $Force #,
        # TODO  [switch] $AsJob
    )

    $printerArgs = @{}

    if(![string]::IsNullOrEmpty($Name)) {
        $printerArgs.Add("Name", $Name)
    }
    if(![string]::IsNullOrEmpty($ComputerName)) {
        $printerArgs.Add("ComputerName", $ComputerName)
    }
    if($Share -eq $true) {
    # TODO    $printerArgs.Add("Share", $Share)
    }
    # SET the default to the new printer name
    if([string]::IsNullOrEmpty($ShareName)){
        $ShareName = $NewPrinterName
    }
    if($AsNewPrinter -eq $true) {
        #TODO $printerArgs.Add("AsNewPrinter", $AsNewPrinter)
    }
    if(![string]::IsNullOrEmpty($NewPrinterName)) {
        # TODO $printerArgs.Add("NewPrinterName", $NewPrinterName)
        if($Force) {
            while(get-printer -name $NewPrinterName -ErrorAction SilentlyContinue) { 
                Write-Host "Removing Existing Printer $NewPrinterName"
                Remove-Printer -Name $NewPrinterName
            }    
        }
    } else {
        $i = 1
        $NewPrinterName = '{0} {1}' -f $Name, $i

        $maxPrinterIterations = 100
        if(get-printer -name $NewPrinterName -ErrorAction SilentlyContinue) { 
            $NewPrinterName = '{0} {1}' -f $Name, $i
            $i++ 
            if($i -ge $maxPrinterIterations ) {
                Write-Error "$NewPrinterName max iterations hit $i for new name"
                break;
            }
        }
    }
    # $AsJob = $AsJob
    try {
        # TODO Use Get-PrinterHelper
        $printer = Get-Printer @printerArgs

        if($AsNewPrinter) {
            if($printer -and [string]::IsNullOrEmpty($printer.Name)) {
                Write-Error "To many printers returned"
                Write-Host $printer
            } else {

                # Treat it as multiple for now
                $printer | % { 
                    $p = $_
                    # Name, ComputerName, Type, DriverName, PortName, Shared, Published

                    $newPrinterArgs = @{}
                    
                    # Basic example
                    ## source https://docs.microsoft.com/en-us/powershell/module/printmanagement/add-printer?view=win10-ps
                    # Add-Printer -Name "mxdw 2" -DriverName "Microsoft XPS Document Writer v4" -PortName "portprompt:"

                    $newPrinterArgs.Add("Name", $NewPrinterName)
                    $newPrinterArgs.Add("DriverName", $p.DriverName)
                    $newPrinterArgs.Add("PortName", $p.PortName)

                    if($Share) {
                        Write-Host "Sharing printer $ShareName"
                        $newPrinterArgs.Add("Shared", $true)
                        $newPrinterArgs.Add("ShareName", $ShareName)
                    }
                    Add-Printer @newPrinterArgs
                    # Note: Three valid sets of implementations that are distict

                    # Add-Printer [-ConnectionName] <string> [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf]
                    # [-Confirm]  [<CommonParameters>]
                
                    # Add-Printer [-Name] <string> [-Comment <string>] [-Datatype <string>] [-UntilTime <uint32>] [-KeepPrintedJobs]
                    # [-Location <string>] [-SeparatorPageFile <string>] [-ComputerName <string>] [-Shared] [-ShareName <string>]
                    # [-StartTime <uint32>] [-PermissionSDDL <string>] [-PrintProcessor <string>] [-Priority <uint32>] [-Published]
                    # [-RenderingMode {SSR | CSR | BranchOffice}] [-DisableBranchOfficeLogging] [-BranchOfficeOfflineLogSizeMB
                    # <uint32>] [-WorkflowPolicy {Uninitialized | Disabled | Enabled}] [-DeviceURL <string>] [-DeviceUUID <string>]
                    # [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf] [-Confirm]  [<CommonParameters>]
                
                    # Add-Printer [-Name] <string> [-DriverName] <string> -PortName <string> [-Comment <string>] [-Datatype <string>]
                    # [-UntilTime <uint32>] [-KeepPrintedJobs] [-Location <string>] [-SeparatorPageFile <string>] [-ComputerName
                    # <string>] [-Shared] [-ShareName <string>] [-StartTime <uint32>] [-PermissionSDDL <string>] [-PrintProcessor
                    # <string>] [-Priority <uint32>] [-Published] [-RenderingMode {SSR | CSR | BranchOffice}]
                    # [-DisableBranchOfficeLogging] [-BranchOfficeOfflineLogSizeMB <uint32>] [-WorkflowPolicy {Uninitialized |
                    # Disabled | Enabled}] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf] [-Confirm]
                    # [<CommonParameters>]
                }
            }
        }
    } finally {
        if($printer) { # TODO Handle the other get-printer calls
            Write-Host "Disposing of list of printers"
            $printer.Dispose()
        }
    }
}