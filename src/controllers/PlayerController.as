package controllers {
	import core.Gravity;

	import models.ActionPoint;
	import models.AnimationPoint;
	import models.BranchPoint;
	import models.Directions;
	import models.Items;
	import models.JumpAnimationModel;
	import models.JumpPoint;
	import models.PlayerModel;
	import models.StopPoint;

	import views.PlayerAnimations;

	import org.osflash.signals.Signal;

	import flash.geom.Point;
	import flash.utils.setTimeout;
	/**
	 * @author Adam
	 */
	public class PlayerController 
	{
		public var onAnimationPointReached:Signal = new Signal();
		public var onStartJumpDownLarge:Signal = new Signal();
		public var onStartJumpDownSmall:Signal = new Signal();
		public var onStartLeap:Signal = new Signal();
		public var onStartJumpUp:Signal = new Signal();
		public var onSlowToRest:Signal = new Signal();
		public var onBranchPointReached:Signal = new Signal( int );
		public var onPlayerLanded:Signal = new Signal();
		public var onPickUpRock:Signal = new Signal();
		public var onPickUpCog:Signal = new Signal();
		public var onPickUpValve:Signal = new Signal();
		public var onStopMoving:Signal = new Signal();
		
		public var playerModel : PlayerModel;
		
		private var _savedCompleteFunction:Function;
		
		public function PlayerController( startPoint:* )
		{
			playerModel = new PlayerModel();
			PlayerAnimations.playerModel = playerModel;
			playerModel.relativeXPos = startPoint.x;
			playerModel.xPos = startPoint.x;
			playerModel.yPos = startPoint.y;
			playerModel.relativeYPos = startPoint.y;
			playerModel.currentPoint = startPoint;
		}
		
		public function destroy():void
		{
			playerModel.destroy();
			
			onStartJumpDownLarge.removeAll();
			onStartJumpDownSmall.removeAll();
			onStartLeap.removeAll();
			onStartJumpUp.removeAll();
			onSlowToRest.removeAll();
			onBranchPointReached.removeAll();
			onPlayerLanded.removeAll();
			onPickUpRock.removeAll();
			onPickUpCog.removeAll();
			onPickUpValve.removeAll();
			onStopMoving.removeAll();

			_savedCompleteFunction = null;
			playerModel = null;			
			onStartJumpDownLarge = null;
			onStartJumpDownSmall = null;
			onStartLeap = null;
			onStartJumpUp = null;
			onSlowToRest = null;
			onBranchPointReached = null;
			onPlayerLanded = null;
			onPickUpRock = null;
			onPickUpCog = null;
			onPickUpValve = null;
			onStopMoving = null;
		}
		
		public function updateXPos( dt:Number, speed:Number ):void
		{
			playerModel.xPos += speed * dt;
		}
		
		public function updateYPos( dt:Number, speed:Number ):void
		{
			if( playerModel.allowGravity && playerModel.ySpeed > 0 )
			{
				if( playerModel.relativeYPos + speed * dt > playerModel.currentPoint.y )
				{
					jumpComplete();
					return;
				}
			}
			playerModel.yPos += speed * dt;
		}
		
		public function update( dt:Number ):void
		{
			if( !playerModel.currentPoint )
				return;
			// If the player is jumping have the gravity affect the player
			if( playerModel.allowGravity )
			{
				playerModel.ySpeed += playerModel.GRAVITY * dt;
				return;
			}
			else if( playerModel.jumping )
				return;
			
			if( ( playerModel.relativeXPos < playerModel.currentPoint.x - playerModel.X_BUFFER && playerModel.xSpeed >= 0 ) || ( playerModel.relativeXPos > playerModel.currentPoint.x + playerModel.X_BUFFER && playerModel.xSpeed <= 0 ) )
			{
				playerModel.moving = true;
				walkTo( playerModel.currentPoint );
			}
			// We have reached the current point
			else
			{
				var nextPoint:* = playerModel.points[ 0 ];
				if( playerModel.currentPoint is BranchPoint )
				{
					onBranchPointReached.dispatch( playerModel.direction );
				}
				
				if( playerModel.currentPoint is ActionPoint && !playerModel.currentPoint.enabled )
				{
					this.stop();
				}
				// Force a stop if the current point is a stop point.  ie: they shouldn't be able to go in the direction specified by the point.
				else if( playerModel.currentPoint is StopPoint )
				{
					if( playerModel.direction == playerModel.currentPoint.direction )
					{
						stop();
					}
					else if( playerModel.points.length > 0 )
						playerModel.currentPoint = playerModel.points.shift();
				}
				else if( playerModel.currentPoint is AnimationPoint )
				{
					playerModel.facingRight = playerModel.currentPoint.direction == Directions.RIGHT ? true : false;
					this.onAnimationPointReached.dispatch();
					if( playerModel.currentPoint.playerAnimationRequired == PlayerAnimations.SLOW_TO_REST )
						this._slowToRest();
					else if( playerModel.currentPoint.playerAnimationRequired == PlayerAnimations.PICK_UP )
						this.pickUp( playerModel.currentPoint.params.item );
					else if( playerModel.currentPoint.playerAnimationRequired == PlayerAnimations.PUT_DOWN )
						this.putDown();
					else if( playerModel.currentPoint.playerAnimationRequired == PlayerAnimations.PLACE_COG )
						this.placeCog();
					else if( playerModel.currentPoint.playerAnimationRequired == PlayerAnimations.BUTTON_PRESS )
						this.pressButton();
				}
				else if( playerModel.points.length > 0 )
				{
					if( playerModel.currentPoint is JumpPoint && playerModel.currentPoint.direction == playerModel.direction )
					{
						var animationRequired:String = playerModel.currentPoint.playerAnimationRequired;
						
						if( animationRequired == PlayerAnimations.JUMP_DOWN_SMALL )
						{
							smallDropTo( nextPoint );
						}
						else if( animationRequired == PlayerAnimations.JUMP_DOWN_LARGE )
						{
							largeDropTo( nextPoint );
						}
						else if( animationRequired == PlayerAnimations.JUMP_UP )
						{
							jumpUpTo( nextPoint, ( playerModel.currentPoint as JumpPoint ).jumpSpeed );
						}
						else if( animationRequired == PlayerAnimations.SIDE_JUMP )
						{
							leapTo( nextPoint );
						}
						playerModel.animation = animationRequired;
					}
					else
					{
						//playerModel.animation = PlayerAnimations.WALKING;
						//walkTo( nextPoint );
					}
					playerModel.currentPoint = playerModel.points.shift();
				}
				// We have reached the very last point.... hopefully
				else
				{
					stop();
					if( _savedCompleteFunction != null )
					{
						_savedCompleteFunction();
						_savedCompleteFunction = null;
					}
				}
			}
		}
		
		/**
		 * This is called after an animation ends so that the animation can be changed
		 */
		public function changeAnimation( name:String ):void
		{
			if( playerModel.animation == PlayerAnimations.JUMP_UP || playerModel.animation == PlayerAnimations.SIDE_JUMP || playerModel.animation == PlayerAnimations.JUMP_DOWN_SMALL )
			{
				if( playerModel.points.length > 0 )
					playerModel.moving = true;
				else
					playerModel.animation = PlayerAnimations.STANDING;
			}
			else if( playerModel.animation == PlayerAnimations.PULSE )
				playerModel.animation = PlayerAnimations.STANDING;
			else if( playerModel.animation == PlayerAnimations.PICK_UP )
				playerModel.animation = PlayerAnimations.STANDING;
			else if( playerModel.animation == PlayerAnimations.PUT_DOWN )
				playerModel.animation = PlayerAnimations.STANDING;
			else if( playerModel.animation == PlayerAnimations.PLACE_COG )
				playerModel.animation = PlayerAnimations.STANDING;
			else if( playerModel.animation == PlayerAnimations.BUTTON_PRESS )
				playerModel.animation = PlayerAnimations.STANDING;
			else if( playerModel.animation == PlayerAnimations.JUMP_DOWN_LARGE )
				playerModel.animation = PlayerAnimations.STANDING;
		}
		
		public function moveThroughPoints( points:Array, onComplete:Function = null ):void
		{
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			
			if( points.length == 0 )
			{
				this.stop();
				return;
			}
			
			playerModel.currentPoint = points.shift();
			
			// If the current point is right next to the player 
			if( playerModel.currentPoint.x <= playerModel.relativeXPos + playerModel.X_BUFFER && playerModel.currentPoint.x >= playerModel.relativeXPos - playerModel.X_BUFFER )
			{
				playerModel.currentPoint.x = playerModel.relativeXPos;
			}
			this.playerModel.points = points;
			_updatePlayerDirection();	
			
			if( _savedCompleteFunction != null )
			{
				_savedCompleteFunction = null;
			}
			
			if( onComplete != null )
			{
				_savedCompleteFunction = onComplete;
			}
		}
		
		public function moveToPoint( point:Point ):void
		{
			playerModel.currentPoint = point;
			this._updatePlayerDirection();
		}
		
		public function pulse():void
		{
			this.playerModel.currentPoint = new Point( playerModel.relativeXPos, playerModel.relativeYPos );
			this.playerModel.points = [];
			playerModel.animation = PlayerAnimations.PULSE;
		}
		
		public function stop():void
		{
			if( playerModel.moving )
			{
				this.playerModel.currentPoint = null;
				this.playerModel.points = [];
				this.onStopMoving.dispatch();
				playerModel.xSpeed = 0;
				playerModel.ySpeed = 0;
				playerModel.animation = PlayerAnimations.STANDING;
			}
		}
		
		private function _updatePlayerDirection():void
		{
			// The points are exactly the same
			// If these two points are the same just make the player face right,
			// this should never happen..... hopefully
			if( this.playerModel.points[ this.playerModel.points.length - 1 ] )
			{
				if( playerModel.relativeXPos > this.playerModel.points[ this.playerModel.points.length - 1 ].x )
				{
					playerModel.facingRight = false;
				}
				else
				{
					playerModel.facingRight = true;
				}
			}
			else if( playerModel.currentPoint.x > playerModel.relativeXPos )
			{
				playerModel.facingRight = true;
			}
			else if( playerModel.currentPoint.x < playerModel.relativeXPos )
			{
				playerModel.facingRight = false;
			}
			else
			{
			}
		}
		
		public function stopMovement():void
		{
			this.playerModel.xSpeed = 0;
			this.playerModel.ySpeed = 0;
			this.playerModel.points = [];
			this.playerModel.currentPoint = null;
		}
		
		public function pressButton():void
		{
			this.playerModel.animation = PlayerAnimations.BUTTON_PRESS;
			this.stopMovement();
		}
		
		public function placeCog():void
		{
			this.playerModel.animation = PlayerAnimations.PLACE_COG;
			playerModel.item = Items.NO_ITEM;
			this.stopMovement();	
		}
		
		public function pickUp( item:String = Items.ROCK ):void
		{
			if( item == Items.ROCK )
				this.onPickUpRock.dispatch();
			else if( item == Items.COG )
				this.onPickUpCog.dispatch();
			else if( item == Items.VALVE )
				this.onPickUpValve.dispatch();
			playerModel.item = item;
			playerModel.animation = PlayerAnimations.PICK_UP;
			this.stopMovement();
		}
		
		public function putDown():void
		{
			playerModel.animation = PlayerAnimations.PUT_DOWN;
			playerModel.item = Items.NO_ITEM;
			this.stopMovement();
		}
		
		private function _slowToRest():void
		{
			this.onSlowToRest.dispatch();
			playerModel.animation = PlayerAnimations.SLOW_TO_REST;
			this.stopMovement();
		}
		
		private function leapTo( point:Point ):void
		{
			onStartLeap.dispatch();
			const jumpSpeed:Number = playerModel.LEAP_JUMP_SPEED;
			const totalAirTime:Number = Gravity.getTotalAirTime( playerModel.GRAVITY, jumpSpeed, ( playerModel.relativeYPos - point.y ) );
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			var animationModel:JumpAnimationModel = PlayerAnimations.getModel( PlayerAnimations.SIDE_JUMP );
			animationModel.timeTilStart = 0.15;
			animationModel.timeTilPeak = Gravity.getTimeTilPeak( playerModel.GRAVITY, jumpSpeed );
			animationModel.timeTilLand = totalAirTime - animationModel.timeTilPeak;
			setTimeout( function():void
				{
					playerModel.allowGravity = true;
					playerModel.ySpeed = jumpSpeed;
					// Distance to next point divided by the time it should take
					playerModel.xSpeed = ( point.x - playerModel.relativeXPos ) / totalAirTime;
				},
				animationModel.timeTilStart * 1000
			);
		}
		
		private function smallDropTo( point:Point ):void
		{
			onStartJumpDownSmall.dispatch();
			const jumpSpeed:Number = playerModel.JUMP_DOWN_SPEED;
			const totalAirTime:Number = Gravity.getTotalAirTime( playerModel.GRAVITY, jumpSpeed, ( playerModel.relativeYPos - point.y ) );
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			var animationModel:JumpAnimationModel = PlayerAnimations.getModel( PlayerAnimations.JUMP_DOWN_SMALL );
			animationModel.timeTilStart = 0.1;
			animationModel.timeTilPeak = Gravity.getTimeTilPeak( playerModel.GRAVITY, jumpSpeed );
			animationModel.timeTilLand = totalAirTime - animationModel.timeTilPeak;
			setTimeout( function():void
				{
					playerModel.allowGravity = true;
					playerModel.ySpeed = jumpSpeed;
					playerModel.xSpeed = ( point.x - playerModel.relativeXPos ) / totalAirTime;
				},
				animationModel.timeTilStart * 1000
			);
		}
		
		private function largeDropTo( point:Point ):void
		{
			onStartJumpDownLarge.dispatch();
			const jumpSpeed:Number = playerModel.JUMP_DOWN_SPEED;
			const totalAirTime:Number = Gravity.getTotalAirTime( playerModel.GRAVITY, jumpSpeed, ( playerModel.relativeYPos - point.y ) );
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			var animationModel:JumpAnimationModel = PlayerAnimations.getModel( PlayerAnimations.JUMP_DOWN_LARGE );
			animationModel.timeTilStart = 0.1;
			animationModel.timeTilPeak = Gravity.getTimeTilPeak( playerModel.GRAVITY, jumpSpeed );
			animationModel.timeTilLand = totalAirTime - animationModel.timeTilPeak;
			setTimeout( function():void
				{
					playerModel.allowGravity = true;
					playerModel.ySpeed = jumpSpeed;
					playerModel.xSpeed = ( point.x - playerModel.relativeXPos ) / totalAirTime;
				},
				animationModel.timeTilStart * 1000
			);
		}
		
		private function jumpUpTo( point:Point, jumpSpeed:Number ):void
		{
			onStartJumpUp.dispatch();
			const totalAirTime:Number = Gravity.getTotalAirTime( playerModel.GRAVITY, jumpSpeed, ( playerModel.relativeYPos - point.y ) );
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			var animationModel:JumpAnimationModel = PlayerAnimations.getModel( PlayerAnimations.JUMP_UP );
			animationModel.timeTilStart = 0.1;
			animationModel.timeTilPeak = Gravity.getTimeTilPeak( playerModel.GRAVITY, jumpSpeed );
			animationModel.timeTilLand = Math.abs( totalAirTime - animationModel.timeTilPeak );
			setTimeout( 
				function():void
				{
					playerModel.allowGravity = true;
					playerModel.ySpeed = jumpSpeed;
					playerModel.xSpeed = ( point.x - playerModel.relativeXPos ) / totalAirTime;
				},
				animationModel.timeTilStart * 1000
			);
		}
		
		private function jumpComplete():void
		{
			playerModel.allowGravity = false;
			
			// Dispatch after everything has been disabled
			onPlayerLanded.dispatch();
			
			playerModel.xSpeed = 0;
			playerModel.ySpeed = 0;
			
			
		}
		
		private function walkTo( nextPoint:Point ):void
		{
			// just in case
			if( !nextPoint )
				return;
			if( nextPoint.x == playerModel.relativeXPos && nextPoint.y == playerModel.relativeYPos )
				return;
			var slope:Number = (  nextPoint.y - playerModel.relativeYPos ) / ( nextPoint.x - playerModel.relativeXPos );
			var atan:Number = Math.atan( slope );
			var left:Boolean = nextPoint.x < playerModel.relativeXPos;
			var down:Boolean = nextPoint.y > playerModel.relativeYPos;
			playerModel.xSpeed = playerModel.BASE_SPEED * Math.cos( atan ) * ( left ? -1 : 1 );
			playerModel.ySpeed = playerModel.BASE_SPEED * Math.abs( Math.sin( atan ) ) * ( down ? 1 : -1 );
		}
	}
}
