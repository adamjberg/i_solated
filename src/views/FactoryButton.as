package views {
	import models.FactoryButtonModel;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class FactoryButton extends Sprite 
	{
		private var model:FactoryButtonModel;
		private var button:MovieClip;
		
		public function FactoryButton( mc:MovieClip, model:FactoryButtonModel ) 
		{
			button = mc;
			this.model = model;
			this.model.onStateChanged.add( _toggle );
		}
		
		private function _toggle():void
		{
			button.nextFrame();
		}
	}
}
