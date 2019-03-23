# SuperReadKey
## I have a couple of issues I'm resolving with this function as of 3/23/19. I'm working on it allowing input for 1,2,3,4,5,6 as valid key options and also beign able to pass it a CSV or even a column in a Here-String.  When I'm done, it will be much more user friendly. ##

Thanks!

Wrapper for $Host.UI.RawUI.ReadKey.  
Enables $Host.UI.RawUI.ReadKey to accept Single AND Multiple Characters.

## SuperReadKey requires SuperLine and Clear-HostLine
See my repositories for the most updated versions.  They are included here for your convenience.

## Welcome to SuperReadKey!
This was born from a desire to have Read-Host accept single characters without necessitating an Enter inside of my menu system "RunMAhStuff".  I liked the ability to have a single keypress activate the menu option.  It was way faster than having to hit enter every time, but I was limited.

But... I needed a way to have BOTH single and multiple character input.  I could have easily switched between $Host.UI.RawUI.ReadKey and Read-Host, but I wanted it to work in a SINGLE function.  So, SuperReadKey was born.

# Structure / Intended Usage
**Intended useage**  
SuperReadKey is meant to be called at the point that you need keyboard input, and then return to ANOTHER function to take action on the $Kvariable that stores the keyboard input.  This is specifically because the script needs to exit out at several points and calling out to a fuction is the most reliable way I have found to do that.  See the DEMO script for how I intended this to be used.

**Structure**  
-SuperReadKey takes a $Host.UI.RawUI.ReadKey input and sends $K to the $SendKeystrokeTo variable.  This would be routed to whatever process in your ecosystem processes the input.

-When you need to process multiple characters (MultiChar), the default key is -  
This changes the prompts and puts the system into a loop to collect multiple $Host.UI.RawUI.ReadKey inputs and aggregate them into a temporary variable.

-Backspace
During input, you have the ability to use the Backspace to delete incorrect characters.  Prompts will always reflect the current value of $K

-Enter
When the $Host.UI.RawUI.ReadKey sees the VirtualKeyCode for Enter, it submits the $K to your $SendKeystrokeTo

-Prompts
The prompts are set up pretty well, you should not need to mess with them too much.  If you do need to put special messages into the prompts, they will automatically calculate the number of lines and erase them when you are looping or changing modes.  NOTICE: The prompts are set up for a screen width of 64 characters.  

-ConsoleWidth
You will need to set up a variable called $ConsoleWidth.  This will be the total width of the console you are displaying this in.  This will be needed to limit the MultiChar input so that it doesn't roll over to the next line.  I use a value of 64.  Seems to look nice in a menu.  That leaves about 32 characters for input.

# How to use SuperReadKey:
I call it like this:
($ValidKeyChoices is a list of valid choices from a CSV)
SuperReadKey -ValidChoicesList $ValidKeyChoices

I'm working on getting this to accept something like:
SuperReadKey -ValidChoicesList 1,2,3,4,5,6,7,a,b,c,d
