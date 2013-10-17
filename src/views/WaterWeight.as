package views {
	import controllers.SoundManager;
	import core.Sounds;
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class WaterWeight extends Animation 
	{
		private const FPS:Number = 10;

		private const START_DROP_ONE:Number = 2;
		private const END_DROP_ONE:Number = 22.99;
		private const START_DROP_TWO:Number = 26;
		private const END_DROP_TWO:Number = 46.99;
		private const START_DROP_THREE:Number = 50;
		private const END_DROP_THREE:Number = 69.99;
		private const START_LOOP_ONE:Number = 23;
		private const END_LOOP_ONE:Number = 25.99;
		private const START_LOOP_TWO:Number = 47;
		private const END_LOOP_TWO:Number = 49.99;
		
		
		private var level:int = 0;
		
		public function WaterWeight( mc : MovieClip ) 
		{
			super( mc );
		}
		
		public function loop():void
		{
			level++;
			if( level == 1 )
			{
				this.stop();
				this.currentFrame = START_LOOP_ONE;
				this.loopFrames( [ END_LOOP_ONE ], [ ( END_LOOP_ONE - START_LOOP_ONE ) / FPS ] );
			}
			else if( level == 2 )
			{
				this.stop();
				this.currentFrame = START_LOOP_TWO;
				this.loopFrames( [ END_LOOP_TWO ], [ ( END_LOOP_TWO - START_LOOP_TWO ) / FPS ] );
			}
			else if( level == 3 )
			{
				this.stop();
				this.setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ], onComplete.dispatch );
			}
		}
		
		public function emptyNextBucket( onComplete:Function = null ):void
		{
			if( level == 0 )
			{
				SoundManager.getInstance().playSound( Sounds.WATER_FILL_1 );
				this.stop();
				this.currentFrame = START_DROP_ONE;
				this.setAnimationTimes( [ END_DROP_ONE ], [ ( END_DROP_ONE - START_DROP_ONE ) / FPS ], function():void
				{
					if( onComplete != null )
						onComplete();
					 loop();
				});
			}
			else if( level == 1 )
			{
				SoundManager.getInstance().playSound( Sounds.WATER_FILL_2 );
				this.stop();
				this.currentFrame = START_DROP_TWO;
				this.setAnimationTimes( [ END_DROP_TWO ], [ ( END_DROP_TWO - START_DROP_TWO ) / FPS ], function():void
				{
					 if( onComplete != null )
						onComplete();
					 loop();
				});
			}
			else if( level == 2 )
			{
				SoundManager.getInstance().playSound( Sounds.WATER_FILL_3 );
				this.stop();
				this.currentFrame = START_DROP_THREE;
				this.setAnimationTimes( [ END_DROP_THREE ], [ ( END_DROP_THREE - START_DROP_THREE ) / FPS ], function():void
				{
					if( onComplete != null )
						onComplete();
					 loop();
				});
			}
		}
	}
}
