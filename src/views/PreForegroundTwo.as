package views {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class PreForegroundTwo extends Sprite 
	{
		public static const ROCK:String = 'rock';
		public static const SPRING_BOARD:String = 'springBoard';
		public static const PRE_TREE:String = 'preTree';
		public static const BRIDGE:String = 'PreBridge';
		public static const PRE_CONTROL_BOX:String = 'preControlBox';
		public static const WATER_FALL_TWO:String = 'waterFallTwo';
		
		private var springBoard:Sprite;
		private var tree:Sprite;
		private var foreground:Sprite;
		private var controlBox:MovieClip;
		private var preControlBox:PreControlBox;
		private var waterFallTwo : MovieClip;
		private var waterFallTwoAnimation:WaterFallTwo;
		
		public function PreForegroundTwo( foreground:Sprite ) 
		{
			this.foreground = foreground;
			this.addChild( foreground );
			this.foreground.mouseChildren = false;
			this.foreground.mouseEnabled = false;
						
			tree = this.foreground.getChildByName( PRE_TREE ) as Sprite;
			springBoard = foreground.getChildByName( SPRING_BOARD ) as Sprite;
			controlBox = foreground.removeChild( foreground.getChildByName( PRE_CONTROL_BOX ) ) as MovieClip;
			preControlBox = new PreControlBox( controlBox );
			
			waterFallTwo = foreground.removeChild( foreground.getChildByName( WATER_FALL_TWO ) ) as MovieClip;
			waterFallTwoAnimation = new WaterFallTwo( waterFallTwo );
			
			foreground.addChild( preControlBox );
			foreground.addChild( waterFallTwoAnimation );
		}
		
		public function destroy():void
		{
			preControlBox.destroy();
			waterFallTwoAnimation.destroy();
			
			preControlBox = null;
			controlBox = null;
			waterFallTwo = null;
			waterFallTwoAnimation = null;
			tree = null;
			foreground = null;
			springBoard = null;
		}
			
		public function removeTree():void
		{
			foreground.removeChild( tree );
		}
	}
}
