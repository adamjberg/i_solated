package views {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Adam
	 */
	public class Title extends Sprite 
	{
		private const WIDTH:int = 800;
		private const HEIGHT:int = 415;
	
		[Embed(source="/../assets/title.swf")]
		private const TITLE:Class;
		
		public function Title()
		{
			addChild( new TITLE() );
			addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}

		private function addedToStage(event : Event) : void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			y = ( stage.stageHeight - HEIGHT ) * 0.5;
		}
		
	}
}
