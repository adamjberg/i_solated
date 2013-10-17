package models {
	import core.GameState;
	import core.Sounds;

	import views.PlayerAnimations;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Adam
	 */
	public class StageThreeForeground extends ForegroundModel
	{		
		private const ELEVATOR_ACTION_POINTS:Array = [ 
			[ new Point( 200, 550 ), new Point( 333, 550 ), new JumpPoint( 358, 494, PlayerAnimations.JUMP_DOWN_SMALL, Directions.LEFT ), new Point( 373, 494 ), new Point( 393, 496 ), new Point( 419, 494 ), new Point( 443, 496 ), new JumpPoint( 463, 495, PlayerAnimations.JUMP_DOWN_SMALL ), new Point( 500, 550 ), new Point( 520, 550 ) ],
 			[ new Point( 358, 413 ), new Point( 383, 413 ), new Point( 410, 413 ), new Point( 443, 413 ), new JumpPoint( 467, 413, PlayerAnimations.SIDE_JUMP  ), new Point( 606, 552) ],
			[ new Point( 358, 494 ), new Point( 373, 494 ), new Point( 393, 496 ), new Point( 419, 494 ), new Point( 443, 496 )  ]
		];
		
		private const ELEVATOR_POINTS:Array = [ 
			[ new Point( 200, 550 ), new Point( 300, 550 ), new Point( 364, 494 ), new Point( 373, 494 ), new Point( 393, 496 ), new Point( 419, 494 ), new Point( 443, 496 ), new Point( 500, 550 ), new Point( 520, 550 ) ],
			[ new Point( 358, 413 ), new Point( 383, 413 ), new Point( 410, 413 ), new Point( 443, 413 ), new Point( 467, 413 ) , new Point( 606, 552)],
			[ new Point( 373, 494 ), new Point( 393, 496 ), new Point( 419, 494 ), new Point( 443, 496 ) ],
		];
		
		public var elevatorPuzzleModel:ElevatorPuzzleModel = new ElevatorPuzzleModel();
		
		override public function get points():Array
		{
			if( elevatorPuzzleModel.onElevator )
				return ELEVATOR_POINTS[ elevatorPuzzleModel.elevatorHeight ];
			else
				return _points;
		}
		
		override public function get actionPoints():Array
		{
			if( elevatorPuzzleModel.onElevator )
				return ELEVATOR_ACTION_POINTS[ elevatorPuzzleModel.elevatorHeight ];
			else
				return _actionPoints;
		}
		
		public function StageThreeForeground()
		{
			super( 
				//FIRST FLOOR
				pointsBeforeSpark.concat( pointsAfterSpark )
			);
			this.soundRects =
			[
				new SoundRectangle( 0, 200, 100, 800, new Rectangle( -300, -100, 600, 1400 ), Sounds.FACTORY_RIVER ),
				new SoundRectangle( 100, 300, 100, 500, new Rectangle( -150, 150, 500, 800 ), Sounds.SPARK ),
				new SoundRectangle( 0, 0, 250, 800, new Rectangle( -500, -100, 1000, 1000 ), Sounds.ELEVATOR ),
				new SoundRectangle( 0, -500, 900, 500, new Rectangle( -500, -500, 1600, 1000 ), Sounds.BUCKET_MOVEMENT ),	
			];
			this.panPoints = [];
			GameState.surface = Surfaces.FACTORY;
		}
		
		private var pointsBeforeSpark:Array =
		[
			new Point( 73, 549 ), new Point( 106, 551 ), new Point( 164, 550 ), new Point( 233, 549 ), new Point( 319, 549 ), new Point( 397, 550 ), new Point( 485, 550 ), new Point( 542, 550 )		
		];
		
		private var pointsAfterSpark:Array = 
		[
			new Point( 610, 550 ), new Point( 694, 550 ), new Point( 758, 550 ),
			new Point( 805, 549 ), new Point( 878, 550 ), new Point( 995, 551 )
		];
		
		private var revealRoomPoints:Array = 
		[
			//REVEAL ROOM
			new Point( 700, -43 ), new Point( 1600, -43 ), new Point( 1747, -44 )
		];
		
		private var secondFloorPoints:Array = 
		[
			//SECOND FLOOR
			new Point( -6, -43 ), new Point( 60, -42 ), new Point( 135, -43 ), new Point( 191, -43 ), new Point( 240, -44 ), new Point( 300, -43 ), new Point( 328, -44 ), new Point( 367, -44 ), new Point( 407, -45 ), new Point( 449, -44 ), new Point( 479, -43 ),
			new Point( 528, -43 ), new Point( 585, -45 ), new Point( 641, -43 ), new Point( 689, -42 )
		];
		
		public function sparkEnabled( playerPos:Number ):void
		{
			// - 3 to be safe!!!
			this.actionPoints = playerPos < pointsBeforeSpark[ pointsBeforeSpark.length - 3 ].x ? pointsBeforeSpark : pointsAfterSpark;
			this.points = [];
			this._createPath();
		}
		
		public function sparkDisabled():void
		{
			this.points = [];
			this.actionPoints = pointsBeforeSpark.concat( pointsAfterSpark );
			this._createPath();
		}
		
		public function enableRevealRoom():void
		{
			this.panPoints = [ new PanPoint( 700, -45, 750, 0, -150, false ) ];
			this.actionPoints = secondFloorPoints.concat( revealRoomPoints );
			points = [];
			_createPath();
		}
		
		public function enableSecondFloor():void
		{
			this.panPoints = [ new PanPoint( 475, -45, 500, 0, -150 ) ];
			this.actionPoints = secondFloorPoints;
			points = [];
			_createPath();
		}
	}
}