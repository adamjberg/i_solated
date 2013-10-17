package views {
	import models.PulseModel;

	import utils.display.BitmapRenderer;

	import flash.display.Bitmap;
	import flash.display.Shape;

	/**
	 * @author Adam
	 */
	public class PulseMask extends Bitmap 
	{
		private var model:PulseModel;
				
		public function PulseMask( pulseModel:PulseModel ) 
		{
			var maskGraphic:Shape = new Shape();
			maskGraphic.graphics.beginFill( 0 );
			maskGraphic.graphics.drawCircle( 800, 800, 800 );
			maskGraphic.graphics.drawCircle( 800, 800, 400 );
			
			super( BitmapRenderer.renderSingleBitmap( maskGraphic ).bitmapData );
			
			this.model = pulseModel;
			this.model.onComplete.add( _remove );
			this.model.onRadiusChanged.add( _redraw );
			this.model.onPlay.add( _add );
		}
		
		private function _remove():void
		{
			this.visible = false;
		}
		
		private function _add():void
		{
			this.visible = true;
		}
		
		private function _redraw( radius:Number ):void
		{
			var centerX:Number = this.model.maskCenterX;
			var centerY:Number = this.model.maskCenterY;
			
			this.width = this.height = radius * 2;
			this.x = centerX - this.width * 0.5;
			this.y = centerY - this.height * 0.5;
		}
	}
}
