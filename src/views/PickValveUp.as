package views {
	import views.PickUp;

	/**
	 * @author Adam
	 */
	public class PickValveUp extends PickUp 
	{
		[Embed(source='/../assets/ZOOOP.swf', symbol= 'PickUpValve')]
		private static const PICK_UP:Class;
		
		public function PickValveUp(type : String) 
		{
			super( new PICK_UP(), type);
		}
	}
}
