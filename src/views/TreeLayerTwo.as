package views {
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	/**
	 * @author Adam
	 */
	[Embed(source='/../assets/ZOOPCH1.swf', symbol='treelayerdos')]
	public class TreeLayerTwo extends Sprite {
		public function TreeLayerTwo() 
		{
			this.filters = [ new BlurFilter( 8, 8, 2 ) ];
		}
	}
}
