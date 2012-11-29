package models {
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class SoundRectangle extends Rectangle 
	{
		public var panRect:Rectangle;
		public var soundName:String;
		
		public function SoundRectangle(x : Number, y : Number, width : Number, height : Number, panRect:Rectangle, soundName:String ) 
		{
			super( x, y, width, height );
			this.panRect = panRect;
			this.soundName = soundName;
		}
	}
}
