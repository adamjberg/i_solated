package views {
	import models.ForegroundModel;

	import utils.display.BitmapRenderer;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class Background extends Sprite 
	{
		private var _layers:Array = [];
		private var _layerStartPositions:Array;
		private var _speeds : Array;
		private var _foregroundModel : ForegroundModel;
		
		public function Background( layers:Array, layerStartPositions:Array, speeds:Array, foregroundModel:ForegroundModel ) 
		{
			this._layerStartPositions = layerStartPositions;
			_foregroundModel = foregroundModel;
			_foregroundModel.onPosChanged.add( _updateLayers );
			_speeds = speeds;
			var bitmapLayer:Bitmap;
			var matrix:Matrix;
			layers.forEach( function( layer:Sprite, i:int, a:Array ):void
			{
				matrix = new Matrix();				
				bitmapLayer = BitmapRenderer.renderSingleBitmap( layer );
				_layers.push( bitmapLayer );
				bitmapLayer.transform.matrix = matrix;
				addChild( bitmapLayer );
			} );
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _updateLayers():void
		{
			if( !stage )
				return;_foregroundModel;
			var rect:Rectangle;
			_layers.forEach( function( layer:Bitmap, i:int, a:Array ):void
			{
				rect = layer.scrollRect;
				rect.x = _foregroundModel.x * _speeds[ i ] - _layerStartPositions[ i ].x;
				rect.y = -_layerStartPositions[ i ].y;
				layer.scrollRect = rect;
			} );
		}
		
		private function _addedToStage( e:Event ):void
		{
			_layers.forEach( function( layer:Bitmap, i:int, a:Array ):void
			{
				layer.scrollRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
			} );
			this._updateLayers();
		}
	}
}
