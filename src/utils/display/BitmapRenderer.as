package utils.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * @author Adam
	 */
	public class BitmapRenderer
	{
		public static function renderSingleBitmap( sprite:DisplayObject ):Bitmap
		{
			var bd:BitmapData = new BitmapData( sprite.width, sprite.height, true, 0x00000000 );
			bd.draw( sprite );
			var bitmap:Bitmap = new Bitmap( bd );
			return bitmap;
		}
		
		public static function renderSingleOffsetBitmap( sprite:DisplayObject ):Bitmap
		{
			var rect:Rectangle = sprite.getBounds( sprite.stage );
			var matrix:Matrix = new Matrix();
			matrix.translate( -rect.x, -rect.y );
			var bd:BitmapData = new BitmapData( sprite.width, sprite.height, true, 0x00000000 );
			bd.draw( sprite, matrix );
			var bitmap:Bitmap = new Bitmap( bd );
			bitmap.x = rect.x;
			bitmap.y = rect.y;
			return bitmap;
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
