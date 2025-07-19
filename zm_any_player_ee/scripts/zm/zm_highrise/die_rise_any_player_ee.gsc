#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_highrise_sq_atd;
#include maps\mp\zm_highrise_sq_pts;

main()
{
	replaceFunc( maps\mp\zm_highrise_sq_atd::sq_atd_elevators, ::sq_atd_elevators );
	replaceFunc( maps\mp\zm_highrise_sq_atd::sq_atd_drg_puzzle, ::sq_atd_drg_puzzle );
	replaceFunc( maps\mp\zm_highrise_sq_atd::drg_puzzle_trig_think, ::drg_puzzle_trig_think );
	replaceFunc( maps\mp\zm_highrise_sq_pts::wait_for_all_springpads_placed, ::wait_for_all_springpads_placed );
	replaceFunc( maps\mp\zm_highrise_sq_pts::pts_should_player_create_trigs, ::pts_should_player_create_trigs );
	replaceFunc( maps\mp\zm_highrise_sq_pts::pts_should_springpad_create_trigs, ::pts_should_springpad_create_trigs );
	replaceFunc( maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot, ::pts_putdown_trigs_create_for_spot );
	replaceFunc( maps\mp\zm_highrise_sq_pts::place_ball_think, ::place_ball_think );
}

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
	{
		thread onPlayerConnect();

		if ( set_dvar_int_if_unset( "any_player_ee_highrise_nav", "1" ) )
			thread spawn_navcomputer();

		thread sq_pts_springad_count();
	}
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread msg();
	}
}

msg()
{
	self endon( "disconnect" );
	flag_wait( "initial_players_connected" );
	self iPrintLn( "^2Any Player EE Mod ^5Die Rise" );
}

//Force build navcard table
spawn_navcomputer()
{
	flag_wait( "initial_players_connected" );

	for ( i = 0; i < get_players().size; i++ )
	{
		if ( !get_players()[i] maps\mp\zombies\_zm_stats::get_global_stat( "sq_highrise_started" ) )
			maps\mp\zm_highrise_sq::update_sidequest_stats( "sq_highrise_started" );
	}
}

sq_pts_springad_count()
{
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;

	if ( level.maxcompleted && level.richcompleted )
		return;

	level waittill( "sq_slb_over" );

	if ( !level.richcompleted )
		thread sq_1();

	if ( !level.maxcompleted )
		thread sq_2();
}

//returns the number of players, and if the number is greater than 4, returns 4. Used for specific steps
num_player_valid( is_generator )
{
	n_players = getPlayers().size;

	if ( isdefined( is_generator ) && !is_generator && isdefined( level.pts_ghoul ) )
		n_players = level.pts_ghoul;

	if ( n_players > 4 )
		n_players = 4;

	return n_players;
}

//Elevator Stand step

//makes elevator symbols require as many symbols as players
sq_atd_elevators()
{
	a_elevators = array( "elevator_bldg1b_trigger", "elevator_bldg1d_trigger", "elevator_bldg3b_trigger", "elevator_bldg3c_trigger" );
	a_elevator_flags = array( "sq_atd_elevator0", "sq_atd_elevator1", "sq_atd_elevator2", "sq_atd_elevator3" );

	for ( i = 0; i < a_elevators.size; i++ )
	{
		trig_elevator = getent( a_elevators[i], "targetname" );
		trig_elevator thread sq_atd_watch_elevator( a_elevator_flags[i] );
	}

	while ( !sq_atd_elevator_activated( a_elevator_flags ) )
	{
		flag_wait_any_array( a_elevator_flags );
		wait 0.5;
	}

/#
	iprintlnbold( "Standing on Elevators Complete" );
#/
	a_dragon_icons = getentarray( "elevator_dragon_icon", "targetname" );

	foreach ( m_icon in a_dragon_icons )
	{
		v_off_pos = m_icon.m_lit_icon.origin;
		m_icon.m_lit_icon unlink();
		m_icon unlink();
		m_icon.m_lit_icon.origin = m_icon.origin;
		m_icon.origin = v_off_pos;
		m_icon.m_lit_icon linkto( m_icon.m_elevator );
		m_icon linkto( m_icon.m_elevator );
		m_icon playsound( "zmb_sq_symbol_light" );
	}

	flag_set( "sq_atd_elevator_activated" );
	vo_richtofen_atd_elevators();
	level thread vo_maxis_atd_elevators();
}

//checks if the players are standing on enough elevators
sq_atd_elevator_activated( a_elevator_flags )
{
	sq_atd_elevator_activated = 0;

	for ( i = 0; i < a_elevator_flags.size; i++ )
	{
		if ( flag( a_elevator_flags[i] ) )
			sq_atd_elevator_activated++;
	}

	return sq_atd_elevator_activated >= num_player_valid();
}

