package views {
	import controllers.SoundManager;
	import core.Sounds;
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class Spark extends Animation 
	{
		private const FPS:Number = 10;
		
		override public function set visible( v:Boolean ):void
		{
			if( v == visible )
				return;
			super.visible = v;
			if( visible )
			{
				SoundManager.getInstance().createLoopCrossFade( Sounds.SPARK, 0.1, 0.1 );
			}
			else
			{
				SoundManager.getInstance().stopSound( Sounds.SPARK );
			}
		}
			
		public function Spark( mc : MovieClip ) 
		{
			super(mc);
			loop();
		}
	
		public function loop():void
		{
			this.loopFrames( [ numFrames ], [ numFrames / FPS ] );
		}
	
	}
}
