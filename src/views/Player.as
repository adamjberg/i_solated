package views {
	import models.PlayerModel;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class Player extends Sprite 
	{
		public var onButtonPressed:Signal = new Signal();
		public var onPulse:Signal = new Signal();
		public var onAnimationComplete:Signal = new Signal( String );
		public var onPulseComplete:Signal = new Signal();
		public var onRockDropped:Signal = new Signal();
		
		public var model:PlayerModel;
	
		private var animation : Animation;
		
		public function Player( model:PlayerModel ) 
		{
			this.model = model;
			this.model.onAnimationChanged.add( updateAnimation );
			this.model.onPosChanged.add( updatePosition );
			updatePosition();
			updateAnimation();
		}
		
		// This should be called when the player has landed
		// Flash timers suck too much to be trusted
		public function endJump():void
		{
			// Just in case
			if( animation is JumpAnimation )
			{
				( animation as JumpAnimation ).startLand();
			}
		}
		
		private function updateAnimation( type:String = '' ):void
		{
			if( animation )
			{
				animation.onOutTrantisionComplete.addOnce( changeAnimation );
				animation.outTransition( model.allowOutTransition );
			}
			else
				changeAnimation();
		}
		
		private function changeAnimation():void
		{
			if( animation )
			{
				animation.onComplete.removeAll();
				if( contains( animation ) )
					removeChild( animation );
				animation = null;
			}
			animation = PlayerAnimations.getAnimation( this.model.animation );
			if( animation is PulseAnimation )
			{
				( animation as PulseAnimation ).onPulse.addOnce( onPulse.dispatch );
				animation.onComplete.addOnce( onPulseComplete.dispatch );
			}
			else if( animation is PutDown )
			{
				( animation as PutDown ).onRockDropped.addOnce( onRockDropped.dispatch );
			}
			else if( animation is ButtonPress )
			{
				( animation as ButtonPress ).onButtonPressed.addOnce( onButtonPressed.dispatch );
			}
			animation.onComplete.addOnce( function():void { onAnimationComplete.dispatch( animation.type ); } );
			if( !model.allowIntroIntoNextAnimation )
				animation.play( false );
			else
				animation.play();
			addChild( animation );
		}
		
		private function updatePosition():void
		{
			x = this.model.xPos;
			y = this.model.yPos;
			this.scaleX = this.model.facingRight ? 1 : -1;
		}
	}
}
