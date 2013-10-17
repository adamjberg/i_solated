package views {
	import models.BucketConveyorModel;
	import models.BucketType;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 * @author Adam
	 */
	public class BucketConveyor extends Sprite 
	{
		public var buckets:Array = [];
		private var bucketMask:Sprite;
		private var bucketContainer:Sprite;
		private var model:BucketConveyorModel;
		private var xOffset:Number;
		
		public function BucketConveyor( xOffset:Number, model:BucketConveyorModel, post:Boolean = false ) 
		{
			this.xOffset = xOffset;
			this.model = model;
			this.model.onPosChanged.add( _updatePos );
			this.model.onAllowEmptyChanged.add( _updateBucketLight );
			
			bucketContainer = new Sprite();		
			
			bucketMask = new Sprite();
			this.mask = bucketMask;
			
			if( !post )
			{
				this.model.onVisibleBucketsChanged.add( _updateVisibleBucketTypes );
				_updateVisibleBucketTypes();
			}
			else
			{
				_updateBucketTypes();
				this.model.onBucketTypesChanged.add( _updateBucketTypes );
				this.addEventListener( MouseEvent.MOUSE_DOWN, _tagBucket );
			}
		}

		private function _tagBucket( e:MouseEvent ):void
		{
			if( e.target is PostBucket )
			{
				buckets.forEach( function( bucket:Sprite, i:int, a:Array ):void
				{
					if( e.target == bucket )
					{
						model.visibleBucketTypes[ i ] = BucketType.POST;
						model.onVisibleBucketsChanged.dispatch();
					}
				});
			}
			
		}
		
		private function _updateVisibleBucketTypes():void
		{
			removeChildren();
			buckets.forEach( function( bucket:Sprite, i:int, a:Array ):void
			{
				bucketContainer.removeChild( bucket );
				bucket = null;
			});
			buckets = [];
			var bucket:Sprite;
			for( var i:int = 0; i < BucketConveyorModel.NUM_BUCKETS; i++ )
			{
				if( model.visibleBucketTypes[ i ] == BucketType.PRE )
					bucket = new PreBucket();
				else
					bucket = new PostBucket();
				bucket.x = ( i - 1 ) * BucketConveyorModel.DISTANCE_BETW_BUCKETS + xOffset;
				buckets.push( bucket );
				bucketContainer.addChild( bucket );
			}
			this.addChild( bucketMask );
			this.addChild( bucketContainer );
			_updateMask();
		}
		
		private function _updateBucketTypes():void
		{
			var bucket:Sprite;
			removeChildren();
			buckets.forEach( function( bucket:Sprite, i:int, a:Array ):void
			{
				bucketContainer.removeChild( bucket );
				bucket = null;
			});
			buckets = [];
			for( var i:int = 0; i < BucketConveyorModel.NUM_BUCKETS; i++ )
			{
				if( this.model.bucketTypes[ i ] == BucketType.POST )
				{
					bucket = new PostBucket();
					bucket.buttonMode = true;
				}
				else
				{
					bucket = new PreBucket();
					
				}
				bucket.x = ( i - 1 ) * BucketConveyorModel.DISTANCE_BETW_BUCKETS + xOffset;
				buckets.push( bucket );
				bucketContainer.addChild( bucket );
			}
			this.addChild( bucketMask );
			this.addChild( bucketContainer );
			_updateMask();
		}
		
		private function _updateMask():void
		{
			bucketMask.graphics.clear();
			bucketMask.graphics.beginFill( 0 );
			bucketMask.graphics.drawRect( 0, 0, bucketContainer.width - BucketConveyorModel.DISTANCE_BETW_BUCKETS * .55, -buckets[ 0 ].height );
		}
		
		private function _updateBucketLight():void
		{
			if( this.model.allowEmpty )
			{
				if( buckets[ buckets.length - 2 ] is PreBucket )
				{
					setTimeout( buckets[ buckets.length - 2 ].on, 250 );
				}
			}
			else
			{
				if( buckets[ buckets.length - 2 ] is PreBucket )
				{
					buckets[ buckets.length - 2 ].off();
				}
			}
		}
		
		private function _updatePos():void
		{
			bucketContainer.x = this.model.x;
		}
	}
}
