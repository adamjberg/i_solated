package views {
	import models.PlayerModel;
	import models.PulseModel;

	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author Adam
	 */
	[Embed(source="/../assets/ZOOOP.swf", symbol="PulseRings")]
	public class OldPulse extends Sprite
	{		
		private var model:PulseModel;
		private var playerModel:PlayerModel;
		
		public function OldPulse( pulseModel:PulseModel, playerModel:PlayerModel = null )
		{
			super();
			this.model = pulseModel;
			this.playerModel = playerModel;
			this.model.onComplete.add( _remove );
			this.model.onPlay.add( _add );
			this.model.onRadiusChanged.add( _redraw );
			this.visible = false;
		}
		
		private function _remove():void
		{
			this.visible = false;
		}
		
		private function _add():void
		{
			if( playerModel == null )
			{
				this.x = model.centerX;
				this.y = model.centerY;
			}
			else
			{
				this.x = playerModel.xPos;
				this.y = playerModel.yPos - 150;
			}
			this.visible = true;
		}
		
		private function _redraw( radius:Number ):void
		{
			var m:Matrix = new Matrix();
			m.scale(radius, radius);
			m.translate(x, y);
			this.transform.matrix = m;
		}
	}
}
