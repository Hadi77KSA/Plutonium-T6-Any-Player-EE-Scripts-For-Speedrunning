#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried_sq;
#include maps\mp\zm_buried_sq_ctw;
#include maps\mp\zm_buried_sq_ip;
#include maps\mp\zm_buried_sq_ows;
#include maps\mp\zm_buried_sq_tpo;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( ::_are_all_players_in_time_bomb_volume, ::_are_all_players_in_time_bomb_volume_qol );
	replaceFunc( ::ctw_max_start_wisp, ::custom_ctw_max_start_wisp);
	replaceFunc( ::sq_bp_set_current_bulb, ::custom_sq_bp_set_current_bulb);
	replaceFunc( ::ows_target_delete_timer, ::new_ows_target_delete_timer );
	replaceFunc( ::ows_targets_start, ::new_ows_targets_start);
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
		player iPrintLn( "^2Any Player EE Mod ^5Buried" );
	}
}

playertracker_onlast_step()
{
	players = getPlayers();
	switch ( players.size )
	{
		case 1:
			level.targets_allowed_to_be_missed = 64; // Total (84) - ( Candy Shop (20) )
			break;
		case 2:
			level.targets_allowed_to_be_missed = 45; // Total (84) - ( Candy Shop (20) + Saloon (19) )
			break;
		default: //All 4 areas of the map
			level.targets_allowed_to_be_missed = 0;
	}
}

_are_all_players_in_time_bomb_volume_qol( e_volume )
{
	n_required_players = 4;
	a_players = get_players();
	if ( getPlayers().size <= 3 )
		n_required_players = a_players.size;

	n_players_in_position = 0;

	foreach ( player in a_players )
	{
		if ( player istouching( e_volume ) )
			n_players_in_position++;
	}

	b_all_in_valid_position = n_players_in_position == n_required_players;
	return b_all_in_valid_position;
}

custom_ctw_max_start_wisp()
{
	nd_start = getvehiclenode( level.m_sq_start_sign.target, "targetname" );
	vh_wisp = spawnvehicle( "tag_origin", "wisp_ai", "heli_quadrotor2_zm", nd_start.origin, nd_start.angles );
	vh_wisp makevehicleunusable();
	level.vh_wisp = vh_wisp;
	vh_wisp.n_sq_max_energy = 30;
	vh_wisp.n_sq_energy = vh_wisp.n_sq_max_energy;
	vh_wisp thread ctw_max_wisp_play_fx();
	vh_wisp_mover = spawn( "script_model", vh_wisp.origin );
	vh_wisp_mover setmodel( "tag_origin" );
	vh_wisp linkto( vh_wisp_mover );
	vh_wisp_mover wisp_move_from_sign_to_start( nd_start );
	vh_wisp unlink();
	vh_wisp_mover delete();
	vh_wisp attachpath( nd_start );
	vh_wisp startpath();
	vh_wisp thread ctw_max_success_watch();
	vh_wisp thread ctw_max_fail_watch();
	vh_wisp thread ctw_max_wisp_enery_watch();
	vh_wisp thread buried_maxis_wisp();
	wait_network_frame();
	flag_wait_any( "sq_wisp_success", "sq_wisp_failed" );
	vh_wisp cancelaimove();
	vh_wisp clearvehgoalpos();
	vh_wisp delete();

	if ( isdefined( level.vh_wisp ) )
		level.vh_wisp delete();
}

buried_maxis_wisp()
{
	self endon( "death" );

	if ( getPlayers().size <= 2 )
	{
		while ( true )
		{
			if ( self.n_sq_energy <= 20 )
				self.n_sq_energy += 20;

			wait 1;
		}
	}
}

custom_sq_bp_set_current_bulb( str_tag )
{
	level endon( "sq_bp_correct_button" );
	level endon( "sq_bp_wrong_button" );
	level endon( "sq_bp_timeout" );

	if ( isdefined( level.m_sq_bp_active_light ) )
		level.str_sq_bp_active_light = "";

	level.m_sq_bp_active_light = sq_bp_light_on( str_tag, "yellow" );
	level.str_sq_bp_active_light = str_tag;
	if ( getPlayers().size > 2 )
	{
		wait 10;
		level notify( "sq_bp_timeout" );
	}
}

new_ows_target_delete_timer()
{
	self endon( "death" );
	wait 4;
	self notify( "ows_target_timeout" );
	level.targets_allowed_to_be_missed--;
	if ( level.targets_allowed_to_be_missed < 0 )
		flag_set( "sq_ows_target_missed" );
}

new_ows_targets_start()
{
	n_cur_second = 0;
	flag_clear( "sq_ows_target_missed" );
	playertracker_onlast_step();
	level thread sndsidequestowsmusic();
	a_sign_spots = getstructarray( "otw_target_spot", "script_noteworthy" );

	while ( n_cur_second < 40 )
	{
		a_spawn_spots = ows_targets_get_cur_spots( n_cur_second );

		if ( isdefined( a_spawn_spots ) && a_spawn_spots.size > 0 )
			ows_targets_spawn( a_spawn_spots );

		wait 1;
		n_cur_second++;
	}

	if ( !flag( "sq_ows_target_missed" ) )
	{
		flag_set( "sq_ows_success" );
		playsoundatposition( "zmb_sq_target_success", ( 0, 0, 0 ) );
	}
	else
		playsoundatposition( "zmb_sq_target_fail", ( 0, 0, 0 ) );

	level notify( "sndEndOWSMusic" );
}