//Dragon Puzzle step

//initialises the floor symbols to require as many symbols as players
sq_atd_drg_puzzle()
{
	level.sq_atd_cur_drg = 4 - num_player_valid();
	a_puzzle_trigs = getentarray( "trig_atd_drg_puzzle", "targetname" );
	a_puzzle_trigs = array_randomize( a_puzzle_trigs );

	for ( i = 0; i < a_puzzle_trigs.size; i++ )
		a_puzzle_trigs[i] thread maps\mp\zm_highrise_sq_atd::drg_puzzle_trig_think( i );

	while ( level.sq_atd_cur_drg < 4 )
		wait 1;

	flag_set( "sq_atd_drg_puzzle_complete" );
	level thread vo_maxis_atd_order_complete();
/#
	iprintlnbold( "Dragon Puzzle COMPLETE" );
#/
}

//when floor symbols reset, they reset back to require as many symbols as players
drg_puzzle_trig_think( n_order_id )
{
	self.drg_active = 0;
	m_unlit = getent( self.target, "targetname" );
	m_lit = m_unlit.lit_icon;
	v_top = m_unlit.origin;
	v_hidden = m_lit.origin;

	while ( !flag( "sq_atd_drg_puzzle_complete" ) )
	{
		if ( self.drg_active )
		{
			level waittill_either( "sq_atd_drg_puzzle_complete", "drg_puzzle_reset" );

			if ( flag( "sq_atd_drg_puzzle_complete" ) )
				continue;
		}

		self waittill( "trigger", e_who );

		if ( level.sq_atd_cur_drg == n_order_id )
		{
			m_lit.origin = v_top;
			m_unlit.origin = v_hidden;
			m_lit playsound( "zmb_sq_symbol_light" );
			self.drg_active = 1;
			level thread vo_richtofen_atd_order( level.sq_atd_cur_drg );
			level.sq_atd_cur_drg++;
/#
			iprintlnbold( "Dragon " + n_order_id + " Correct" );
#/
			self thread drg_puzzle_trig_watch_fade( m_lit, m_unlit, v_top, v_hidden );
		}
		else
		{
			if ( !flag( "sq_atd_drg_puzzle_1st_error" ) )
				level thread vo_maxis_atd_order_error();

			level.sq_atd_cur_drg = 4 - num_player_valid();
			level notify( "drg_puzzle_reset" );
/#
			iprintlnbold( "INCORRECT DRAGON" );
#/
			wait 0.5;
		}

		while ( e_who istouching( self ) )
			wait 0.5;
	}
}

// Trample Steam steps

sq_1()
{
	level endon( "sq_ball_picked_up" );
	level waittill( "sq_1" + "_" + "pts_1" + "_started" );
	level.pts_ghoul = get_players().size;

	for ( i = 0; i < get_players().size; i++ )
		get_players()[i] thread onPlayerDisconnect( 0 );

	level waittill( "pts_1_springpads_placed" );
	level.pts_ghoul = undefined;
}

sq_2()
{
	level waittill( "sq_2" + "_" + "pts_2" + "_started" );
	level.pts_lion = get_players().size;

	for ( i = 0; i < get_players().size; i++ )
		get_players()[i] thread onPlayerDisconnect( 1 );
}

onPlayerDisconnect( is_generator )
{
	if ( !is_generator )
		level endon( "pts_1_springpads_placed" );

	self waittill( "disconnect" );

	if ( is_generator )
	{
		if ( isdefined( level.pts_lion ) )
			level.pts_lion--;
	}
	else
	{
		if ( isdefined( level.pts_ghoul ) )
			level.pts_ghoul--;
	}
}

//if the number of players is less than or equal to 3 and a ball is placed for the Maxis Trample Steam step, keeps the trigger to place a new ball for the Trample Steam it was placed on and the one opposite from it
//if the number of players is 3, creates trigs for each player already carrying a ball to enable them to place the ball on the lone Trample Steam if the Trample Steam was correctly placed before the 1st ball is launched.
place_ball_think( t_place_ball, s_lion_spot )
{
	t_place_ball endon( "delete" );
	t_place_ball waittill( "trigger" );

	if ( !isdefined( level.pts_lion ) || level.pts_lion > 3 )
	{
		pts_putdown_trigs_remove_for_spot( s_lion_spot );
		pts_putdown_trigs_remove_for_spot( s_lion_spot.springpad_buddy );
	}

	self.zm_sq_has_ball = undefined;
	s_lion_spot.which_ball = self.which_ball;
	self notify( "zm_sq_ball_used" );
	s_lion_spot.zm_pts_animating = 1;
	s_lion_spot.springpad_buddy.zm_pts_animating = 1;
	flag_set( "pts_2_generator_" + level.current_generator + "_started" );
	s_lion_spot.which_generator = level.current_generator;
	level.current_generator++;
/#
	iprintlnbold( "Ball Animating" );
#/
	if ( !isdefined( s_lion_spot.springpad_buddy.springpad ) )
		s_lion_spot.springpad_buddy.springpad = s_lion_spot.springpad;

	s_lion_spot.springpad thread pts_springpad_fling( s_lion_spot.script_noteworthy, s_lion_spot.springpad_buddy.springpad );
	self.t_putdown_ball delete();

	//once a player flings a ball, gives each player already carrying a ball the ability to place it on the Trample Steam(s) placed on the other set of symbols than the ones on which the ball was flung.
	if ( isdefined( level.pts_lion ) && level.pts_lion == 3 )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( isdefined( level.players[i].zm_sq_has_ball ) && level.players[i].zm_sq_has_ball )
			{
				foreach ( s_spot in getstructarray( "pts_lion", "targetname" ) )
				{
					if ( isdefined( s_spot.springpad ) && s_spot != s_lion_spot && s_spot.springpad_buddy != s_lion_spot )
						maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( s_spot, level.players[i] );
				}
			}
		}
	}
}

