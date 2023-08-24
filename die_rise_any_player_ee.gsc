#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_highrise_sq;
#include maps\mp\zm_highrise_sq_atd;
#include maps\mp\zm_highrise_sq_pts;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( ::sq_atd_elevators, ::custom_sq_atd_elevators );
	replaceFunc( ::sq_atd_drg_puzzle, ::custom_sq_atd_drg_puzzle );
	replaceFunc( ::drg_puzzle_trig_think, ::custom_drg_puzzle_trig_think );
	replaceFunc( ::wait_for_all_springpads_placed, ::custom_wait_for_all_springpads_placed );
	replaceFunc( ::springpad_count_watcher, ::custom_springpad_count_watcher );
	replaceFunc( ::pts_should_player_create_trigs, ::custom_pts_should_player_create_trigs );
	replaceFunc( ::pts_should_springpad_create_trigs, ::custom_pts_should_springpad_create_trigs );
	replaceFunc( ::pts_putdown_trigs_create_for_spot, ::custom_pts_putdown_trigs_create_for_spot );
	replaceFunc( ::place_ball_think, ::custom_place_ball_think );
}

init()
{
	thread onplayerconnect();
}

onplayerconnect()
{
	while(true)
	{
		level waittill("connecting", player);
		player iPrintLn( "^2Any Player EE Mod ^5Die Rise" );
	}
}

//Elevator Stand step

//makes elevator symbols require as many symbols as players
custom_sq_atd_elevators()
{
	a_elevators = array( "elevator_bldg1b_trigger", "elevator_bldg1d_trigger", "elevator_bldg3b_trigger", "elevator_bldg3c_trigger" );
	a_elevator_flags = array( "sq_atd_elevator0", "sq_atd_elevator1", "sq_atd_elevator2", "sq_atd_elevator3" );

	for ( i = 0; i < a_elevators.size; i++ )
	{
		trig_elevator = getent( a_elevators[i], "targetname" );
		trig_elevator thread sq_atd_watch_elevator( a_elevator_flags[i] );
	}

	while ( !standing_on_enough_elevators_check( a_elevator_flags ) )
	{
		flag_wait_any_array( a_elevator_flags );
		wait 0.5;
	}
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
standing_on_enough_elevators_check( a_elevator_flags )
{
	n_players_standing_on_elevator = 0;

	foreach( m_elevator_flag in a_elevator_flags )
	{
		if( flag( m_elevator_flag ) )
			n_players_standing_on_elevator++;
	}

	return n_players_standing_on_elevator >= custom_get_number_of_players();
}

//Dragon Puzzle step

//initialises the floor symbols to require as many symbols as players
custom_sq_atd_drg_puzzle()
{
	level.sq_atd_cur_drg = 4 - custom_get_number_of_players();
	a_puzzle_trigs = getentarray( "trig_atd_drg_puzzle", "targetname" );
	a_puzzle_trigs = array_randomize( a_puzzle_trigs );

	for ( i = 0; i < a_puzzle_trigs.size; i++ )
		a_puzzle_trigs[i] thread drg_puzzle_trig_think( i );

	while ( level.sq_atd_cur_drg < 4 )
		wait 1;

	flag_set( "sq_atd_drg_puzzle_complete" );
	level thread vo_maxis_atd_order_complete();
}

//when floor symbols reset, they reset back to require as many symbols as players
custom_drg_puzzle_trig_think( n_order_id )
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
			self thread drg_puzzle_trig_watch_fade( m_lit, m_unlit, v_top, v_hidden );
		}
		else
		{
			if ( !flag( "sq_atd_drg_puzzle_1st_error" ) )
				level thread vo_maxis_atd_order_error();

			level.sq_atd_cur_drg = 4 - custom_get_number_of_players();
			level notify( "drg_puzzle_reset" );
			wait 0.5;
		}

		while ( e_who istouching( self ) )
			wait 0.5;
	}
}

//returns the number of players, and if the number is greater than 4, returns 4. Used for specific steps
custom_get_number_of_players()
{
	n_players = getPlayers().size;
	if( n_players > 4 )
		n_players = 4;

	return n_players;
}

// Trample Steam steps

//if the number of players is less than or equal to 2 and a ball is placed for the Maxis Trample Steam step, keeps the trigger to place a new ball for the Trample Steam it was placed on and the one opposite from it
//if the number of players is 3, creates trigs for each player already carrying a ball to enable them to place the ball on the lone Trample Steam if the Trample Steam was correctly placed before the 1st ball is launched.
custom_place_ball_think( t_place_ball, s_lion_spot )
{
	t_place_ball endon( "delete" );

	t_place_ball waittill( "trigger" );

	a_players = getPlayers();
	if ( a_players.size > 2 )
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
	s_lion_spot.springpad thread pts_springpad_fling( s_lion_spot.script_noteworthy, s_lion_spot.springpad_buddy.springpad );
	self.t_putdown_ball delete();

	if ( a_players.size == 3 )
	{
		foreach ( player in a_players )
		{
			if ( isdefined( player.zm_sq_has_ball ) && player.zm_sq_has_ball )
				pts_should_placing_ball_create_trigs( s_lion_spot, player );
		}
	}
}

