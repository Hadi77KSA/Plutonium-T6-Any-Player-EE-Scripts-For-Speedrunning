//This "fix" is not necessary as it turns out there is a 13th body location
//which the community was not aware of at the time of creating this patch,
//as can be seen here: https://youtu.be/3m8_Uce33jQ
//This led to mistaking the body at the 13th location for a body that has not spawned in,
//and the need for this fix. Since that turned out to not be the case, this fix is no longer
//necessary. However, I will keep it as there are approved runs on ZWR which have used it.

init()
{
	thread sq_tpo_body_fix();
}

sq_tpo_body_fix()
{
	level endon( "sq_tpo_generator_powered" );

	for (;;)
	{
		level waittill( "sq_tpo_special_round_started" );

		while ( common_scripts\utility::flag( "sq_tpo_special_round_active" ) && level.sq_tpo.times_searched < 2 )
			wait 0.05;

		if ( common_scripts\utility::flag( "sq_tpo_special_round_active" ) )
			level.sq_tpo.times_searched++;
	}
}
