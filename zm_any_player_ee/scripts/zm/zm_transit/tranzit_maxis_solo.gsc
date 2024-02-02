#include maps\mp\zm_transit_utility;
#include maps\mp\zm_transit_sq;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	if( getPlayers() <= 1 )
	{
		replaceFunc(maps\mp\zm_transit_sq::get_how_many_progressed_from, ::custom_get_how_many_progressed_from);
		replaceFunc(maps\mp\zm_transit_sq::maxis_sidequest_b, ::custom_maxis_sidequest_b);
	}
}

custom_get_how_many_progressed_from( story, a, b )
{
	if ( isDefined( level.sq_progress[ story ][ a ] ) || isDefined( level.sq_progress[ story ][ b ] ) )
	{
		return 2;
	}
	return 0;
}

custom_maxis_sidequest_b()
{
	level endon( "power_on" );
	while ( 1 )
	{
		level waittill( "stun_avogadro", avogadro );
		if ( isDefined( level.sq_progress[ "maxis" ][ "A_turbine_1" ] ) && is_true( level.sq_progress[ "maxis" ][ "A_turbine_1" ].powered ) )
		{
			if ( isDefined( avogadro ) && avogadro istouching( level.sq_volume ) )
			{
				level notify( "end_avogadro_turbines" );
				break;
			}
		}
		else
		{
		}
	}
	level notify( "maxis_stage_b" );
	level thread maxissay( "vox_maxi_avogadro_emp_0", ( 7737, -416, -142 ) );
	update_sidequest_stats( "sq_transit_maxis_stage_3" );
	player = get_players();
	player[ 0 ] setclientfield( "sq_tower_sparks", 1 );
	player[ 0 ] setclientfield( "screecher_maxis_lights", 1 );
	level thread maxis_sidequest_complete_check( "B_complete" );
}
