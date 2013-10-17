package views {
	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Adam
	 */
	public class Taggable
	{
		public var onTag:Signal = new Signal( Taggable );
		
		public var name:String;
		public var object:Sprite;
		public var mask:TaggableMask;
		
		public function Taggable( sprite:Sprite, name:String, mask:TaggableMask = null ) 
		{
			this.object = sprite;
			this.name = name;
			if( !this.object )
			{
				trace( name + ' DOESNT EXXXIIISTTTT!!!!!' );
				return;
			}
			this.object.mouseChildren = false;
			this.object.buttonMode = true;
			this.object.addEventListener( MouseEvent.MOUSE_DOWN, _objectTagged );
			this.mask = mask;
		}
		
		public function show():void
		{
			this.object.visible = true;
			this.object.buttonMode = true;
		}
		
		public function hide():void
		{
			this.object.visible = false;
			this.object.buttonMode = false;
		}
		
		private function _objectTagged( e:MouseEvent ):void
		{
			this.object.removeEventListener( MouseEvent.MOUSE_DOWN, _objectTagged );
			e.stopPropagation();
			onTag.dispatch( this );
		}
	}
}
