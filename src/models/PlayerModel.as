package models {
	import controllers.SoundManager;

	import core.GameState;
	import core.Sounds;

	import views.PlayerAnimations;

	import org.osflash.signals.Signal;

	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class PlayerModel 
	{
		public const JUMP_SPEED:int = -100;
		public const GRAVITY:Number = 1000;
		public const LEAP_JUMP_SPEED:Number = -250;
		public const JUMP_UP_SPEED:Number = -400;
		public const JUMP_DOWN_SPEED:Number = -150;
		
		public function get BASE_SPEED():Number
		{
			if( item != Items.NO_ITEM )
				return 50;
			else if( running )
				return 150;
			else
				return 95 * speedMultiplier;
		}
		
		public var speedMultiplier:Number = 1;
		
		// Adjusts the accuracy of the movement
		public function get X_BUFFER():int
		{
			if( !running )
				return 3;
			else 
				return 0;
		}
		public const Y_BUFFER:int = 0;
		
		public var onAnimationChanged:Signal = new Signal( String );
		public var onPosChanged:Signal = new Signal();
		public var onRelativeYPosChanged:Signal = new Signal();
		
		private var _facingRight:Boolean = true;
		public function get facingRight():Boolean { return _facingRight; }
		public function set facingRight( b:Boolean ):void
		{
			if( b == _facingRight )
				return;
			_facingRight = b;
			onPosChanged.dispatch();
		}
		public var allowCityGaze:Boolean = false;
		public var _walking:Boolean = false;
		public function get walking():Boolean { return _walking; }
		public function set walking( w:Boolean ):void 
		{ 
			_walking = w;
		}
		
		public var shouldBeRunning:Boolean = false;
		public var _running:Boolean = false;
		public function get running():Boolean { return _running; }
		public function set running( r:Boolean ):void 
		{ 
			_running = r; 		
		}
		
		public var allowWalkingSound:Boolean = true;
		
		public function get allowPulse():Boolean
		{
			return animation == PlayerAnimations.STANDING;
		}
		
		// Return the
		public function get direction():int
		{
			return _facingRight ? Directions.RIGHT : Directions.LEFT;
		}
		
		public var allowGravity:Boolean = false;

		public var item:String = Items.NO_ITEM;
		
		public function get jumping():Boolean
		{
			return ( animation == PlayerAnimations.JUMP_DOWN_LARGE || animation == PlayerAnimations.JUMP_DOWN_SMALL || animation == PlayerAnimations.JUMP_UP || animation == PlayerAnimations.SIDE_JUMP );
		}
		
		public function get allowCameraPan():Boolean
		{
			return !jumping && walking;
		}
		
		public function get allowMovement():Boolean
		{
			return isStanding || isMoving;
		}
		
		public function get allowYPosFix():Boolean
		{
			return ( allowGravity && relativeYPos > currentPoint.y && ySpeed >= 0 );
		}
		
		public var currentPoint:*;
		public var points:Array = [];
		public function get nextPoint():Point { return points[ 0 ]; }
		
		public var relativeXPos:Number = 0;
		
		private var _xPos:Number = 0;
		public function get xPos():Number { return _xPos; };
		public function set xPos( x:Number ):void { if( _xPos == x ) return; _xPos = x; onPosChanged.dispatch(); }
		
		public var xSpeed:Number = 0;
		
		private var _relativeYPos:Number = 0;
		public function set relativeYPos( y:Number ):void
		{
			_relativeYPos = y;
			onRelativeYPosChanged.dispatch();
		}
		public function get relativeYPos():Number { return _relativeYPos; }
		
		private var _yPos:Number = 0;
		public function get yPos():Number { return _yPos; };
		public function set yPos( y:Number ):void { if( _yPos == y ) return; _yPos = y; onPosChanged.dispatch(); }
		
		public var ySpeed:Number = 0;
		
		private var _xOffset:Number = 0;
		public function get xOffset():Number { return _xOffset; };
		public function set xOffset( x:Number ):void { if( _xOffset == x ) return; _xOffset = x; onPosChanged.dispatch(); }
		
		private var _yOffset:Number = 0;
		public function get yOffset():Number { return _yOffset; };
		public function set yOffset( y:Number ):void { if( _yOffset == y ) return; _yOffset = y; onPosChanged.dispatch(); }
		
		public var lastAnimation:String = PlayerAnimations.STANDING;
		
		private var _moving:Boolean = false;
		public function get moving():Boolean { return _moving; }
		public function set moving( m:Boolean ):void
		{
			if( _moving == m )
				return;
			_moving = m;
			var soundManager:SoundManager = SoundManager.getInstance();
			if( shouldBeRunning )
			{
				running = m;
				if( running )
				{
					animation = PlayerAnimations.RUNNING;	
					soundManager.createLoopCrossFade( Sounds.CLIFF_WALKING, 0.5, 0.5, 0.5 );
				}
				else
				{
					soundManager.stopSound( Sounds.CLIFF_WALKING );
				}
			}
			else
			{
				walking = m; 		
				if( walking )
				{
					animation = PlayerAnimations.WALKING;
					if( !allowWalkingSound )
						return;
					if( item != Items.NO_ITEM )
					{
						if( GameState.surface == Surfaces.GRASS )
							soundManager.createLoopCrossFade( Sounds.WALKING_WITH_ITEM, 0.5, 0.5 );
						else if( GameState.surface == Surfaces.FACTORY )
							soundManager.createLoopCrossFade( Sounds.WALKING_WITH_ITEM_FACTORY, 0.5, 0.5 );
					}
					else if( GameState.surface == Surfaces.CLIFF )
						soundManager.createLoopCrossFade( Sounds.CLIFF_WALKING, 0.5, 0.5, 0.5 );
					else if( GameState.surface == Surfaces.GRASS )
						soundManager.createLoopCrossFade( Sounds.GRASS_WALKING, 0.5, 0.5 );
					else if( GameState.surface == Surfaces.FACTORY )
						soundManager.createLoopCrossFade( Sounds.FACTORY_WALKING, 0.1, 0.1 );
					else if( GameState.surface == Surfaces.WOOD )
						soundManager.createLoopCrossFade( Sounds.WOOD_WALKING, 0.1, 0.1 );
					
				}
				else
				{
					Sounds.WALKING_SOUNDS.forEach( function( soundName:String, i:int, a:Array ):void
					{
						SoundManager.getInstance().stopSound( soundName );
					});
					
				}
			}
		}
		
		private var _animation:String = PlayerAnimations.STANDING;
		public function get animation():String { return _animation; }
		public function set animation( a:String ):void 
		{
			if( a == _animation )
				return;
			lastAnimation = _animation; 
			_animation = a;
			if( _animation != PlayerAnimations.RUNNING && _animation != PlayerAnimations.WALKING )
			{
				moving = false;
			}
			onAnimationChanged.dispatch( _animation ); 
		}
		
		public function get allowIntroIntoNextAnimation():Boolean
		{
			return !( lastAnimation == PlayerAnimations.PULSE );
		}
		
		public function get allowOutTransition():Boolean
		{
			return ( wasMoving && isStanding ) || isStanding;
		}
		
		public function get isStanding():Boolean
		{
			return animation == PlayerAnimations.NORMAL_STAND
				|| animation == PlayerAnimations.CARRY_ROCK_STAND || animation == PlayerAnimations.CARRY_COG_STAND
				|| animation == PlayerAnimations.CARRY_VALVE_STAND;
		}
		
		public function destroy():void
		{
			onAnimationChanged.removeAll();
			onPosChanged.removeAll();
			onRelativeYPosChanged.removeAll();
			
			onAnimationChanged = null;
			onPosChanged = null;
			onRelativeYPosChanged = null;
		}
		
		private function get isMoving():Boolean
		{
			return animation == PlayerAnimations.NORMAL_WALK
				|| animation == PlayerAnimations.CARRY_ROCK_WALK || animation == PlayerAnimations.CARRY_COG_WALK
				|| animation == PlayerAnimations.CARRY_VALVE_WALK || animation == PlayerAnimations.RUNNING;
		}

		private function get wasMoving():Boolean
		{
			return lastAnimation == PlayerAnimations.NORMAL_WALK 
				|| lastAnimation == PlayerAnimations.CARRY_ROCK_WALK || lastAnimation == PlayerAnimations.CARRY_COG_WALK
				|| lastAnimation == PlayerAnimations.CARRY_VALVE_WALK || lastAnimation == PlayerAnimations.RUNNING;
		}
	}
}
