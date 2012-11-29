package models {
	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class BucketConveyorModel 
	{
		public var onAllowEmptyChanged:Signal = new Signal();
		public var onEmptyBucket:Signal = new Signal();
		public var onNextBucket:Signal = new Signal();
		public var onPosChanged:Signal = new Signal();
		public var onVisibleBucketsChanged:Signal = new Signal();
		public var onBucketTypesChanged:Signal = new Signal();
		
		public static const BUCKET_MOVE_DELAY:Number = 4000;
		public static const WIDTH:Number = 1000;
		public static const NUM_BUCKETS:Number = 8;
		public static const DISTANCE_BETW_BUCKETS:Number = WIDTH / NUM_BUCKETS;
		
		public var visibleBucketTypes:Array = [];
		public var bucketTypes:Array = [];
		
		private var _allowEmpty:Boolean = false;
		public function get allowEmpty():Boolean { return _allowEmpty; }
		public function set allowEmpty( a:Boolean ):void
		{
			this._allowEmpty = a;
			this.onAllowEmptyChanged.dispatch();
		}
				
		private var _x:Number = 0;
		public function get x():Number { return _x; }
		public function set x( val:Number ):void
		{
			this._x = val;
			onPosChanged.dispatch();
		}
		
		public function BucketConveyorModel()
		{
			
		}
		
		public function empty():void
		{
			this.onEmptyBucket.dispatch();
		}
	}
}
