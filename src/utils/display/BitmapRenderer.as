package utils.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	/**
	 * @author Adam
	 */
	public class BitmapRenderer
	{
		public static function renderSingleBitmap( sprite:DisplayObject, matrix:Matrix = null ):Bitmap
		{
			var bd:BitmapData = new BitmapData( sprite.width, sprite.height, true, 0x00000000 );
			bd.draw( sprite, matrix );
			return new Bitmap(bd);
		}
		
		public static function renderMultipleBitmaps( sprite:DisplayObject, bitmapWidth:Number ):Array
		{
			var numBitmaps:int = sprite.width / bitmapWidth;
			
			var bitmaps:Array = [];
			var bd:BitmapData = new BitmapData( bitmapWidth, sprite.height, true, 0x00000000 );;
			var matrix:Matrix = new Matrix();
			
			for( var i:int = 0; i < numBitmaps; i++ )
			{
				bd = new BitmapData( bitmapWidth, sprite.height, true, 0x00000000 );
				matrix.tx = -bitmapWidth * i;
				bd.draw( sprite, matrix );
				bitmaps.push( new Bitmap( bd ) );
			}
			return bitmaps;
		}
	}
}
