#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried_sq;

main()
{
	replaceFunc( ::sq_metagame, ::custom_sq_metagame );
}

init()
{
	thread onPlayerConnect();
}

onPlayerConnect()
{
	while ( 1 )
	{
		level waittill( "connected", player );
		player iPrintLn( "^2Any Player EE Mod ^5Super Easter Egg" );
	}
}

custom_sq_metagame()
{
	level endon( "sq_metagame_player_connected" );
	flag_wait( "sq_intro_vo_done" );

	if ( flag( "sq_started" ) )
		level waittill( "buried_sidequest_achieved" );

	level thread sq_metagame_turn_off_watcher();
	is_blue_on = 0;
	is_orange_on = 0;
	m_endgame_machine = getstruct( "sq_endgame_machine", "targetname" );
	a_tags = [];
	a_tags[0][0] = "TAG_LIGHT_1";
	a_tags[0][1] = "TAG_LIGHT_2";
	a_tags[0][2] = "TAG_LIGHT_3";
	a_tags[1][0] = "TAG_LIGHT_4";
	a_tags[1][1] = "TAG_LIGHT_5";
	a_tags[1][2] = "TAG_LIGHT_6";
	a_tags[2][0] = "TAG_LIGHT_7";
	a_tags[2][1] = "TAG_LIGHT_8";
	a_tags[2][2] = "TAG_LIGHT_9";
	a_tags[3][0] = "TAG_LIGHT_10";
	a_tags[3][1] = "TAG_LIGHT_11";
	a_tags[3][2] = "TAG_LIGHT_12";
	a_stat = [];
	a_stat[0] = "sq_transit_last_completed";
	a_stat[1] = "sq_highrise_last_completed";
	a_stat[2] = "sq_buried_last_completed";
	a_stat_nav = [];
	a_stat_nav[0] = "navcard_applied_zm_transit";
	a_stat_nav[1] = "navcard_applied_zm_highrise";
	a_stat_nav[2] = "navcard_applied_zm_buried";
	a_stat_nav_held = [];
	a_stat_nav_held[0] = "navcard_applied_zm_transit";
	a_stat_nav_held[1] = "navcard_applied_zm_highrise";
	a_stat_nav_held[2] = "navcard_applied_zm_buried";
	bulb_on = [];
	bulb_on[0] = 0;
	bulb_on[1] = 0;
	bulb_on[2] = 0;
	level.n_metagame_machine_lights_on = 0;
	flag_wait( "start_zombie_round_logic" );
	sq_metagame_clear_lights();
	players = get_players();
	player_count = players.size;
	if ( player_count > 4 ) //in case of more than 4 players, only checks the progress of 4 players
		player_count = 4;

	for ( n_player = 0; n_player < player_count; n_player++ )
	{
		for ( n_stat = 0; n_stat < a_stat.size; n_stat++ )
		{
			if ( isdefined( players[n_player] ) )
			{
				n_stat_value = players[n_player] maps\mp\zombies\_zm_stats::get_global_stat( a_stat[n_stat] );
				n_stat_nav_value = players[n_player] maps\mp\zombies\_zm_stats::get_global_stat( a_stat_nav[n_stat] );
			}

			if ( n_stat_value == 1 )
			{
				m_endgame_machine sq_metagame_machine_set_light( n_player, n_stat, "sq_bulb_blue" );
				is_blue_on = 1;
			}
			else if ( n_stat_value == 2 )
			{
				m_endgame_machine sq_metagame_machine_set_light( n_player, n_stat, "sq_bulb_orange" );
				is_orange_on = 1;
			}

			if ( n_stat_nav_value )
			{
				level setclientfield( "buried_sq_egm_bulb_" + n_stat, 1 );
				bulb_on[n_stat] = 1;
			}
		}
	}

	if ( level.n_metagame_machine_lights_on == player_count * 3 ) //changed to adapt to the number of players
	{
		if ( is_blue_on && is_orange_on )
			return;
		else if ( !bulb_on[0] || !bulb_on[1] || !bulb_on[2] )
			return;
	}
	else
		return;

	m_endgame_machine.activate_trig = spawn( "trigger_radius", m_endgame_machine.origin, 0, 128, 72 );

	m_endgame_machine.activate_trig waittill( "trigger" );

	m_endgame_machine.activate_trig delete();
	m_endgame_machine.activate_trig = undefined;
	level setclientfield( "buried_sq_egm_animate", 1 );
	m_endgame_machine.endgame_trig = spawn( "trigger_radius_use", m_endgame_machine.origin, 0, 16, 16 );
	m_endgame_machine.endgame_trig setcursorhint( "HINT_NOICON" );
	m_endgame_machine.endgame_trig sethintstring( &"ZM_BURIED_SQ_EGM_BUT" );
	m_endgame_machine.endgame_trig triggerignoreteam();
	m_endgame_machine.endgame_trig usetriggerrequirelookat();

	m_endgame_machine.endgame_trig waittill( "trigger" );

	m_endgame_machine.endgame_trig delete();
	m_endgame_machine.endgame_trig = undefined;
	level thread sq_metagame_clear_tower_pieces();
	playsoundatposition( "zmb_endgame_mach_button", m_endgame_machine.origin );
	players = get_players();

	foreach ( player in players )
	{
		for ( i = 0; i < a_stat.size; i++ )
		{
			player maps\mp\zombies\_zm_stats::set_global_stat( a_stat[i], 0 );
			player maps\mp\zombies\_zm_stats::set_global_stat( a_stat_nav_held[i], 0 );
			player maps\mp\zombies\_zm_stats::set_global_stat( a_stat_nav[i], 0 );
		}
	}

	sq_metagame_clear_lights();

	if ( is_orange_on )
		level notify( "end_game_reward_starts_maxis" );
	else
		level notify( "end_game_reward_starts_richtofen" );
}
