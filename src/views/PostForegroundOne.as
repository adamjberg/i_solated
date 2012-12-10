package views {
	import models.ForegroundModel;
	import models.PulseModel;

	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class PostForegroundOne extends PostForeground 
	{
		public static const BOULDER:String = 'boulder';
		public static const FALLEN_LOG:String = 'fallenlog';
		public static const SHARD:String = 'shard';
		
		private const shardMask:TaggableMask = new TaggableMask( TaggableMask.CENTER_RIGHT );
		
		private var _boulder:Sprite;
		
		public function PostForegroundOne( foreground:Sprite, foregroundModel:ForegroundModel, pulseModel:PulseModel ) 
		{
			shardMask.graphics.beginFill( 0 );
			shardMask.graphics.drawCircle( -200, 0, 300 );
			super( foreground, foregroundModel, [ BOULDER, FALLEN_LOG, SHARD ], pulseModel, [ null, null, shardMask ] );
			this._boulder = foreground.getChildByName( BOULDER ) as Sprite;
		}
	}
}
