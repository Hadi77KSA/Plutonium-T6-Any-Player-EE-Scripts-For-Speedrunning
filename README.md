# Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning
## Installation
1. [Download the files](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts-For-Speedrunning/archive/refs/heads/master.zip) and unzip them.
2. Navigate to `%localappdata%\Plutonium\storage\t6\scripts\zm`
3. Place the files into their respective map's folder. If the map's folder doesn't exist, create it and place it into the path from step 2.
- `die_rise_any_player_ee.gsc` goes to `zm_highrise`
- `buried_any_player_ee.gsc` goes to `zm_buried`

## Die Rise

### Elevators Step and Dragon Puzzle
Require the same amount as the number of players. If the Dragon Puzzle step is failed, it will reset back to require the same amount as the number of players.

If you wish for the Dragon Puzzle step to not reset once an incorrect symbol is stepped on, then commenting out the lines 159 to 160 is necessary. This can be done by either of the following:
- 1st method: comment out the entire `else` statement by adding `/*` before the `else` on line 154, and `*/` after the `}` on line 162:-
```
                /*else
                {
                        if ( !flag( "sq_atd_drg_puzzle_1st_error" ) )
                                level thread vo_maxis_atd_order_error();

                        level.sq_atd_cur_drg = 4 - custom_get_number_of_players();
                        level notify( "drg_puzzle_reset" );
                        wait 0.5;
                }*/
```
- 2nd method: comment out just lines 159 and 160 by adding `/*` at the beginning of line 159, and `*/` at the end of line 160:-
```
                        /*level.sq_atd_cur_drg = 4 - custom_get_number_of_players();
                        level notify( "drg_puzzle_reset" );*/
```

### Trample Steam step:
#### Maxis Side
- If the number of players is 2 or less, the players will have the ability to place both balls on the same set of Trample Steams.
- If the player is playing solo or 3p:
  - once the player picks up a ball, gives the player the ability to place the ball on an already correctly placed Trample Steam without needing a Trample Steam on the opposite end. On 3p, this is executed if the ball is picked up while there's already a ball flinging; and
  - once a player places a Trample Steam correctly, gives each player already carrying a ball the ability to place it without needing a Trample Steam on the opposite end. On 3p, this is executed if the Trample Steam is placed while there's already a ball flinging.
- On 3p, flinging a ball will make each player carrying a ball be able to place it on the lone Trample Steam.

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
