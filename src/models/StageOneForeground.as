package models {
	import core.GameState;

	import views.PlayerAnimations;
	import views.PostForegroundOne;

	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class StageOneForeground extends ForegroundModel
	{
		private const branchPointOne:BranchPoint = 	new BranchPoint( 2132, 640, 
		[ 
			new Point( 2164, 641 ), new Point( 2207, 640 ), new Point( 2234, 638 ), new Point( 2271, 638 ), new Point( 2318, 635 ),
			new Point( 2340, 633 ), new Point( 2386, 634 ), new Point( 2435, 638 ), 
			new Point( 2474, 641 ), new Point( 2505, 646 ), new Point( 2553, 649 ), new Point( 2594, 653 ),
			new Point( 2638, 661 ), new Point( 2651, 663 )
		],
		Directions.LEFT,
		Directions.DOWN,
		true
		);
		
		
		private const pointsBeforeCliff:Array =
		[
			new Point( 100, 428 ), new Point( 118, 430 ), new Point( 248, 432 ), new Point( 349, 434 ), new Point( 453, 433 ), new Point( 537, 430 ), new Point( 592, 432 ), new Point( 637, 437 ), new JumpPoint( 664, 446, PlayerAnimations.SIDE_JUMP ),
			 // After leap 1
			 new JumpPoint( 780, 441, PlayerAnimations.SIDE_JUMP, Directions.LEFT ), new Point( 849, 440 ), new Point( 917, 439 ), new JumpPoint( 940, 439, PlayerAnimations.SIDE_JUMP ),
			 // After leap 2
			 new JumpPoint( 1056, 441, PlayerAnimations.SIDE_JUMP, Directions.LEFT ), new Point( 1124, 437 ), new Point( 1222, 437 ), new Point( 1329, 443 ), new Point( 1417, 448 ), new Point( 1452, 450 ), new Point( 1498, 449 ),
			 new JumpPoint( 1527, 453, PlayerAnimations.JUMP_DOWN_LARGE ),
			 new Point( 1621, 644 )
		];
		
		private const boulderPoints:Array =
		[
			 new JumpPoint( 4100, 429, PlayerAnimations.SIDE_JUMP ), new JumpPoint( 4183, 422, PlayerAnimations.SIDE_JUMP, Directions.LEFT ), new Point( 4208, 414 ), new JumpPoint( 4226, 412, PlayerAnimations.JUMP_DOWN_SMALL ), new JumpPoint( 4255, 441, PlayerAnimations.JUMP_UP, Directions.LEFT, -310 ), new Point( 4292, 434 ), new Point( 4329, 422 ), new Point( 4336, 417 ), new Point( 4351, 419 ), new Point( 4388, 426 ), new JumpPoint( 4405, 431, PlayerAnimations.JUMP_UP, Directions.RIGHT, -310 ), new JumpPoint( 4437, 398, PlayerAnimations.JUMP_DOWN_SMALL, Directions.LEFT ), new JumpPoint( 4447, 401, PlayerAnimations.SIDE_JUMP ),
			new JumpPoint( 4548, 431, PlayerAnimations.SIDE_JUMP, Directions.LEFT ), new Point( 4692, 430 ), new Point( 4891, 438 ), new Point( 5140, 448 ), new Point( 5356, 448 ), new Point( 5570, 452 ), new Point( 5826, 452 ), new Point( 6076, 457 ), new Point( 6225, 459 ),
			 
		];
		
		private const fallenLogPoints:Array =
		[
			 new JumpPoint( 6248, 459, PlayerAnimations.JUMP_UP, Directions.RIGHT, -350 ), new JumpPoint( 6314, 416, PlayerAnimations.JUMP_DOWN_SMALL, Directions.LEFT ), new Point( 6397, 417 ), new Point( 6464, 415 ), new Point( 6513, 409 ), new Point( 6551, 401 ),
			 new JumpPoint( 6584, 394, PlayerAnimations.JUMP_DOWN_SMALL ), new JumpPoint( 6620, 454, PlayerAnimations.JUMP_UP, Directions.LEFT, -380 ), new Point( 6679, 457 ), new Point( 6719, 456 ), new Point( 6784, 462 ), new Point( 6816, 465 ), new Point( 6879, 461 ), new Point( 6985, 465 ), new AnimationPoint( 7110, 463, PlayerAnimations.SLOW_TO_REST )
		];
				
		private const pointsAfterCliff:Array =
		[
			 new Point( 1585, 640 ), new Point( 1594, 639 ),  new Point( 1624, 645 ), new Point( 1721, 645 ), new Point( 1833, 645 ), new Point( 1982, 644 ), new Point( 2075, 643 ),
			 branchPointOne,
			 new Point( 2183, 623 ), new Point( 2246, 600 ), new Point( 2275, 590 ), new Point( 2330, 565 ), new Point( 2389, 535 ), new Point( 2457, 495 ), new Point( 2513, 465 ), new Point( 2573, 435 ), new Point( 2643, 412 ), new Point( 2727, 405 ), new Point( 2804, 396 ), new Point( 2827, 398 ), new Point( 2971, 391 ), new Point( 3084, 389 ), new Point( 3230, 390 ), new Point( 3432, 395 ), new Point( 3662, 406 ),
			 new JumpPoint( 3820, 414, PlayerAnimations.SIDE_JUMP ), new JumpPoint( 3970, 431, PlayerAnimations.SIDE_JUMP, Directions.LEFT ), new Point( 4042, 425 ), new Point( 4070, 428 )
			
		];
		
		public function StageOneForeground()
		{
			super(
				 pointsBeforeCliff
			);
			this.panPoints = [ new PanPoint( 1150, 445, 1500, 0, 120 ), new PanPoint( 1620, 640, 1700, 0, 0 ) ];
			this.tutorialPoints = [ new TutorialPoint( 2630, 663, TutorialPoint.PULSE_TUT ), new TutorialPoint( 4050, 414, TutorialPoint.TAG_TUT ) ];
			this.width = 7930;
			GameState.surface = Surfaces.CLIFF;
		}
		
		public function enableFirstBranchPoint():void
		{
			branchPointOne.forcePath = false;
		}
		
		public function enableFallenLogPoints():void
		{
			this.points = [];
			this.actionPoints = boulderPoints.concat( fallenLogPoints );
			this._createPath();
		}
		
		public function enableBoulderPoints():void
		{
			this.points = [];
			this.actionPoints = pointsAfterCliff.concat( boulderPoints );
			this._createPath();
		}
		
		public function enablePointsAfterCliff():void
		{
			this.points = [];
			this.actionPoints = pointsAfterCliff;
			this._createPath();
		}
	}
}
