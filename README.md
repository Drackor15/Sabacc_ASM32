# Sabacc_ASM32

'Sabacc' is a 'space poker' game from the Star Wars franchise. This single-player program attempts
to emulate Sabacc's gameplay using a variant ruleset as described by [this](https://www.youtube.com/watch?v=u_KdxNYY9sM&ab_channel=Saintmillion)
video. This game was made in 32-bit Assembly as a final project for my CSC 314 class at [DSU](https://dsu.edu/).
Some Shellcode & C were also used to save on time. However, this project is still far from finished
& I continue to work on it in my downtime.

The purpose behind this program is two-fold. First, to the best of my knowledge no online version
of Sabacc is available for play. I'm creating this to fill a void in the market & so I can try out Sabacc
with friends. Lastly, I'd like to flex my muscles & acquire new skills while working on this and
implementing fancy features to this game is the best way to do so.

###### Current Features:
* Available platforms: Linux
* Menus: Main, Rules Guide, Game Menu

###### Planned Features:
* __Finish Main Gameplay.__ The game still needs: basic AI, a way to view cards, & a way to make choices
during each round.
* __Update Controls.__ Right now, the player only navigates screens by pressing number keys. I intend
to change to more traditional controls such as the arrow key for navigation & the enter key to confirm choices.
* __Update Graphics.__ Currently, the game is displayed in a generic way. The cards don't even look
cool! I want to utilize ascii art to make (at least) the cards look good & the game feel alive.
* __Platform Friendly.__ The game only functions in a Linux enviroment, I at least want it to function
on Windows.
* __Multiplayer.__ LAN multiplayer using a shared folder.
* __Installation Friendly.__ I think it would be fun to learn how to make an installer in [NSIS](https://nsis.sourceforge.io/Main_Page)

## Installation:
NOTE: That at the moment only Linux can run the SABACC executable

First, make sure you have the following directory:
```
//mnt/c/ImagiSpark/games/Sabacc_ASM32
```
Then, go to the [releases page](https://github.com/Drackor15/Sabacc_ASM32/releases) & download the zip containing __Rules.txt__, __Table.txt__, __Menu.txt__, & the __SABACC__ executable.
Unzip those files & place them in the directory you created, & run the SABACC executable:
```
./SABACC
```
