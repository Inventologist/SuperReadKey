Import-Module $PSScriptRoot\SuperReadKey.psm1

#The menu and the MenuActions (or wherever you are sending the keystroke) should be in a separate Module file
#If they are NOT (like if they are in the main PS1 file, there will be errors calling the $SendKeyStrokeTo
Import-Module $PSScriptRoot\SuperReadKey_DEMO_MENU.psm1

#I had to include these modules because of the way the prompts must be displayed.  They each have their own repositories in my profile.
Import-Module $PSScriptRoot\SuperLine.psm1
Import-Module $PSScriptRoot\Clear-HostLine.psm1

#This is a required variable to be in the main file somewhere
#It MUST be global so that the different functions can use it when being called by this Script
$Global:ConsoleWidth = 64

$Global:Ind1V = 2

#Show the Menu
Menu_Main

