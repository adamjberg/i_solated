package views {
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	/**
	 * @author Adam
	 */
	[Embed(source='/../assets/ZOOPCH1.swf', symbol='treelayertres')]
	public class TreeLayerThree extends Sprite {
		public function TreeLayerThree() 
		{
			this.filters = [ new BlurFilter( 8, 8, 2 ) ];
		}
	}
}
