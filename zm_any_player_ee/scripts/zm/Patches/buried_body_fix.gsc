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
		level.sq_tpo.times_searched = 1;
	}
}
