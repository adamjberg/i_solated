package views {
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	/**
	 * @author Adam
	 */
	 [Embed(source='/../assets/ZOOPCH1.swf', symbol='treelayeruno')]
	public class TreeLayerOne extends Sprite 
	{
		public function TreeLayerOne() 
		{
			this.filters = [ new BlurFilter( 8, 8, 2 ) ];
		}
	}
}
