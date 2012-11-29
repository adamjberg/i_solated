package views {
	import models.PulseModel;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author Adam
	 */
	public class PulseMask extends Sprite 
	{
		private var model:PulseModel;
		
		public function PulseMask( pulseModel:PulseModel ) 
		{
			this.model = pulseModel;
			this.model.onComplete.add( _remove );
			this.model.onRadiusChanged.add( _redraw );
			this.model.onPlay.add( _add );
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function _remove():void
		{
			this.graphics.clear();
			this.visible = false;
		}
		
		private function _add():void
		{
			this.visible = true;
		}
		
		private function _redraw( radius:Number ):void
		{
			var centerX:Number = this.model.centerX;
			var centerY:Number = this.model.centerY// - 150;
			
			this.graphics.clear();
			this.graphics.beginFill( 0 );
			if( radius - PulseModel.SPACE_BETW > 0 )
				this.graphics.drawCircle( centerX, centerY, radius - PulseModel.SPACE_BETW );
			this.graphics.drawCircle( centerX, centerY, radius );
			
		
			/*var mtx:Matrix = new Matrix();
			mtx.createGradientBox( radius*2, radius*2, 0, -radius, -radius );
			this.graphics.beginGradientFill(GradientType.RADIAL, [ 0, 0, 0 ], [ 0, 1, 0 ], [0, 255, 255], mtx);
			this.graphics.drawCircle( 0, 0, radius );*/
		}
	}
}
