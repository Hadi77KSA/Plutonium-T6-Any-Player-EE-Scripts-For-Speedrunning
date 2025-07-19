#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_transit_sq;

main()
{
	replaceFunc( maps\mp\zm_transit_sq::maxis_sidequest_b, ::maxis_sidequest_b );
	replaceFunc( maps\mp\zm_transit_sq::get_how_many_progressed_from, ::get_how_many_progressed_from );
}

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
		thread onPlayerConnect();
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
	self iPrintLn( "^2Any Player EE Mod ^5TranZit Maxis" );
}

maxis_sidequest_b()
{
	level endon( "power_on" );

	while ( true )
	{
		level waittill( "stun_avogadro", avogadro );

		if ( isdefined( level.sq_progress["maxis"]["A_turbine_1"] ) && is_true( level.sq_progress["maxis"]["A_turbine_1"].powered ) && ( ( isdefined( level.sq_progress["maxis"]["A_turbine_2"] ) && is_true( level.sq_progress["maxis"]["A_turbine_2"].powered ) ) || getPlayers().size == 1 ) )
		{
			if ( isdefined( avogadro ) && avogadro istouching( level.sq_volume ) )
			{
				level notify( "end_avogadro_turbines" );
				break;
			}
		}
	}

	level notify( "maxis_stage_b" );
	level thread maxissay( "vox_maxi_avogadro_emp_0", ( 7737, -416, -142 ) );
	update_sidequest_stats( "sq_transit_maxis_stage_3" );
	player = get_players();
	player[0] setclientfield( "sq_tower_sparks", 1 );
	player[0] setclientfield( "screecher_maxis_lights", 1 );
	level thread maxis_sidequest_complete_check( "B_complete" );
}

get_how_many_progressed_from( story, a, b )
{
	n_players = getPlayers().size;

	if ( ( isdefined( level.sq_progress[story][a] ) && !isdefined( level.sq_progress[story][b] ) || !isdefined( level.sq_progress[story][a] ) && isdefined( level.sq_progress[story][b] ) ) && n_players > 1 )
		return 1;
	else if ( isdefined( level.sq_progress[story][a] ) && ( isdefined( level.sq_progress[story][b] ) || n_players == 1 ) )
		return 2;

	return 0;
}
