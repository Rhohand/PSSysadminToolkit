function Update-PrinterConfiguration {
    param(
        [string] $Name,
        # TODO [switch] $Collate,
        # TODO [switch] $Color,
        [ValidateSet('OneSided', 'TwoSidedLongEdge', 'TwoSidedShortEdge')]
        [string] $DuplexMode,
        [ValidateSet('Custom', 'Letter', 'LetterSmall', 'Tabloid', 'Ledger', 'Legal |
            Statement', 'Executive', 'A3', 'A4', 'A4Small', 'A5', 'B4', 'B5', 'Folio', 'Quarto', 'Sheet10x14', 'Sheet11x17', 'Note |
            Envelope9', 'Envelope10', 'Envelope11', 'Envelope12', 'Envelope14', 'CSheet', 'DSheet', 'ESheet', 'EnvelopeDL |
            EnvelopeC5', 'EnvelopeC3', 'EnvelopeC4', 'EnvelopeC6', 'EnvelopeC65', 'EnvelopeB4', 'EnvelopeB5', 'EnvelopeB6 |
            EnvelopeItaly', 'EnvelopeMonarch', 'EnvelopePersonal', 'FanfoldUS', 'FanfoldStandardGerman', 'FanfoldLegalGerman |
            ISOB4', 'JapanesePostcard', 'Sheet9x11', 'Sheet10x11', 'Sheet15x11', 'EnvelopeInvite', 'Reserved48', 'Reserved49 |
            LetterExtra', 'LegalExtra', 'TabloidExtra', 'A4Extra', 'LetterTransverse', 'A4Transverse', 'LetterExtraTransverse |
            APlus', 'BPlus', 'LetterPlus', 'A4Plus', 'A5Transverse', 'B5Transverse', 'A3Extra', 'A5Extra', 'B5Extra', 'A2 |
            A3Transverse', 'A3ExtraTransverse', 'JapaneseDoublePostcard', 'A6', 'JapaneseEnvelopeKaku2', 'JapaneseEnvelopeKaku3 |
            JapaneseEnvelopeChou3', 'JapaneseEnvelopeChou4', 'LetterRotated', 'A3Rotated', 'A4Rotated', 'A5Rotated', 'B4JISRotated
           ', 'B5JISRotated', 'JapanesePostcardRotated', 'JapaneseDoublePostcardRotated', 'A6Rotated |
            JapaneseEnvelopeKaku2Rotated', 'JapaneseEnvelopeKaku3Rotated', 'JapaneseEnvelopeChou3Rotated |
            JapaneseEnvelopeChou4Rotated', 'B6JIS', 'B6JISRotated', 'Sheet12x11', 'JapaneseEnvelopeYou4 |
            JapaneseEnvelopeYou4Rotated', 'PRC16K', 'PRC32K', 'PRC32KBig', 'PRCEnvelope1', 'PRCEnvelope2', 'PRCEnvelope3 |
            PRCEnvelope4', 'PRCEnvelope5', 'PRCEnvelope6', 'PRCEnvelope7', 'PRCEnvelope8', 'PRCEnvelope9', 'PRCEnvelope10 |
            PRC16KRotated', 'PRC32KRotated', 'PRC32KBigRotated', 'PRCEnvelope1Rotated', 'PRCEnvelope2Rotated |
            PRCEnvelope3Rotated', 'PRCEnvelope4Rotated', 'PRCEnvelope5Rotated', 'PRCEnvelope6Rotated', 'PRCEnvelope7Rotated |
            PRCEnvelope8Rotated', 'PRCEnvelope9Rotated', 'PRCEnvelope10Rotated')]
        [string] $PaperSize 

    )

    $printerConfigArgs = @{}
    if(![string]::IsNullOrEmpty($Name)){
        $printerConfigArgs.Add('PrinterName', $Name)
    }
    if(![string]::IsNullOrEmpty($DuplexMode)){
        $printerConfigArgs.Add('DuplexMode', $DuplexMode)
    }
    if(![string]::IsNullOrEmpty($Name)){
        $printerConfigArgs.Add('PaperSize', $PaperSize)
    }
    Set-PrintConfiguration @printerConfigArgs
}