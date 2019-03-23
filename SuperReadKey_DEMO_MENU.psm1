Function MenuActions {
    Switch ($K) {
        1 {Write-Host "`n`n";Write-Host "The Numbers are: 4-8-19-27-34-10";pause}
        2 {Write-Host "`n`n";Write-Host "Warren says, Invest!  Compound Interest is your Friend!";pause}
        3 {Write-Host "`n`n";Write-Host "Frankie went to Hollywood";pause}
        4 {Write-Host "`n`n";Write-Host "Frankie went to Hollywood";pause}
        5 {Write-Host "`n`n";Write-Host "Frankie went to Hollywood";pause}
        6 {Write-Host "`n`n";Write-Host "Search for Cleetus McFarland on Youtube";pause}
        a {Write-Host "`n`n";Write-Host "I guess not.";pause}
        b {Write-Host "`n`n";Write-Host "Get along so we can all move ahead.";pause}
        c {Write-Host "`n`n";Write-Host "Help your neighbor, pay it forward.";pause}
        abc {Write-Host "`n`n";Write-Host "Yay!, you know your abc's!";pause}
        q {exit}
        default {Write-Host "`n`n";Write-Host "Sorry, no slection made... try again" -f Red;Start-sleep 2;CLS;Menu_Main}
        }
#This is important to have so that the menu comes back and asks what option you want now.  If this is not here, it will get a little lost.
Menu_Main
}

#Important formatting variable to control the indent of the menus and prompts.  This is required for SuperReadKey prompts to be aligned correctly.
$Global:IndentMenu = {Write-Host -no (" " * $Ind1V)}

Function Menu_Main {
    CLS
    Write-Host ""
    &$IndentMenu;Write-Host "This is a sample Menu System"
    &$IndentMenu;Write-Host ""
    &$IndentMenu;Write-Host "1 = Display tomorrows winning PowerBall Numbers"
    &$IndentMenu;Write-Host "2 = Call Warren Buffett for Financial Advice"
    &$IndentMenu;Write-Host "3 = Relax"
    &$IndentMenu;Write-Host "4 = Don't Do It"
    &$IndentMenu;Write-Host "5 = When you want to go to it"
    &$IndentMenu;Write-Host "6 = Order Bartle Skeets"
    &$IndentMenu;Write-Host "a = Can' we all get along?"
    &$IndentMenu;Write-Host "b = World Peace"
    &$IndentMenu;Write-Host "c = End Poverty"
    &$IndentMenu;Write-Host "abc = Do you know your abc's?"
    &$IndentMenu;Write-Host ""
    
    #Switches between SuperReadKey and ReadHost depending on where it is called from.
    IF ($host.name -eq 'Windows Powershell ISE Host') {ReadHost} #Used when you are in ISE.  Will necessitate an ENTER Key.
    IF ($host.name -eq 'ConsoleHost') {SuperReadKey -TimeToWait 10 -ValidChoicesList "1","2","3","4","5","6","a","b","c","abc","q" -SendKeystrokeTo MenuActions} #Used when running in Console. This will NOT necessitate an ENTER Key. BUT, it ## will NOT work ## in ISE
}