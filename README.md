# SuperReadKey
Wrapper for $Host.UI.RawUI.ReadKey.  
Enables $Host.UI.RawUI.ReadKey to accept Single AND Multiple Characters.

## SuperReadKey requires SuperLine  
See my SuperLine repository.

## Welcome to SuperReadKey!
This was born from a desire to have Read-Host accept single characters without necessitating an Enter inside of my menu system "RunMAhStuff".  I liked the ability to have a single keypress activate the menu option.  It was way faster than needed to hit enter every time.  But, I was limited to SINGLE printable characters.

I needed a way to have both single and multiple character input.  I could have easily switched between $Host.UI.RawUI.ReadKey and Read-Host, but I wanted it to work in a SINGLE function.  SuperReadKey was born.

# Structure
-SuperReadKey takes a $Host.UI.RawUI.ReadKey input and sends $K to the $SendKeyStrokeTo variable.  This would be routed to whatever process in your ecosystem processes the input.


## SuperReadKey is structured as follows:

# How to use SuperReadKey:
 
# Methodology Explanation

# History
