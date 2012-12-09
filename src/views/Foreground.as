package views {
	import models.ForegroundModel;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class Foreground extends Sprite 
	{
		public var onTagAttempted:Signal = new Signal( Number, Number );
		
		private var preForeground:Sprite;
		private var postForeground:Sprite;
		public var foregroundModel : ForegroundModel;
		
		public function Foreground( pre:Sprite, post:Sprite, foregroundModel:ForegroundModel ) 
		{
			preForeground = pre;
			postForeground = post;
			addChild( preForeground );
			addChild( postForeground );
			this.foregroundModel = foregroundModel;
			this.foregroundModel.onPosChanged.add( _updatePos );
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _addedToStage( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this.scrollRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );	
		}
				
		private function _updatePos():void
		{
			if( !stage )
				return;
			var rect:Rectangle = this.scrollRect;
			rect.x = -foregroundModel.x;
			rect.y = -foregroundModel.y;
			this.scrollRect = rect;
		}
	}
}
