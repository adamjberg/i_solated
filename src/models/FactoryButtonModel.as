package models {
	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class FactoryButtonModel 
	{
		public var onStateChanged:Signal = new Signal();
		
		private var _on:Boolean = false;
		public function get on():Boolean { return _on; }
		public function set on( o:Boolean ):void { this._on = o; this.onStateChanged.dispatch(); }
		
		public function FactoryButtonModel()
		{
			
		}
	}
}
