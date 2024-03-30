init()
{
	mapName = getdvar( "mapname" );
	if ( mapName == "zm_transit" || mapName == "zm_highrise" || mapName == "zm_buried" )
	{
		a_stat_nav = array( "navcard_applied_zm_transit", "navcard_applied_zm_highrise", "navcard_applied_zm_buried" );
		common_scripts\utility::flag_wait( "initial_players_connected" );
		players = getPlayers();

		foreach ( player in players )
		{
			// Handles buidling the NAV Table
			if ( !player maps\mp\zombies\_zm_stats::get_global_stat( "sq_" + getSubStr( mapName, 3 ) + "_started" ) )
				[[ getFunction( "maps/mp/" + mapName + "_sq", "update_sidequest_stats" ) ]]( "sq_" + getSubStr( mapName, 3 ) + "_started" );

			// Handles applying the Navcards
			foreach ( n_stat_nav in a_stat_nav )
			{
				if ( !player maps\mp\zombies\_zm_stats::get_global_stat( n_stat_nav ) )
					player maps\mp\zombies\_zm_stats::increment_client_stat( n_stat_nav, 0 );
			}
		}
	}
}