//makes Richtofen Trample Steam step require as many as players
wait_for_all_springpads_placed( str_type, str_flag )
{
	a_spots = getstructarray( str_type, "targetname" );

	while ( !flag( str_flag ) )
	{
		is_clear = 0;

		foreach ( s_spot in a_spots )
		{
			if ( !isdefined( s_spot.springpad ) )
				is_clear++;
		}

		if ( is_clear <= 4 - num_player_valid( 0 ) )
			flag_set( str_flag );

		wait 1;
	}
}

//on the Maxis side if the player is playing solo or 3p, once the player picks up a ball, gives the player the ability to place the ball on an already correctly placed Trample Steam without needing a Trample Steam on the opposite end. On 3p, this is executed if the ball is picked up while there's already a ball flinging.
pts_should_player_create_trigs( player )
{
	a_lion_spots = getstructarray( "pts_lion", "targetname" );

	foreach ( s_lion_spot in a_lion_spots )
	{
		if ( isdefined( s_lion_spot.springpad ) && ( isdefined( s_lion_spot.springpad_buddy.springpad ) || ( isdefined( level.pts_lion ) && ( level.pts_lion == 1 || ( level.pts_lion == 3 && flag( "pts_2_generator_1_started" ) ) ) ) ) )
			maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( s_lion_spot, player );
	}
}

//on the Maxis side if the player is playing solo or 3p, once a player places a Trample Steam correctly, gives each player already carrying a ball the ability to place it without needing a Trample Steam on the opposite end. On 3p, this is executed if the Trample Steam is placed while there's already a ball flinging.
pts_should_springpad_create_trigs( s_lion_spot )
{
	if ( isdefined( s_lion_spot.springpad ) && isdefined( s_lion_spot.springpad_buddy ) && ( isdefined( s_lion_spot.springpad_buddy.springpad ) || ( isdefined( level.pts_lion ) && ( level.pts_lion == 1 || ( level.pts_lion == 3 && flag( "pts_2_generator_1_started" ) ) ) ) ) )
	{
		a_players = getplayers();

		foreach ( player in a_players )
		{
			if ( isdefined( player.zm_sq_has_ball ) && player.zm_sq_has_ball )
			{
				maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( s_lion_spot, player );

				if ( isdefined( s_lion_spot.springpad_buddy.springpad ) )
					maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( s_lion_spot.springpad_buddy, player );
			}
		}
	}
}

//if the number of players is 3 or less, once a ball is picked up, gives the ability to place a 2nd ball on a set of Trample Steams that already has a ball flinging from them for the Maxis Trample Steam step
pts_putdown_trigs_create_for_spot( s_lion_spot, player )
{
	if ( ( !isdefined( level.pts_lion ) || level.pts_lion >= 4 ) && ( isdefined( s_lion_spot.which_ball ) || isdefined( s_lion_spot.springpad_buddy ) && isdefined( s_lion_spot.springpad_buddy.which_ball ) ) )
		return;

	t_place_ball = sq_pts_create_use_trigger( s_lion_spot.origin, 16, 70, &"ZM_HIGHRISE_SQ_PUTDOWN_BALL" );
	player clientclaimtrigger( t_place_ball );
	t_place_ball.owner = player;
	player thread maps\mp\zm_highrise_sq_pts::place_ball_think( t_place_ball, s_lion_spot );

	if ( !isdefined( s_lion_spot.pts_putdown_trigs ) )
		s_lion_spot.pts_putdown_trigs = [];

	s_lion_spot.pts_putdown_trigs[player.characterindex] = t_place_ball;
	level thread pts_putdown_trigs_springpad_delete_watcher( player, s_lion_spot );
}
