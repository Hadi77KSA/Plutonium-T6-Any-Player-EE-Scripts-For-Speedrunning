init()
{
	switch ( getdvar( "mapname" ) )
	{
		case "zm_transit":
		case "zm_highrise":
		case "zm_buried":
			thread setNavStatsForAllMaps();
			break;
	}
}

setNavStatsForAllMaps()
{
	common_scripts\utility::flag_wait( "initial_players_connected" );
	a_stat = array( "sq_transit_started", "sq_highrise_started", "sq_buried_started", "navcard_applied_zm_transit", "navcard_applied_zm_highrise", "navcard_applied_zm_buried" );

	foreach ( player in getPlayers() )
	{
		// Handles building the NAV Tables and applying the Navcards
		foreach ( n_stat in a_stat )
		{
			if ( !player maps\mp\zombies\_zm_stats::get_global_stat( n_stat ) )
				player maps\mp\zombies\_zm_stats::increment_client_stat( n_stat, 0 );
		}
	}
}
