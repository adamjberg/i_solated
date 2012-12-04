package models {
	import core.GameState;
	import core.Sounds;

	import views.PlayerAnimations;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Adam
	 */
	public class StageTwoForeground extends ForegroundModel
	{		
		private var firstBranchPoint:BranchPoint = new BranchPoint( 960, 458, [new Point( 981, 458 ), new Point( 1011, 457 ), new Point( 1043, 454 ), new Point( 1071, 451 ), new Point( 1109, 452 ), new Point( 1156, 453 ), new Point( 1214, 452 ), new Point( 1269, 451 ), new Point( 1319, 454 ), new Point( 1347, 455 ), new Point( 1392, 454 ), new Point( 1444, 453 ), new Point( 1505, 454 ), new Point( 1549, 453 ), new Point( 1613, 454 ), new Point( 1630, 453 ), new Point( 1656, 454 ), new Point( 1682, 458 ), new Point( 1713, 461 ) ] );
		
		private const pointsBeforeTree:Array =
		[
 			 new Point( 388, 433 ), new Point( 495, 436 ), new Point( 801, 461 ), new Point( 855, 461 ), new Point( 900, 462 ), new Point( 947, 460 ),
			firstBranchPoint,
			new Point( 970, 447 ), new Point( 1000, 425 ), new Point( 1016, 415 ), new Point( 1041, 392 ), new Point( 1064, 364 ), new Point( 1092, 342 ), new Point( 1122, 313 ), new Point( 1147, 295 ), new Point( 1182, 277 ), new Point( 1225, 257 ), new Point( 1255, 241 ), new Point( 1272, 228 ), new Point( 1314, 209 ), new Point( 1346, 199 ), new Point( 1387, 188 ), new Point( 1416, 183 ), new Point( 1438, 181 ), new Point( 1463, 175 ), new Point( 1472, 175 )
		 ];
		
		private var branchPointTwo:BranchPoint = new BranchPoint( 3905, 779, [ new Point( 3927, 771 ), new Point( 3940, 766 ), new Point( 3957, 758 ), new Point( 3973, 745 ), new Point( 4014, 712 ), new Point( 4041, 673 ), new Point( 4070, 639 ), new Point( 4108, 607 ), new Point( 4128, 588 ), 
			new Point( 4160, 566 ), new Point( 4192, 544 ), new Point( 4228, 522 ), new Point( 4261, 499 ), new Point( 4290, 476 ), new Point( 4317, 454 ), new Point( 4346, 436 ), new Point( 4376, 423 ), new Point( 4410, 412 ), new Point( 4428, 405 ), new Point( 4461, 405 ), new Point( 4486, 397 ),
			new Point( 4519, 396 ), new Point( 4549, 400 ), new Point( 4571, 408 ), new Point( 4585, 415 ), new Point( 4609, 423 ), new Point( 4626, 431 ), new Point( 4667, 462 ), ], Directions.LEFT, Directions.UP );

		private const pointsOnTree:Array =
		[
			new Point( 1679, 416 ), new Point( 1722, 396 ), new Point( 1743, 387 ), new Point( 1784, 372 ), new Point( 1834, 355 ), new Point( 1899, 332 ), new Point( 1951, 314 ), new Point( 2022, 286 ),	new JumpPoint( 2151, 245, PlayerAnimations.JUMP_DOWN_LARGE ), new Point( 2236, 450 )		
		];
		
		private const pointsBeforeWaterfall:Array =
		[
			new Point( 2148, 451 ), new Point( 2285, 454 ), new Point( 2353, 453 ),
			new Point( 2148, 455 ), new Point( 2175, 449 ), new Point( 2208, 448 ), new Point( 2236, 446 ), new Point( 2272, 454 ), new Point( 2317, 454 ), new Point( 2407, 454 ), new Point( 2576, 454 ), new Point( 2598, 442 ), new Point( 2607, 435 ), 
			new Point( 2628, 430 ), new Point( 2649, 441 ), new Point( 2664, 444 ), new Point( 2685, 444 ), new Point( 2710, 449 )
		];
		
		private const pointsAfterWaterfall:Array =
		[
			new Point( 2958, 442 ), new Point( 2994, 436 ), new Point( 3011, 435 ), new Point( 3028, 445 ), new Point( 3060, 449 ), new Point( 3096, 451 ), new Point( 3151, 452 ), new Point( 3195, 449 ), new Point( 3235, 450 ), new Point( 3269, 455 ), new Point( 3295, 466 ), new Point( 3319, 487 ), 
			new Point( 3365, 527 ), new Point( 3406, 564 ), new Point( 3450, 603 ), new Point( 3475, 625 ), new Point( 3506, 661 ), new Point( 3542, 701 ), new Point( 3571, 729 ), new Point( 3593, 751 ), new Point( 3613, 760 ), new Point( 3645, 766 ), new Point( 3678, 775 ), new Point( 3719, 775 ), 
			new Point( 3777, 779 ), new Point( 3845, 778 ),
			branchPointTwo, new Point( 3983, 777 ), new Point( 4055, 784 ), new Point( 4118, 785 ), new Point( 4148, 786 ), new Point( 4186, 778 ), 
		];
		
		private const pointsAfterGate:Array =
		[
			new Point( 4194, 778 ), new Point( 4248, 782 ), new Point( 4298, 781 ), new Point( 4363, 785 ), new Point( 4436, 784 ), new Point( 4558, 783 ), new Point( 4666, 782 ), new Point( 4733, 783 ), new Point( 4794, 787 ), new Point( 4806, 774 ), 
			new Point( 4818, 763 ), new Point( 4837, 756 ), new Point( 4862, 745 ), new Point( 4887, 740 ), new Point( 4920, 737 ), new Point( 4951, 740 ), new Point( 4978, 744 ), new Point( 4994, 749 ), new Point( 5011, 757 ), new Point( 5028, 768 ), 
			new Point( 5046, 785 ), new Point( 5060, 795 ), new Point( 5081, 795 ), new Point( 5100, 793 ), new Point( 5155, 792 ), new Point(  5180, 790 ),
		];
		
		private const waterFallPoints:Array = 
		[
			 new Point( 2745, 458 ), new Point( 2775, 455 ), new Point( 2799, 452 ), new Point( 2836, 453 ), new Point( 2876, 448 ), 
			 new Point( 2903, 448 ), new JumpPoint( 2915, 444, PlayerAnimations.SIDE_JUMP ), new Point( 2996, 435 ), new Point( 3017, 434 ),
		];

		public function StageTwoForeground()
		{			
			super(
				pointsBeforeTree
			);			
			
			this.soundRects = 
			[ 
				new SoundRectangle( 2161, 30, 500, 600, new Rectangle( 1600, 30, 2000, 600 ), Sounds.LOG_BREAK ),
				new SoundRectangle( 2100, 0, 500, 800, new Rectangle( 500, 0, 3700, 800 ), Sounds.WATER_FALL ), 
				new SoundRectangle( 2961, 0, 3000, 800, new Rectangle( 2600, 0, 4000, 800 ), Sounds.RIVER ),
				new SoundRectangle( 3600, 0, 200, 800, new Rectangle( 2900, 0, 1200, 800 ), Sounds.GATE_LIFTING ),
				new SoundRectangle( 4300, 0, 200, 800, new Rectangle( 3900, 0, 1400, 800 ), Sounds.WATER_FALL2 ), 
				new SoundRectangle( 2350, 0, 50, 800, new Rectangle( 2100, 0, 500, 800 ), Sounds.DRIPPING ),
				new SoundRectangle( 3300, 0, 200, 800, new Rectangle( 2600, 0, 1800, 800 ), Sounds.WATER_WHEEL )
			];
			this.soundPoints = [ new SoundPoint( 2230, 0, Sounds.WATER_FALL, 25, 0, SoundPoint.STOP ), new SoundPoint( 2300, 0, Sounds.RIVER, 25, 0, SoundPoint.STOP ) ];
			this.panPoints = [ new PanPoint( 1091, 351, 1400, 100, 175, true, 15, false ), new PanPoint( 1410, 450, 1710, 300, 0, true, 50 ), new PanPoint( 2730, 456, 3000, 0, 0, true ) ];
			GameState.surface = Surfaces.GRASS;
		}
		
		public function enableWaterFallPoints():void
		{
			this.points = [];
			this.actionPoints = pointsBeforeWaterfall.concat( waterFallPoints );
			this._createPath();
		}
		
		public function enablePointsAfterWaterFall():void
		{
			this.points = [];
			this.actionPoints = pointsAfterWaterfall;
			this._createPath();
		}
		
		public function removeTreePoints():void
		{
			GameState.surface = Surfaces.GRASS;
			this.points = [];
			this.actionPoints = pointsBeforeWaterfall;
			this._createPath();
		}
		
		public function removePointsBeforeTree():void
		{
			if( this.branchPoint )
				this.branchPoint.enabled = false;
			this.branchPoint = null;
			this.points = [];
			this.actionPoints = pointsOnTree;
			this._createPath();
			GameState.surface = Surfaces.WOOD;
		}
				
		public function enableWalkPastGate():void
		{
			this.points = [];
			this.actionPoints = pointsAfterWaterfall.concat( pointsAfterGate );
			this._createPath();
		}
	}
}