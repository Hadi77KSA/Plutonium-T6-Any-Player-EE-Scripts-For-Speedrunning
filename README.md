# Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning
The following scripts allow the main Easter Egg quests to be done with any number of players—whether it is solo (1 player), duo (2 players), trio (3 players), or even more than 4 players—while aiming to be as similar to the original Easter Eggs as possible.
## Installation
1. [Download the repository](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning/archive/refs/heads/main.zip).
2. Extract the `zm_any_player_ee` folder from the ZIP file that was downloaded.
3. Go to `%localappdata%\Plutonium\storage\t6` by pressing Win+R then pasting the mentioned path then pressing OK, and open the `mods` folder. If the `mods` folder does not exist, create it.
4. Move the `zm_any_player_ee` folder to inside the `mods` folder.
5. Start the game and load the mod through the in-game `Mods` menu.

#### Patches
Can be found in `zm_any_player_ee\scripts\zm\Patches`
* `die_rise_any_player_ee-no_reset.gsc` to avoid conflict, not to be used with `die_rise_any_player_ee.gsc`  
The file goes in `scripts\zm\zm_highrise`  
This version makes the floor symbols not reset once an incorrect symbol is stepped on.
* `buried_body_fix.gsc` can be used along with `buried_any_player_ee.gsc`  
The file goes in `scripts\zm\zm_buried`  
This patch makes the bodies on the round infinity step on the Richtofen side have the switch on the first 3 bodies searched. This patch was provided due to a bug that sometimes doesn't make all bodies spawn in.
* `nav_autocomplete.gsc` to go in `scripts\zm`  
This patch builds the Nav Table on the current Victis map and applies the Navcards to all maps for all players.

### Alternative Installation Methods
Following any of these methods makes the scripts be loaded automatically without needing to select the mod from the in-game `Mods` menu.
#### Complete Scripts Folder
- Follow steps 1 & 2 from the main installation instructions.
- Go to `%localappdata%\Plutonium\storage\t6` by pressing Win+R then pasting the mentioned path then press OK.
- Open the `zm_any_player_ee` folder and copy the `scripts` folder from inside of it.
- Paste the `scripts` folder into the `t6` folder.

#### Individual Files
1. Navigate to the [Releases](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning/releases/latest) page and download the script you desire.
2. Navigate to `%localappdata%\Plutonium\storage\t6\scripts\zm`
3. Place the files into their respective map's folder. If the map's folder does not exist, create it and place it into the path from step 2.
- TranZit's scripts go to `scripts\zm\zm_transit`
- Die Rise's scripts go to `scripts\zm\zm_highrise`
- Buried's scripts go to `scripts\zm\zm_buried`
- `super_ee_any_player.gsc` goes to `scripts\zm\zm_buried`
## Features
### TranZit
#### - Tower Step and Lamp Post Step for the Maxis Side
For solo, only require 1 Turbine.

