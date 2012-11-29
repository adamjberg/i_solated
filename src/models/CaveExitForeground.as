package models {
	import core.GameState;

	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class CaveExitForeground extends ForegroundModel 
	{
		public function CaveExitForeground()
		{
			super( [ 
					new Point( 193, 498 ), new Point( 275, 483 ), new Point( 319, 471 ),
 					new Point( 369, 467 ), new Point( 400, 466 ), new Point( 434, 459 ), new Point( 466, 458 ), new Point( 506, 454 ), new Point( 549, 453 ), new Point( 586, 453 ), new Point( 664, 460 ), new Point( 700, 460 ), new Point( 720, 463 ), new Point( 772, 462 ), new Point( 798, 462 ),
					new Point( 853, 460 ),  new Point( 900, 462 ),
					new Point( 941, 458 ), new Point( 1000, 458 ), new Point( 1104, 457 ), new Point( 1189, 459 ), new Point( 1268, 457 ), new Point( 1304, 458 ),
					new Point( 1377, 457 ), new Point( 1478, 458 ), new Point( 1584, 458 ), new Point( 1665, 457 ), new Point( 1679, 460 ), new Point( 1706, 459 ),
					new Point( 1749, 461 ), new Point( 1794, 459 ), new Point( 1820, 461 )
				] );
			GameState.surface = Surfaces.CLIFF;
		}
	}
}
