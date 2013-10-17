package views {
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Adam
	 */
	public class FadeTransition extends Sprite 
	{
		private var fadeTween:TweenLite;
		
		public function FadeTransition() 
		{
			this.alpha = 0;
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _addedToStage( e:Event ):void
		{
			this.graphics.beginFill( 0 );
			this.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			this.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		public function fadeOut( time:Number, delay:Number, onComplete:Function ):void
		{
			this.alpha = 0;
			fadeTween = TweenLite.to( this, time, { alpha: 1, ease:Linear.easeNone, delay:delay, onComplete:onComplete } );
		}
		
		public function fadeIn( time:Number, delay:Number, onComplete:Function ):void
		{
			this.alpha = 1;
			this.fadeTween = TweenLite.to( this, time, { alpha: 0, ease:Linear.easeIn, delay:delay, onComplete:onComplete } );
		}
	}
}
