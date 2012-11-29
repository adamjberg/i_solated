package views {
	import views.PickUp;

	/**
	 * @author Adam
	 */
	public class PickRockUp extends PickUp 
	{
		[Embed(source='/../assets/ZOOOP.swf', symbol= 'PickUp')]
		private static const PICK_UP:Class;
		
		public function PickRockUp(type : String) 
		{
			super( new PICK_UP(), type);
		}
	}
}
