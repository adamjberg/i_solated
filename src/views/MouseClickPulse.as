package views {
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	/**
	 * @author Adam
	 */
	public class MouseClickPulse extends Sprite 
	{
		public function MouseClickPulse()
		{
			this.filters = [ new BlurFilter() ];
		}
		
		public function pulse():void
		{
			radius = 0;
			TweenLite.to( this, 1.2, { radius: 50, onComplete: _onComplete, ease: Linear.easeNone, delay: 1 } );
		}
		
		private var _radius:Number = 0;
		public function set radius( r:Number ):void
		{
			this._radius = r;
			this.graphics.clear();
			this.graphics.lineStyle( 4, 0xFF0000 );
			this.graphics.beginFill( 0, 0 );
			this.graphics.drawCircle( 0, 0, r );
		}
		public function get radius():Number { return _radius; }
		
		private function _onComplete():void
		{
			this.graphics.clear();
		}
	}
}
