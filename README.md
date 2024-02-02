# Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning
The following scripts allow the main Easter Egg quests to be done with any number of players—whether it is solo (1 player), duo (2 players), trio (3 players), or even more than 4 players—while aiming to be as similar to the original Easter Eggs as possible.
## Installation
1. Navigate to the [Releases](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning/releases/latest) page and download the script you desire.
2. Navigate to `%localappdata%\Plutonium\storage\t6\scripts\zm`
3. Place the files into their respective map's folder. If the map's folder doesn't exist, create it and place it into the path from step 2.
- TranZit's scripts go to `zm_transit`
- Die Rise's scripts go to `zm_highrise`
- Buried's scripts go to `zm_buried`
- `super_ee_any_player.gsc` goes to `zm_buried`

# Features
## TranZit
Uses CCDeroga's mod to allow the Maxis side to be completable in solo.  
Note that it does not show a message in-game indicating it is loaded once the map is started. To determine if it has been loaded successfully, either go through the Easter Egg and perform a step and listen out for the quotes, or check the Plutonium bootstrapper window for if it says the following line when the map is started:
```
Script "scripts/zm/zm_transit/tranzit_maxis_solo.gsc" loaded successfully
```
### - Tower Step and Lamp Post Step for the Maxis Side
Only require 1 Turbine if the match was started as a solo match.

## Die Rise
### - Elevators Step and Dragon Puzzle
Require the same amount as the number of players.  
If the Dragon Puzzle step is failed, it will reset back to require the same amount as the number of players.

### - Trample Steam Step
#### a) Maxis Side
- On solo and on 3p while the 1st ball is already flinging between Trample Steams placed on a set of lion symbols, only one Trample Steam will be required in order to be able to place down a ball.
- If the number of players is 3 or less, the players will have the ability to place both balls on the same set of Trample Steams.
- On 3p, having the 1st ball flinging is required to be able to place the other ball on the lone Trample Steam.

#### b) Richtofen Side
Requires the players to place Trample Steams only on the same amount of symbols as players.

## Buried
### a) Maxis Side
#### - Wisp Step
For less than 3p, wisp will no longer rely on zombies getting near it.

#### - Bells Step
For less than 3p, time limit will be removed. Will only reset if it is failed.

### b) Richtofen Side
#### - Round Infinity A.K.A the Time Bomb Step
On 4p or less, requires all players in the lobby to be near the location of the Time Bomb.  
If the number of players is greater than 4, the step will only work if 4 players are near the location, no more no less, exactly how it works without the mod.

### Sharpshooter
Minimum number of required targets:
- 1p: 20 targets (Candy Shop)
- 2p: 39 targets (Candy Shop + Saloon (19))
- Otherwise: all 84 targets

## Super Easter Egg
Allows for the Super Easter Egg button to be accessible with any number of players as long as:
- the players have, collectively, inserted the Navcards on all three Victis maps of TranZit, Die Rise, and Buried;
- each player in the lobby has completed the Victis maps' Easter Eggs on the same side across the maps;
- the completed side across all players is the same.

For more than 4 players, the mod will only use the player progress that is shown on the box.

# FAQ
## - Q: Do I/we need all of these mods to do all the Victis EEs?
A: Depends on the number of players and which maps and side you choose. The host is required to have the mods installed. The following shows the required files:
  - 1p:-
    - TranZit Maxis:
      - `tranzit_maxis_solo.gsc`
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

## - Q: On TranZit, should I worry that Maxis says the Turbine does not have enough power shortly after placing the Turbine under the tower?
A: Likely a vanilla game issue, especially if the Turbine begins not emitting power. If the Turbine is emitting power, then you probably should not worry.

- Q: On Die Rise, why is the elevator step not completing even though we are standing on enough elevator symbols?
A: Vanilla game problem. You need to make sure the Nav Table is fully built.

## - Q: On Die Rise, why is the Ballistic Knife step not completing even though Maxis said his quote about reincarnation, and the Ballistic Knife is upgraded and is shot into the Buddha room?
A: Vanilla game problem. The player shooting the Ballistic Knife must not have a melee weapon (Bowie Knife, Galvaknuckles) nor have bled out (includes, even while having Who's Who, falling off the map and getting crushed). To fix this, either get another player—who does not have a melee weapon nor has bled out—to do the step, or if the player has a melee weapon but has not bled out, make them get rid of the melee weapon by downing while having Who's Who and letting their original self disappear.

# Credits
- CCDeroga: [TranZit Maxis mod](https://forum.plutonium.pw/topic/15338/zm-release-solo-maxis-tranzit), [Buried Maxis mod](https://forum.plutonium.pw/topic/15604/release-zm-buried-maxis-solo-ee).
- teh_bandit: Contributions mentioned in the credited people's scripts.
- DaddyDontStop: [Die Rise Maxis mod](https://forum.plutonium.pw/topic/16736/release-zombies-die-rise-solo-ee-maxis), Buried Maxis mod.
- shyperson0/znchi: [Die Rise Richtofen mod](https://forum.plutonium.pw/topic/14737/gsc-zm-solo-die-rise-richtofen).
- Stick Gaming/Nathan3197: [Buried Richtofen mod](https://forum.plutonium.pw/topic/16021/release-zm-buried-easter-egg-quality-of-life-improvement).
- Raheem1 and the Easter Egg speedrunning community: testing my Die Rise's mod, and giving opinions on my changes made to Die Rise's mod and Buried's mod.