//once a player flings a ball, gives each player already carrying a ball the ability to place it on the Trample Steam(s) placed on the other set of symbols than the ones on which the ball was flung.
pts_should_placing_ball_create_trigs( s_lion_spot_used, player )
{
	a_lion_spots = getstructarray( "pts_lion", "targetname" );

	foreach ( s_lion_spot in a_lion_spots )
	{
		if ( isdefined( s_lion_spot.springpad ) && s_lion_spot != s_lion_spot_used && s_lion_spot.springpad_buddy != s_lion_spot_used )
			pts_putdown_trigs_create_for_spot( s_lion_spot, player );
	}
}

//on the Maxis side if the player is playing solo or 3p, once the player picks up a ball, gives the player the ability to place the ball on an already correctly placed Trample Steam without needing a Trample Steam on the opposite end. On 3p, this is executed if the ball is picked up while there's already a ball flinging.
custom_pts_should_player_create_trigs( player )
{
	a_lion_spots = getstructarray( "pts_lion", "targetname" );
	players = getPlayers();

	foreach ( s_lion_spot in a_lion_spots )
	{
		if ( isdefined( s_lion_spot.springpad ) && ( isdefined( s_lion_spot.springpad_buddy.springpad ) || players.size == 1 || ( players.size == 3 && flag( "pts_2_generator_1_started" ) ) ) )
			pts_putdown_trigs_create_for_spot( s_lion_spot, player );
	}
}

//on the Maxis side if the player is playing solo or 3p, once a player places a Trample Steam correctly, gives each player already carrying a ball the ability to place it without needing a Trample Steam on the opposite end. On 3p, this is executed if the Trample Steam is placed while there's already a ball flinging.
custom_pts_should_springpad_create_trigs( s_lion_spot )
{
	if ( isdefined( s_lion_spot.springpad ) && ( isdefined( s_lion_spot.springpad_buddy.springpad ) || getPlayers().size == 1 || ( getPlayers().size == 3 && flag( "pts_2_generator_1_started" ) ) ) )
	{
		a_players = getplayers();

		foreach ( player in a_players )
		{
			if ( isdefined( player.zm_sq_has_ball ) && player.zm_sq_has_ball )
			{
				pts_putdown_trigs_create_for_spot( s_lion_spot, player );
				if ( isdefined( s_lion_spot.springpad_buddy.springpad ) )
					pts_putdown_trigs_create_for_spot( s_lion_spot.springpad_buddy, player );
			}
		}
	}
}

//if the number of players is 2 or less, once a ball is picked up, gives the ability to place a 2nd ball on a set of Trample Steams that already has a ball flinging from them for the Maxis Trample Steam step
custom_pts_putdown_trigs_create_for_spot( s_lion_spot, player )
{
	if ( ( isdefined( s_lion_spot.which_ball ) || isdefined( s_lion_spot.springpad_buddy ) && isdefined( s_lion_spot.springpad_buddy.which_ball ) ) && getPlayers().size > 2 )
		return;

	t_place_ball = sq_pts_create_use_trigger( s_lion_spot.origin, 16, 70, &"ZM_HIGHRISE_SQ_PUTDOWN_BALL" );
	player clientclaimtrigger( t_place_ball );
	t_place_ball.owner = player;
	player thread place_ball_think( t_place_ball, s_lion_spot );

	if( !isdefined( s_lion_spot.pts_putdown_trigs ) )
		s_lion_spot.pts_putdown_trigs = [];

	s_lion_spot.pts_putdown_trigs[player.characterindex] = t_place_ball;
	level thread pts_putdown_trigs_springpad_delete_watcher( player, s_lion_spot );
}

//quotes skip for Richtofen Trample Steams
custom_springpad_count_watcher( is_generator )
{
	level endon( "sq_pts_springad_count4" );
	str_which_spots = "pts_ghoul";

	if ( is_generator )
		str_which_spots = "pts_lion";

	a_spots = getstructarray( str_which_spots, "targetname" );

	while ( true )
	{
		level waittill( "sq_pts_springpad_in_place" );

		n_count = 0;

		foreach ( s_spot in a_spots )
		{
			if ( isdefined( s_spot.springpad ) )
				n_count++;
		}

		level notify( "sq_pts_springad_count" + n_count );

		n_players = custom_get_number_of_players();
		while ( !is_generator && n_count >= n_players && n_count < 4 )
		{
			wait 7;
			n_count++;
			level notify( "sq_pts_springad_count" + n_count );
		}
	}
}

//makes Richtofen Trample Steam step require as many as players
custom_wait_for_all_springpads_placed( str_type, str_flag )
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

		if ( !( is_clear > ( 4 - custom_get_number_of_players() ) ) )
			flag_set( str_flag );

		wait 1;
	}
}
