package controllers {
	import models.PulseModel;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
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
		
		public function pulse( xPos:Number, yPos:Number, maxSize:Number ):void
		{
			if( radTween )
			{
				radTween.kill();
				radTween = null;
			}
			
			pulseModel.centerX = xPos;
			pulseModel.centerY = yPos;
			pulseModel.radius = PulseModel.START_RADIUS;
			pulseModel.playing = true;
			var time:Number = ( maxSize + PulseModel.SPACE_BETW ) * PulseModel.SPEED;
			radTween = TweenLite.to( pulseModel, time + 2, { radius : maxSize + PulseModel.SPACE_BETW * 2, ease: Quad.easeOut, onComplete: this.pulseModel.onComplete.dispatch } );
			pulseModel.onPlay.dispatch();
		}
	}
}
