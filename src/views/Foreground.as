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
		public var foregroundModel : ForegroundModel;
		private var _useScrollRect:Boolean;
		
		public function Foreground( foregroundModel:ForegroundModel, useScrollRect:Boolean = true ) 
		{
			if( !foregroundModel )
			{
				trace( 'Foreground Model does not exist' );
				return;
			}
			this.foregroundModel = foregroundModel;
			this.foregroundModel.onPosChanged.add( _updatePos );
			this._useScrollRect = useScrollRect;
			if( useScrollRect )
				this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _addedToStage( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this.scrollRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );	
		}
				
		private function _updatePos():void
		{
			
			if( this._useScrollRect )
			{
				var rect:Rectangle = this.scrollRect;
				rect.x = -foregroundModel.x;
				rect.y = -foregroundModel.y;
				this.scrollRect = rect;
			}
			else
			{
				this.x = foregroundModel.x;
				this.y = foregroundModel.y;
			}
		}
	}
}
