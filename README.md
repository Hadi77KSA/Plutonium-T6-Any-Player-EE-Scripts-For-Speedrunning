# Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning
## Installation
1. [Download the files](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning/archive/refs/heads/master.zip) and unzip them.
2. Navigate to `%localappdata%\Plutonium\storage\t6\scripts\zm`
3. Place the files into their respective map's folder. If the map's folder doesn't exist, create it and place it into the path from step 2.
- `die_rise_any_player_ee.gsc` goes to `zm_highrise`
- `buried_any_player_ee.gsc` goes to `zm_buried`

## Die Rise

### Elevators step and Dragon Puzzle
Require the same amount as the number of players. If the Dragon Puzzle step is failed, it will reset back to require the same amount as the number of players.

### Trample Steam step:
#### Maxis Side
- If the number of players is 2 or less, the players will have the ability to place both balls on the same set of Trample Steams.
- If the player is playing solo or 3p:
  - once the player picks up a ball, gives the player the ability to place the ball on an already correctly placed Trample Steam without needing a Trample Steam on the opposite end. On 3p, this is executed if the ball is picked up while there's already a ball flinging; and
  - once a player places a Trample Steam correctly, gives each player already carrying a ball the ability to place it without needing a Trample Steam on the opposite end. On 3p, this is executed if the Trample Steam is placed while there's already a ball flinging.
  - (Note): on 3p while trying the methods when there isn't a Trample Steam on the opposite end, the player may need to place the ball back at the statue and pick it back up for the prompt to appear. This is caused by carrying a ball and having already placed down the lone Trample Steam correctly before a ball is launched.

#### Richtofen Side
Requires the players to place Trample Steams only on the same amount of symbols as players.

## Buried
### Maxis Side
Only works for less than 3p.
#### Wisp Step
Wisp no longer relies on zombies getting near it.

#### Bells Step
Removed time limit. Only resets if it's failed.

### Richtofen Side
#### Round Infinity A.K.A the Time Bomb Step
Can be done with less than 4 players. Requires all players in the lobby to be near the location of the Time Bomb.

### Sharpshooter
Minimum number of required targets:
- 1p: 20 targets (Candy Shop)
- 2p: 39 targets (Candy Shop + Saloon (19))
- Otherwise: all 84 targets
