Import-Module $PSScriptRoot\SuperReadKey.psm1

#I had to include these modules because of the way the prompts must be displayed.  They each have their own repositories in my profile.
Import-Module $PSScriptRoot\SuperLine.psm1
Import-Module $PSScriptRoot\Clear-HostLine.psm1

$ConsoleWidth = 64

Write-Host "This is a sample Menu System"
Write-Host ""
Write-Host "1 = Display tomorrows winning PowerBall Numbers"
Write-Host "2 = Call Warren Buffett for Financial Advice"
Write-Host "3 = Relax"
Write-Host "4 = Don't Do It"
Write-Host "5 = When you want to go to it"
Write-Host "6 = Order Bartle Skeets"
Write-Host "a = Neuter all racists"
Write-Host "b = World Peace"
Write-Host "c = End Poverty"
Write-Host ""

IF ($host.name -eq 'Windows Powershell ISE Host') {ReadHost} #Used when you are in ISE.  Will necessitate an ENTER Key.
IF ($host.name -eq 'ConsoleHost') {SuperReadKey -Mode Single -TimeToWait 10 -ValidChoicesList "1,2,3,4,5,6,a,b,c"} #Used when running in Console. This will NOT necessitate an ENTER Key. BUT, it ## will NOT work ## in ISE    

Switch ($K) {
    1 {Write-Host "The Numbers are: 4-8-19-27-34-10";pause}
    2 {Write-Host "Invest!  Compound Interest is your Friend!";pause}
    3 {Write-Host "Frankie went to Hollywood";pause}
    4 {Write-Host "Frankie went to Hollywood";pause}
    5 {Write-Host "Frankie went to Hollywood";pause}
    6 {Write-Host "Search for Cleetus McFarland on Youtube";pause}
    a {Write-Host "You know its the only way to stop the hate... don't let them breed";pause}
    b {Write-Host "Get along so we can all move ahead.";pause}
    c {Write-Host "Help your neighbor, pay it forward.";pause}
    q {quit}
    }