### Die Rise
#### - Nav Table
The script by default will automatically build the Nav Table if it is not already built. To prevent this, the person hosting will need to [open the console](https://plutonium.pw/docs/opening-console/) and execute the following command:
```
set any_player_ee_highrise_nav "0"
```

#### - Elevators Step and Dragon Puzzle
Require the same amount as the number of players.  
If the Dragon Puzzle step is failed, it will reset back to require the same amount as the number of players.

#### - Trample Steam Step
##### a) Maxis Side
- On solo and on 3p while the 1st ball is already flinging between Trample Steams placed on a set of lion symbols, only one Trample Steam will be required in order to be able to place down a ball.
- If the number of players is 3 or less, the players will have the ability to place both balls on the same set of Trample Steams.
- On 3p, having the 1st ball flinging is required to be able to place the other ball on the lone Trample Steam.

##### b) Richtofen Side
Requires the players to place Trample Steams only on the same amount of symbols as players.

### Buried
#### a) Maxis Side
##### - Wisp Step
For less than 3p, wisp will no longer rely on zombies getting near it.

##### - Bells Step
For less than 3p, time limit will be removed. Will only reset if it is failed.

#### b) Richtofen Side
##### - Round Infinity A.K.A. the Time Bomb Step
On 4p or less, requires all players in the lobby to be near the location of the Time Bomb.  
If the number of players is greater than 4, the step will only work if 4 players are near the location, no more no less, exactly how it works without the mod.

#### Sharpshooter
Minimum number of required targets:
- 1p: 20 targets (Candy Shop)
- 2p: 39 targets (Candy Shop + Saloon (19))
- Otherwise: all 84 targets

### Super Easter Egg
Allows for the Super Easter Egg button to be accessible with any number of players as long as:
- the players have, collectively, inserted the Navcards on all three Victis maps of TranZit, Die Rise, and Buried;
- each player in the lobby has completed the Victis maps' Easter Eggs on the same side across the maps;
- the completed side across all players is the same.

For more than 4 players, the mod will only use the player progress that is shown on the box.

## FAQ
### - Q: Do I/we need all of these mods to do all the Victis EEs?
A: Depends on the number of players and which maps and side you choose. The host is required to have the mods installed. The following shows the required files:
  - 1p:-
    - TranZit Maxis:
      - `tranzit_any_player_ee.gsc`
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried: `buried_any_player_ee.gsc`
    - Super EE: `super_ee_any_player.gsc`
  - 2p:-
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried: `buried_any_player_ee.gsc`
    - Super EE: `super_ee_any_player.gsc`
  - 3p:-
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried Richtofen:
      - `buried_any_player_ee.gsc`
    - Super EE: `super_ee_any_player.gsc`
  - 4p:- None
  - More than 4p:-
    - Super EE: `super_ee_any_player.gsc`

### - Q: On TranZit, should I worry that Maxis says the Turbine does not have enough power shortly after placing the Turbine under the tower?
A: Likely a vanilla game issue, especially if the Turbine begins not emitting power. If the Turbine is emitting power, then you probably should not worry.

### - Q: On Die Rise, why is the elevator step not completing even though we are standing on enough elevator symbols?
A: Vanilla game problem. You need to make sure the Nav Table is fully built.

### - Q: On Die Rise, why is the Ballistic Knife step not completing even though Maxis said his quote about reincarnation, and the Ballistic Knife is upgraded and is shot into the Buddha room?
A: Vanilla game problem. The player shooting the Ballistic Knife must not have a melee weapon (Bowie Knife, Galvaknuckles) nor have bled out (includes, even while having Who's Who, falling off the map and getting crushed). To fix this, either get another player—who does not have a melee weapon nor has bled out—to do the step, or if the player has a melee weapon but has not bled out, make them get rid of the melee weapon by downing while having Who's Who and letting their original self disappear.

## Credits
- CCDeroga: [TranZit Maxis mod](https://forum.plutonium.pw/topic/15338/zm-release-solo-maxis-tranzit), [Buried Maxis mod](https://forum.plutonium.pw/topic/15604/release-zm-buried-maxis-solo-ee).
- teh_bandit: Contributions mentioned in the credited people's scripts.
- DaddyDontStop: [Die Rise Maxis mod](https://forum.plutonium.pw/topic/16736/release-zombies-die-rise-solo-ee-maxis), Buried Maxis mod.
- shyperson0/znchi: [Die Rise Richtofen mod](https://forum.plutonium.pw/topic/14737/gsc-zm-solo-die-rise-richtofen).
- Stick Gaming/Nathan3197: [Buried Richtofen mod](https://forum.plutonium.pw/topic/16021/release-zm-buried-easter-egg-quality-of-life-improvement).
- Raheem1 and the Easter Egg speedrunning community: testing my Die Rise's mod, and giving opinions on my changes made to Die Rise's mod and Buried's mod.
