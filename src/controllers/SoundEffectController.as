package controllers {
	import core.SoundItem;
	import core.Sounds;
	import models.SoundPoint;
	import models.SoundRectangle;
	import flash.geom.Rectangle;
	/**
	 * @author Adam
	 */
	public class SoundEffectController 
	{
		private var soundPoints:Array;
		private var soundRects:Array;
		private var soundManager:SoundManager;
		
		public function SoundEffectController( soundPoints:Array, soundRects:Array )
		{
			this.soundRects = soundRects;
			this.soundPoints = soundPoints;
			this.soundManager = SoundManager.getInstance();
		}
		
		public function destroy():void
		{
			soundPoints = null;
			soundRects = null;
			soundManager = null;
		}
		
		public function checkForSound( foregroundX:Number, playerYPos:Number ):void
		{
			var xDistMultiplier:Number;
			var yDistMultiplier:Number;
			var si:SoundItem;
			var pan:Number;
			var xDistanceFromCenter:Number;
			var yDistanceFromCenter:Number;
			var absDistance:Number;
			var soundPoint:SoundPoint;
			var i:int;
			for( i = 0; i < soundPoints.length; i++ )
			{
				soundPoint = soundPoints[ i ];
				absDistance = Math.abs( soundPoint.x - foregroundX );
				si = soundManager.getSoundItem( soundPoint.soundName );
				if( soundPoint.action == SoundPoint.STOP )
				{
					if( absDistance < soundPoint.maxDistance + soundPoint.width * 0.5 )
					{
						soundManager.stopSound( soundPoint.soundName );
					}
				}
			}
			var soundRect:SoundRectangle;
			var panRect:Rectangle;
			for( i = 0; i < soundRects.length; i++ )
			{
				soundRect = soundRects[ i ];
				panRect = soundRect.panRect;
				si = soundManager.getSoundItem( soundRect.soundName );
				xDistanceFromCenter = panRect.x + panRect.width * 0.5 - foregroundX;
				yDistanceFromCenter = panRect.y + panRect.height * 0.5 - playerYPos;
				absDistance = Math.abs( xDistanceFromCenter );
					
				// If the player is within the left and right bounds, don't alter the sound
				if( soundRect.contains( foregroundX, playerYPos ) )
				{
					pan = 0;
					xDistMultiplier = 1;
				}
				else if( foregroundX > panRect.x && foregroundX < panRect.x + panRect.width )
				{
					// This will be positive and less than one
					pan = Math.abs( Math.abs( xDistanceFromCenter ) - soundRect.width * 0.5 ) / ( ( panRect.width - soundRect.width ) * 0.5 );
					xDistMultiplier = 1 - pan;
					pan *= xDistanceFromCenter < 0 ? -1 : 1;
				}
				else
				{
					xDistMultiplier = 0;
					soundManager.setDistanceMultiplier( soundRect.soundName, 0 );
					continue;
				}
				if( playerYPos > soundRect.y && playerYPos < soundRect.y + soundRect.height )
				{
					yDistMultiplier = 1;
				}
				else if( playerYPos > panRect.y && playerYPos < panRect.y + panRect.height )
				{
					yDistMultiplier = 1 - Math.abs( Math.abs( yDistanceFromCenter ) - soundRect.height * 0.5 ) / ( ( panRect.height - soundRect.height ) * 0.5 );
				}
				else
				{
					yDistMultiplier = 0;
				}
				soundManager.setDistanceMultiplier( soundRect.soundName, yDistMultiplier * xDistMultiplier );
				soundManager.panSound( soundRect.soundName, pan );
			}
		}
	}
}
