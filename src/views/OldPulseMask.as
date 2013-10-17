package views {
	import models.PulseModel;

	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author Adam
	 */
	[Embed(source="/../assets/ZOOOP.swf", symbol="PulseMask")]
	public class PulseMask extends Sprite 
	{
		private var model:PulseModel;
		
		public function PulseMask( pulseModel:PulseModel ) 
		{
			this.model = pulseModel;
			this.model.onComplete.add( _remove );
			this.model.onRadiusChanged.add( _redraw );
			this.model.onPlay.add( _add );
		}
		
		private function _remove():void
		{
			this.graphics.clear();
			this.visible = false;
		}
		
		private function _add():void
		{
			this.x = this.model.centerX;
			this.y = this.model.centerY - 150;
			this.scaleX = this.scaleY = 0;
			this.visible = true;
		}
		
		private function _redraw( radius:Number ):void
		{
			//this.scaleX = this.scaleY = radius;
			/*this.graphics.clear();
			this.graphics.beginFill( 0 );
			this.graphics.drawCircle( this.model.centerX, this.model.centerY, radius );*/
			/*var m:Matrix = new Matrix();
			m.scale( radius, radius);
			m.translate( this.model.centerX, this.model.centerY );
			this.transform.matrix = m;*/
		}
	}
}
