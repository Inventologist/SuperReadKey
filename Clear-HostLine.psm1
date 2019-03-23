Function Clear-HostLine {
    Param (
	    [Parameter(Position=1)]
	    [int32]$Count=1
    )

    $CurrentLine  = $Host.UI.RawUI.CursorPosition.Y
    $ConsoleWidth = $Host.UI.RawUI.BufferSize.Width

    $Lines = 1
    for ($Lines; $Lines -le $Count; $Lines++) {
	
	    [Console]::SetCursorPosition(0,($CurrentLine - $Lines))
	    [Console]::Write("{0,-$ConsoleWidth}" -f " ")

    }

    [Console]::SetCursorPosition(0,($CurrentLine - $Count))
}