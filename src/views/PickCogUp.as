package views {
	import views.PickUp;

	/**
	 * @author Adam
	 */
	public class PickCogUp extends PickUp 
	{
		[Embed(source='/../assets/ZOOOP.swf', symbol= 'PickUpCog')]
		private static const PICK_UP:Class;
		
		public function PickCogUp(type : String) 
		{
			super( new PICK_UP(), type);
		}
	}
}
