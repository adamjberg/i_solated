package core {
	import views.IScreen;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author Adam
	 */
	public class ScreenManager 
	{
		private static var _instance:ScreenManager;
		private static var _allowInstantiation:Boolean;
		private static var _currentScreen:IScreen;
		private static var _screenContainer:DisplayObjectContainer;
 
 		public function get currentScreen():IScreen { return _currentScreen; }
 
		public static function getInstance( p_screenContainer:DisplayObjectContainer = null ):ScreenManager 
		{
			if ( _instance == null ) 
			{
				_allowInstantiation = true;
				_instance = new ScreenManager();
				_allowInstantiation = false;
			}
			if ( p_screenContainer )
			{
				setScreenContainer( p_screenContainer );
			}
 
			return _instance;
		}
 
		/**
		 * 
		 * @param	p_screenContainer	Object that is parent of each screen -- for example, the document class
		 */
		public function ScreenManager():void 
		{
			if ( !_allowInstantiation ) 
			{
				throw new Error("Error: Instantiation failed: Use ScreenManager.getInstance() instead of new.");
			}
		}
 
		public static function setScreenContainer( p_screenContainer:DisplayObjectContainer ):void
		{
			_screenContainer = p_screenContainer;
		}
 
		/**
		 * Update logic for the current screen.
		 */
		public static function update( dt:Number):void
		{
			if( _currentScreen )
				_currentScreen.update( dt );
		}	
 
		/**
		 * A simplified way of loading and unloading screens
		 * Notice that the method is static so that anyone can call it.
		 * @param	p_newscreen	The screen to switch to.
		 */
		public static function changeScreen( p_newScreen:IScreen, controller:* ):void
		{
			if ( ( p_newScreen is DisplayObject ) && ( _screenContainer ) )
			{
				if ( _currentScreen != null )
				{
					_screenContainer.removeChild( _currentScreen as DisplayObject );
					_currentScreen.unload();
				}
				_currentScreen = p_newScreen;
				_screenContainer.addChild( _currentScreen as DisplayObject );
				p_newScreen.load( controller );
			}
			else
			{
				throw new Error("Error: game screens must be of type DisplayObject and scene container must be set.");
			}
		}
	}
}
