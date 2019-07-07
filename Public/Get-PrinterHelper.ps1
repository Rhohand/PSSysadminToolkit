function Get-PrinterHelper {

    param(
        [string] $Name,
        [string] $ComputerName,
        [switch] $Full #,
        # TODO  [switch] $AsJob
    )

    $printerArgs = @{}

    if(![string]::IsNullOrEmpty($Name)) {
        $printerArgs.Add("Name", $Name)
    }
    if(![string]::IsNullOrEmpty($ComputerName)) {
        $printerArgs.Add("ComputerName", $ComputerName)
    }
    if($Full) {
        $printerArgs.Add("Full", $Full)
    }
    # $AsJob = $AsJob


    # Get-Printer [[-Name] <string[]>] [-ComputerName <string>] [-Full] [-CimSession <CimSession[]>] [-ThrottleLimit    <int>] [-AsJob]  [<CommonParameters>]
    Get-Printer @printerArgs
}