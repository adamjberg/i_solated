package views {
	import models.ForegroundModel;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class FrontForeground extends Sprite 
	{
		public var onTagAttempted:Signal = new Signal( Number, Number );
		
		private var foreground:Sprite;
		public var foregroundModel : ForegroundModel;
		
		public function FrontForeground( foreground:Sprite, foregroundModel:ForegroundModel ) 
		{
			this.foreground = foreground;
			addChild( foreground );
			this.foregroundModel = foregroundModel;
			this.foregroundModel.onPosChanged.add( _updatePos );
		}

		private function _updatePos():void
		{
			//foreground.x = foregroundModel.x;
			//foreground.y = foregroundModel.y;
		}
	}
}
