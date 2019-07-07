. $psscriptroot\..\..\Public\Get-PrinterHelper.ps1

Describe Get-MappedDrive {
    BeforeAll {
        Mock Get-CimInstance {
            Get-CimClass Win32_Process | New-CimInstance -ClientOnly
        }
    }

    Context 'No parameter passed' {
        It 'When no parameter is passed' {

            Get-PrinterHelper | Should -Not -BeNullOrEmpty
        }
    }
}