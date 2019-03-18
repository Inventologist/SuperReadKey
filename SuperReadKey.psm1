Function SuperReadKey { #SuperReadKey (Uses $Host.UI.RawUI.ReadKey) - Has a Timeout Function: One keystroke only, No Enter Required.  This HAS the ability to accept multiple characters via the "-" Key.
    Param(
    [parameter (Mandatory=$false)][ValidateSet('Single','Multi')]$Mode = "Single",
    [parameter (Mandatory=$false)]$TimeToWait = 90,
    [parameter (Mandatory=$false)]$DefaultKeystroke = 'Q',
    [parameter (Mandatory=$false)][string[]]$ValidChoicesList, #Give a list of valid characters (List of all valid choices available) Must be printable characters, no ALT,Enter, CTRL, etc.
    [parameter (Mandatory=$false)]$MultiCharToggleChar = "-", #Change this to alter the character that enables/disables the MultiChar Mode.
    [parameter (Mandatory=$false)]$ResetPrompt = "NO", #This is so that the Clear-HostLine command does not erase lines of the menu.  It is only used for when the prompt needs to be reset.
    [parameter (Mandatory=$false)]$ConsoleWidthForPrompt = "$ConsoleWidth", #This is so that the Clear-HostLine command does not erase lines of the menu.  It is only used for when the prompt needs to be reset.
    [parameter (Mandatory=$false)]$SendKeystrokeTo = "MenuActions" #Functional to send the $K Value to.
    )
    
    #Store Current $ValidChoicesList to a variable so that when the process loops back (for MultiChar or Backspacing) the original value can be reused without having to specifiy it again.
    IF ($ValidChoicesList -ne "" -AND $ResetPrompt -eq "NO") {$Global:ValidChoicesList_Session = $ValidChoicesList} #IF you have called the function, HAVE specified a $ValidChoicesList value, and you are NOT resetting the Prompts, Set the $ValidChoicesList_Session value to the current $ValidChoicesList
    IF ($ValidChoicesList -eq $null -AND $ResetPrompt -eq "YES") {$ValidChoicesList = $Global:ValidChoicesList_Session} #IF you have called the function, HAVE NOT specified a $ValidChoicesList value, and you ARE resetting the prompt, use the $ValidChoicesList_Sesstion value for the $ValidChoicesList
    
    #General Variables
    $Global:FunctionLoopback = $MyInvocation.MyCommand.Name #Loops back to this function.

    #Variables for Timeout Functionality
    $StartTime = Get-Date;$TimeOut = New-TimeSpan -Seconds $TimeToWait

    #Maintenance
    $Host.UI.RawUI.FlushInputBuffer() #Clears out all Variables and buffers related to the Keystroke Process.  Necessary to get a fresh keystroke entry.
        
    #Create the MultiChar DiagMode command line.  This is Triggered by $DiagMode = "ON", but used ONLY in this Function.
    $MultiCharDiag = {IF ($Global:DiagMode -eq "ON") {Write-Host "Response.character: $Response.Character";Write-Host "Mode: : $Mode";Write-Host "MultiChar_STAGE: $MultiChar_STAGE";Write-Host "MultiChar_VALUE: $MultiChar_VALUE";Write-Host "K is: $K";start-sleep -Milliseconds 250}}
            
    #####################
    ## Prompt Clearing ## Control the clearing of lines at bottom of screen to set new prompts IN PLACE of the last entry.
    #####################
    
    #This tells RMS to Clear-HostLine the number of lines from the last messages and prompts... this way the whole screen doesnt get refreshed, just the prompt itself
    IF ($ResetPrompt -eq "YES") {
        
        #Calculates the number of lines in the $Message (error or informational) subtracts one line, and then runs Clear-HostLine for that number of lines
        IF ((Test-Path Variable:\Message) -AND ($Message -ne "")) {
            
            #If the message is a MultiChar message, then delete the $MessageLines -1.  This is because of the extra Write-Host to get the message to te line below the character entry
            IF ($Message -match "MultiChar") {
                $MessageLength = $Message | Measure-Object -Line
                $MessageLines = $MessageLength.Lines -1
                Clear-HostLine $MessageLines
                $Message = ""
            }
        
            #If the message is NOT a MultiChar message, then delete the $MessageLines
            IF ($Message -notmatch "MultiChar") {
                $MessageLength = $Message | Measure-Object -Line
                $MessageLines = $MessageLength.Lines
                Clear-HostLine $MessageLines
                $Message = ""
            }
        }
        
        #Clear-HostLine during MULTI Mode Toggle
        IF ($Response.Character -eq "-") {Clear-HostLine ($PromptLines)} #This is used for when you Loop Back (like when you are getting the next MultiChar, Backspacing, when there is an error, or with $FunctionLoopback)
        
        #Clear-HostLine during RETURN
        IF ($Response.VirtualKeyCode -eq "13") {Clear-HostLine ($PromptLines -1)} #This is used for when you Loop Back (like when you are getting the next MultiChar, Backspacing, when there is an error, or with $FunctionLoopback)
        
        #Clear-HostLine during BACKSPACE.  Extra Write-Host is necessary here to deal with the fact that the entry AFTER the prompt line itself needs to be cleared.  The most reliable way to do this is to put another line in, then Clear-HostLine that line to write spaces over it.
        IF ($Response.VirtualKeyCode -eq "8") {Write-Host "";Clear-HostLine ($PromptLines)} #This is used for when you Loop Back (like when you are getting the next MultiChar, Backspacing, when there is an error, or with $FunctionLoopback)
        
        #Clear-HostLine during ALL OTHER CHARACTERS
        IF (($Response.VirtualKeyCode -ne "8") -AND ($Response.VirtualKeyCode -ne "13") -AND ($Response.Character -ne "-")) {Clear-HostLine ($PromptLines -1)}
    }

    #############
    ## Prompts ## Create the Different Prompt Possibilities.
    #############
    # S = Single, M = Multi
        
    #NOTE: These lines are MEASURED, so they must be formatted WITHOUT a Carriage Return after the first "{".  
    
    $Script:PromptLine1S = {SuperLine "                                          -"," to ","Enable MChar" -Startspaces $Ind2V -Color Red,White,Red} #Line 1 of the Single Mode Prompt
    $Script:PromptLine1M = {SuperLine "                                         -"," to ","Disable MChar" -Startspaces $Ind2V -Color Red,White,Red} #Line 1 of the Multi Mode Prompt
    
    $Script:PromptLine2 = {SuperLine "Press Q to quit" -StartSpaces $Ind1V -F DarkRed} #Line 2 (Common between both modes)
  
    
    $Script:PromptLine3S = {SuperLine "  MultiChar is: ","OFF" -C White,DarkGray
                            SuperLine -NoNewLine "Please make your choice...    " -StartSpaces $Ind1V} #Line 3 of the Single Mode Prompt
    
    $Script:PromptLine3M = {SuperLine "  MultiChar is: ","ON","                    ([Enter] to Run, - to Cancel)" -C White,Green,DarkGreen
                            SuperLine -NoNewLine "Please type MultiChar # ","$MultiChar_STAGE"," ---> ","$MultiChar_VALUE" -C White,Green,White,Green -StartSpaces $Ind1V} #Line 3 of the Multi Mode Prompt

    #Decide which prompt to use based on the Function you came from.
    IF ($Mode -eq "Single") {$Prompt = @("$PromptLine1S","$PromptLine2","$PromptLine3S")}
    IF ($Mode -eq "Multi") {$Prompt = @("$PromptLine1M","$PromptLine2","$PromptLine3M")}
    
    #Create the Prompt
    foreach ($Line in $Prompt) {
        Invoke-Expression $Line #Bring up the current processing prompt line.
        $PromptLinesTEMP = $PromptLinesTEMP + ($Line | Measure-Object -Line).Lines #Add the number of lines in the current prompt begin processed in to the $PromptLinesTEMP.  This gives a tally for the system to clear it out when changing modes.
    }
    
    $PromptLines = $PromptLinesTEMP#Transfer the TEMP to the real vaiable
    $PromptLinesTEMP = 0 #Reset the TEMP variable
            
    ###########################
    ## TIMEOUT Functionality ##
    ###########################
    WHILE (-not $host.ui.RawUI.KeyAvailable) {
    $CurrentTime = Get-Date 
        IF ($CurrentTime -gt $startTime + $TimeOut) {$K = $DefaultKeystroke;Invoke-Expression $SendKeystrokeTo}
    }

    ##########################
    ## Main ReadKey Section ##
    ##########################
    IF ($Host.UI.RawUI.KeyAvailable) {
        DO {
            [array]$Global:Response = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
            $K = $Response.Character
        } UNTIL 
        
        #Compare against the list of valid choices $KeychoiceVerifyAllValid.
        (($ValidChoicesList -match $Response.Character) -OR

        #Enable 0 as a valid choice... Turns DiagMode ON/OFF and goes to the main menu.
        ($Response.Character -eq "0") -OR

        #Enable the ToggleChar as a valid choice.
        ($Response.Character -eq $MultiCharToggleChar) -OR

        #8 = Enable Backspace as a valid choice.
        ($Response.VirtualKeyCode -eq "8") -OR

        #13 = Enable Enter as a valid choice.
        ($Response.VirtualKeyCode -eq "13"))
        }

    ######################
    ## MultiChar TOGGLE ##
    ######################
    IF ($Response.Character -eq $MultiCharToggleChar) {
        IF ($Mode -eq "Single") {
            $MultiChar_VALUE = ""; #Necessary so that the previous values are cleared.
            $MultiChar_STAGE = 1; #Starts the stage at 1.
            
            $Message = {Write-Host " " #This line is necessary to get the message to the next line.  It ensures that the length of the $Message will not interfere with the entered characters that could possibly be on the entry line.  If there were several, then the line would wrap around and mess up the calculcation of the Clear-HostLine
                        Write-Host " " 
                        Write-Host " "
                        Write-Host "  Enabling MultiChar" -F Red} #You must have "MultiChar in this message line... the function uses that word to see that this kind of message is happening.  There is a necessity to only clear out the Number of Lines -1, because the blank line does not show up as a Carriage Return, but it is necessary to show the message correctly (see comment above)
            Invoke-Command -ScriptBlock $Message
            
            Start-Sleep -Milliseconds 500;
            &$FunctionLoopback -Mode Multi -ResetPrompt YES
            } #TOGGLE MultiChar Mode to ON.

        IF ($Mode -eq "Multi") {
            
            $Message = {Write-Host " " #This line is necessary to get the message to the next line.  It ensures that the length of the $Message will not interfere with the entered characters that could possibly be on the entry line.  If there were several, then the line would wrap around and mess up the calculcation of the Clear-HostLine
                        Write-Host "  CANCELLING MultiChar" -F Red} #You must have "MultiChar in this message line... the function uses that word to see that this kind of message is happening.  There is a necessity to only clear out the Number of Lines -1, because the blank line does not show up as a Carriage Return, but it is necessary to show the message correctly (see comment above)
            Invoke-Command -ScriptBlock $Message

            Start-Sleep -Milliseconds 750;
            &$FunctionLoopback -Mode Single -ResetPrompt YES 
            } #TOGGLE MultiChar Mode to OFF.
    }
    
    ####################################
    ## MultiChar Mode Processing Area ##
    ####################################
    IF ($Mode -eq "Multi") {
        &$MultiCharDiag

        #Interrupt and Process the Value of $K as the menu selection IF the VirtualKeyCode is "ENTER".
        IF ($Response.VirtualKeyCode -eq "13") {
            Write-Host "`n  Running Command" -F Green
            $K = $MultiChar_VALUE
            Find-MenuSelectionError
            &$SendKeystrokeTo #Exit to process input.
        }

        #Interrupt when $Response.VirtualKeyCode is "Backspace"... remove last char and -1 on the stage, gets next character.
        IF ($Response.VirtualKeyCode -eq "8") {
            IF ($MultiChar_VALUE.Length -eq 1) {$MultiChar_STAGE = 1;$MultiChar_VALUE = ""}
            IF ($MultiChar_VALUE.Length -gt 1) {$MultiChar_VALUE = $MultiChar_VALUE.Substring(0,$MultiChar_VALUE.Length-1);$MultiChar_STAGE = ($MultiChar_STAGE -1)}
            
            &$FunctionLoopback -Mode Multi -ResetPrompt YES #Go back to SuperReadKey in Multi mode to get the next character.
        }

        #Process the $MultiChar_Value... add $K to the end of the current value of $MultiChar_Value, Increase Stage +1, gets next character.
        $MultiChar_VALUE = "$MultiChar_VALUE" + "$K" #Add the current typed character to the end of $MultiChar_VALUE.
        $MultiChar_STAGE++ #Increase STAGE by +1.
        &$MultiCharDiag
        
        #Set Maximum Entry Length
        IF ($MultiChar_VALUE.Length -ge ($ConsoleWidthForPrompt -32)) {Write-Host "";Write-Host "Maxiumum entry Size reached";Start-Sleep 3;&$SourceMenu}
        
        &$FunctionLoopback -Mode Multi -ResetPrompt YES #Go back to SuperReadKey in Multi mode to get the next character.
    }

    ## Single Mdoe DiagMode Messages.
    IF ($Global:DiagMode -eq "ON") {
        Write-Host "";Write-Host "";Write-Host "";Start-Sleep -Milliseconds 250
        Write-Host "################################################"
        Write-Host -no "Attributes of Response are: " -F Red;Get-Variable -Name Response | Select *;Start-Sleep -Milliseconds 500
        Write-Host "################################################"
        Write-Host "Attributes of K are: " -F Red;Get-Variable -Name K | Select *;Start-Sleep -Milliseconds 500
        Write-Host "################################################"
        Write-Host "The Response Record Values are: " -F Red;$Response
        Write-Host "";Write-Host "";pause
    }

    #################################
    ## Single Mode Processing Area ##
    #################################
    IF ($Mode -eq "Single") { #Process Keystroke for Single Mode Input  ##This IF is completely unecessary, as it would still catch a "Single" mode input without it, I just wanted to be verbose about its functionality.
        Find-MenuSelectionError #Message and Audio if option is not allowed.
        &$SendKeystrokeTo #Exit to process input.
    }
}

Function ReadHost { # KeyMode3 - Allows multiple keystrokes, Requires Enter (Uses Read-Host)  This is here for use in the ISE
    
    ## Prompts ##
    $PromptLine1 = {SuperLine "Press Q to quit" -StartSpaces $Ind1V -F DarkRed} #Line 1 of the Prompts
    $PromptLine2S = {SuperLine -NoNewLine "Please make your choice...    " -StartSpaces $Ind1V} #Line 2 of the Single Mode Prompt
    $Prompt = &$PromptLine1;&$PromptLine2S
    $Prompt #Make the Prompt come up

    $K = Read-Host " "
    Write-Host ""
    Write-Host -NoNewline "You Pressed " -ForegroundColor DarkYellow;Write-Host "$K" -ForegroundColor Red
    Start-Sleep -Milliseconds 500
    Find-MenuSelectionError
    MenuActions
}
