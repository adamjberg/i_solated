package controllers {
	import models.PulseModel;

	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	/**
	 * @author Adam
	 */
	public class PulseController 
	{
		public var pulseModel:PulseModel;
		
		private var radTween:TweenLite;
		
		public function PulseController()
		{
			this.pulseModel = new PulseModel();
		}
		
		public function destroy():void
		{
			this.pulseModel.onComplete.removeAll();
			this.pulseModel.onPlay.removeAll();
			this.pulseModel.onRadiusChanged.removeAll();
			this.pulseModel = null;
		}
		
		public function pulse( realPlayerXPos:Number, realPlayerYPos:Number, playerRelXPos:Number, playerRelYPos:Number, maxSize:Number ):void
		{
			if( radTween )
			{
				radTween.kill();
				radTween = null;
			}
						
			pulseModel.maskCenterX = playerRelXPos;
			pulseModel.maskCenterY = playerRelYPos;
			pulseModel.centerX = realPlayerXPos;
			pulseModel.centerY = realPlayerYPos;
			pulseModel.radius = PulseModel.START_RADIUS;
			pulseModel.playing = true;
			var time:Number = ( maxSize + PulseModel.SPACE_BETW ) * PulseModel.SPEED;
			radTween = TweenLite.to( pulseModel, time, { radius : maxSize + PulseModel.SPACE_BETW * 2, ease: Linear.easeNone, onComplete: this.pulseModel.onComplete.dispatch } );
			pulseModel.onPlay.dispatch();
		}
	}
}
