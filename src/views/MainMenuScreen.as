package views {
	import controllers.SoundManager;
	import core.Sounds;
	import core.TextFactory;
	import org.osflash.signals.Signal;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Adam
	 */
	public class MainMenuScreen extends Sprite implements IScreen 
	{
		public var onStartGame:Signal = new Signal();
		
		private var title:Title;
		private var clickToStart:TextField;
		
		public function MainMenuScreen() 
		{
		}

		public function update(dt : Number) : void 
		{
			
		}

		public function load(controller : *) : void 
		{
			title = new Title();
			addChild( title );
			
			var textFormat:TextFormat = TextFactory.textFormat();
			clickToStart = TextFactory.textField(
			{
				text: "Click to Start",
				textFormat: textFormat
			});
			clickToStart.x = ( stage.stageWidth - clickToStart.width ) * 0.5;
			clickToStart.y = stage.stageHeight * .65;
			addChild( clickToStart );
						
			SoundManager.getInstance().createLoopCrossFade( Sounds.WIND, 3, 3 );
			
			addEventListener( MouseEvent.CLICK, onMouseClick );
		}

		private function onMouseClick(event:MouseEvent) : void 
		{
			removeEventListener( MouseEvent.CLICK, onMouseClick );
			event.stopImmediatePropagation();
			event.stopPropagation();
			onStartGame.dispatch();
		}

		public function unload() : void 
		{
			onStartGame.removeAll();
			onStartGame = null;
			removeChildren();
			title = null;
			clickToStart = null;
		}
	}
}
