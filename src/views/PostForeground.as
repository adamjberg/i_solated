package views {
	import core.Arrays;
	import core.SpriteManager;

	import models.ForegroundModel;
	import models.PulseModel;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class PostForeground extends Foreground 
	{
		public var onTag:Signal = new Signal( String );	
		
		public var foregroundMask:Sprite;
		public var foreground:Sprite;
		private var pulseModel:PulseModel;
		private var pulse:PulseMask;
		private var taggables:Array = [];
		private var _keepMask:Boolean = false;
		private var _addForegroundAsChild:Boolean;
		
		public function PostForeground( foreground:Sprite, foregroundModel:ForegroundModel, taggableNames:Array, pulseModel:PulseModel, taggableMasks:Array = null, addForegroundAsChild:Boolean = true ) 
		{
			var object:Taggable;
			var taggableMask:TaggableMask;
						
			_addForegroundAsChild = addForegroundAsChild;
			taggableNames.forEach( function( name:String, i:int, a:Array ):void
			{
				if( taggableMasks )
				{
					if( taggableMasks[ i ] )
						taggableMask = taggableMasks[ i ];
					else
						taggableMask = null;
				}
				var sprite:Sprite = foreground.getChildByName( name ) as Sprite;
				if( !_addForegroundAsChild )
				{
					sprite.x += foreground.x;
					sprite.y += foreground.y;
				}
				object = new Taggable( sprite, name, taggableMask );
				object.onTag.addOnce( _objectTagged );
				taggables.push( object );
			});
			this.foreground = foreground;
						
			this.pulseModel = pulseModel;
			this.pulseModel.onPlay.add( showTaggables );
			this.pulseModel.onComplete.add( hideTaggables );
			
			this.pulse = new PulseMask( pulseModel );
			this.foregroundMask = new Sprite();
			this.addChild( foregroundMask );
			this.foregroundMask.cacheAsBitmap = true;
			this.foreground.cacheAsBitmap = true;
			
			if( _addForegroundAsChild )
			{
				this.addChild( this.foreground );
				this.foreground.mask = foregroundMask;
			}
			else
			{
				this.mask = foregroundMask;
			}
			super( foregroundModel );
		}

		private function _updatePos():void
		{	
			if( !stage )
				return;
			var rect:Rectangle = this.scrollRect;
			rect.x = -foregroundModel.x;
			rect.y = -foregroundModel.y;
			this.scrollRect = rect;
		}

		public function destroy():void
		{
			removeChildren();
			onTag.removeAll();
			
			foregroundMask = null;
			foreground = null;
			pulseModel = null;
			pulse = null;
			taggables = null;
			onTag = null;
		}

		public function keepMask():void
		{
			this._keepMask = true;
		}

		public function removeMask():void
		{
			if( _addForegroundAsChild )
			{
				this.foreground.mask = null;
			}
			else
			{
				this.mask = null;
			}
			if( this.contains( foregroundMask ) )
				this.removeChild( foregroundMask );
		}

		public function clearMask():void
		{
			this.foregroundMask.graphics.clear();			
		}
		
		protected function tagObjectByName( name:String ):void
		{
			for( var i:int = 0; i < taggables.length; i++ )
			{
				if( ( taggables[ i ] as Taggable ).name == name )
				{
					_objectTagged( taggables[ i ] );
					return;
				}
			}
		}
		
		protected function _objectTagged( taggable:Taggable ):void
		{
			var rect:Rectangle = taggable.object.getBounds( this );
			if( taggable.mask )
			{
				switch( taggable.mask.position )
				{
					case TaggableMask.CENTER:
						taggable.mask.x = rect.x + rect.width * 0.5;
						taggable.mask.y = rect.y + rect.height * 0.5;
						break;
					case TaggableMask.TOP_LEFT:
						taggable.mask.x = rect.x;
						taggable.mask.y = rect.y;
						break;
					case TaggableMask.TOP_CENTER:
						taggable.mask.x = rect.x + rect.width * 0.5;
						taggable.mask.y = rect.y;
						break;
					case TaggableMask.TOP_RIGHT:
						taggable.mask.x = rect.x + rect.width;
						taggable.mask.y = rect.y;
						break;
					case TaggableMask.CENTER_LEFT:
						taggable.mask.x = rect.x;
						taggable.mask.y = rect.y + rect.height * 0.5;
						break;
					case TaggableMask.CENTER_RIGHT:
						taggable.mask.x = rect.x + rect.width;
						taggable.mask.y = rect.y + rect.height * 0.5;
						break;
					case TaggableMask.BOTTOM_CENTER:
						taggable.mask.x = rect.x + rect.width * 0.5;
						taggable.mask.y = rect.y + rect.height;
						break;
					case TaggableMask.BOTTOM_LEFT:
						taggable.mask.x = rect.x;
						taggable.mask.y = rect.y + rect.height;
						break;
					case TaggableMask.BOTTOM_RIGHT:
						taggable.mask.x = rect.x + rect.width;
						taggable.mask.y = rect.y + rect.height;
						break;
					
				}
				this.foregroundMask.addChild( taggable.mask );
			}
			else
			{
				this.foregroundMask.graphics.beginFill( 0 );
				this.foregroundMask.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			}
			SpriteManager.disableMouse( taggable.object );
			this.taggables = Arrays.remove( this.taggables, [ taggable ] );
			onTag.dispatch( taggable.name );
		}
		
		protected function addTaggable( taggable:Taggable ):void
		{
			taggable.onTag.addOnce( _objectTagged );
			taggables.push( taggable );
		}
		
		protected function hideTaggables():void
		{
			if( _keepMask )
				return;
			if( foregroundMask.contains( pulse ) )
				this.foregroundMask.removeChild( pulse );
			this.taggables.forEach( function ( taggable:Taggable, i:int, a:Array ):void
			{
				taggable.hide();
			});
		}
		
		protected function showTaggables():void
		{
			if( !foregroundMask.contains( pulse ) )
				this.foregroundMask.addChild( pulse );
			this.taggables.forEach( function ( taggable:Taggable, i:int, a:Array ):void
			{
				taggable.show();
			});
		}
	}
}
