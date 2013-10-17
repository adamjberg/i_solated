package views {
	/**
	 * @author Adam
	 */
	
	public class PreBucket extends Animation
	{
		[Embed(source="/../assets/zoopch2p2.swf", symbol="Bucket")]
		private const PRE_BUCKET:Class;
		
		public function PreBucket():void
		{
			super( new PRE_BUCKET() );
		}
		
		public function on():void
		{
			this.currentFrame = 2;
		}
		
		public function off():void
		{
			this.currentFrame = 1;
		}
	}
}
