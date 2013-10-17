package views {
	import controllers.SoundManager;
	import core.Sounds;

	/**
	 * @author Adam
	 */
	public class PlaceCog extends Animation 
	{
		[Embed( source="/../assets/ZOOOP.swf", symbol="PlaceCog")]
		private const PLACE_COG:Class;
				
		private const FPS:Number = 10;
		
		public function PlaceCog( type:String )
		{
			super( new PLACE_COG() );
			this.type = type;
		}
		
		public override function play( playTransition:Boolean = false):void
		{
			SoundManager.getInstance().playSound( Sounds.PLACE_COG );
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ numFrames ], [ numFrames / FPS ], this.onComplete.dispatch );
		}
	}
}
