package controllers {
	import core.Sounds;

	import models.BucketConveyorModel;
	import models.BucketType;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author Adam
	 */
	public class BucketConveyorController 
	{
		private var bucketTimer:Timer;
		public var bucketConveyorModel:BucketConveyorModel;
		
		public function BucketConveyorController()
		{
			bucketConveyorModel = new BucketConveyorModel();
			bucketTimer = new Timer( BucketConveyorModel.BUCKET_MOVE_DELAY );
			bucketTimer.addEventListener( TimerEvent.TIMER, _nextBucket );
			var random:Number;
			for( var i:int = 0; i < BucketConveyorModel.NUM_BUCKETS; i++ )
			{
				random = Math.random();
				if( random > 0.75 )
					bucketConveyorModel.bucketTypes.push( BucketType.POST );
				else
					bucketConveyorModel.bucketTypes.push( BucketType.PRE );
				bucketConveyorModel.visibleBucketTypes.push( BucketType.PRE );
			}
			_nextBucket();
		}
		
		public function destroy():void
		{
			bucketTimer.stop();
			bucketTimer.removeEventListener( TimerEvent.TIMER, _nextBucket );
			this.bucketConveyorModel.onAllowEmptyChanged.removeAll();
			this.bucketConveyorModel.onBucketTypesChanged.removeAll();
			this.bucketConveyorModel.onNextBucket.removeAll();
			this.bucketConveyorModel.onPosChanged.removeAll();
			this.bucketConveyorModel.onVisibleBucketsChanged.removeAll();
			TweenLite.killDelayedCallsTo( _nextBucket );
			TweenLite.killTweensOf( this.bucketConveyorModel );
			bucketConveyorModel = null;
		}
		
		public function pause():void
		{
			bucketConveyorModel.allowEmpty = false;
			bucketTimer.reset();
		}
		
		public function _nextBucket( e:TimerEvent = null ):void
		{
			var random:Number = Math.random();
			if( random > 0.5 )
			{
				this.bucketConveyorModel.bucketTypes.unshift( BucketType.PRE );
			}
			else
			{
				this.bucketConveyorModel.bucketTypes.unshift( BucketType.POST );
			}
			this.bucketConveyorModel.bucketTypes.pop();
			this.bucketConveyorModel.visibleBucketTypes.unshift( BucketType.PRE );
			this.bucketConveyorModel.visibleBucketTypes.pop();
			SoundManager.getInstance().playSound( Sounds.BUCKET_MOVEMENT );
			bucketConveyorModel.onBucketTypesChanged.dispatch();
			bucketConveyorModel.onVisibleBucketsChanged.dispatch();
			bucketConveyorModel.onNextBucket.dispatch();
			bucketTimer.reset();
			bucketConveyorModel.allowEmpty = false;
			bucketConveyorModel.x = 0;
			TweenLite.to( bucketConveyorModel, 2, { x: BucketConveyorModel.DISTANCE_BETW_BUCKETS, ease: Quad.easeOut, onComplete: _enableBucketOpen } );
		}
		
		public function attemptBucketRelease():void
		{
			if( bucketConveyorModel.allowEmpty )
			{
				pause();
				bucketConveyorModel.empty();
			}
		}
		
		public function bucketEmptied():void
		{
			TweenLite.delayedCall( 1, _nextBucket );
		}
		
		private function _enableBucketOpen():void
		{
			if( this.bucketConveyorModel.bucketTypes[ this.bucketConveyorModel.bucketTypes.length - 2 ] == BucketType.PRE )
				bucketConveyorModel.allowEmpty = true;
			bucketTimer.start();
		}
	}
}
