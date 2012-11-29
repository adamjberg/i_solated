package views {
	import models.ForegroundModel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class Background extends Sprite 
	{
		private var _layers:Array;
		private var _speeds : Array;
		private var _foregroundModel : ForegroundModel;
		
		public function Background( layers:Array, speeds:Array, foregroundModel:ForegroundModel ) 
		{
			_foregroundModel = foregroundModel;
			_foregroundModel.onPosChanged.add( _updateLayers );
			_layers = layers;
			_speeds = speeds;
			_layers.forEach( function( layer:Sprite, i:int, a:Array ):void
			{
				addChild( layer );
			} );
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _updateLayers():void
		{
			if( !stage )
				return;_foregroundModel;
			var rect:Rectangle;
			_layers.forEach( function( layer:Sprite, i:int, a:Array ):void
			{
				rect = layer.scrollRect;
				rect.x = _foregroundModel.x * _speeds[ i ];
				layer.scrollRect = rect;
			} );
		}
		
		private function _addedToStage( e:Event ):void
		{
			_layers.forEach( function( layer:Sprite, i:int, a:Array ):void
			{
				layer.scrollRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
			} );
		}
	}
}
