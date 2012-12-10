package core {
	import controllers.LevelController;

	import views.Beach;
	import views.BeachScene;
	import views.CaveExit;
	import views.Credits;
	import views.FinalJourney;
	import views.FlowerScene;
	import views.MainMenuScreen;
	import views.StageOne;
	import views.StageThree;
	import views.StageTwo;

	import com.flashdynamix.utils.SWFProfiler;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	[SWF(name="i_solated", width="800", height="600", frameRate="60", backgroundColor="#444444")]
	public class Main extends Sprite 
	{
		private var deltaTime:Number;
		private var lastTime : Number = 0;
		private var stageOne : StageOne;
		private var screenController : LevelController;
		private var mainMenu : MainMenuScreen;
		private var stageTwo : StageTwo;
		private var _currentStage:int = 1;
		private var _stages : Array = [];
		private var stageThree:StageThree;
		private var flowerScene:FlowerScene;
		private var finalJourney:FinalJourney;
		private var caveExit:CaveExit;
		private var beach:Beach;
		private var beachScene:BeachScene;
		private var credits:Credits;
		
		public function Main()
		{
			SWFProfiler.init( this );
			TweenPlugin.activate([FramePlugin]);
			Sounds.onInitialSoundsLoaded.addOnce( _showMainMenu );
			Sounds.init();
			ScreenManager.getInstance( this );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			stageOne = new StageOne();
			stageTwo = new StageTwo();
			stageThree = new StageThree();
			flowerScene = new FlowerScene();
			caveExit = new CaveExit();
			finalJourney = new FinalJourney();
			beach = new Beach();
			beachScene = new BeachScene();
			credits = new Credits();
			_stages.push( stageOne, stageTwo, stageThree, flowerScene, caveExit, finalJourney, beach, beachScene, credits );
		}
		
		private function onAddedToStage(evt:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			deltaTime = 0.0;
			lastTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, this._keyDown );
		}
		
		private function _showMainMenu():void
		{
			mainMenu = new MainMenuScreen();
			mainMenu.onStartGame.addOnce( start );
			ScreenManager.changeScreen( mainMenu, null );		
		}
		
		private function start():void
		{
			screenController = new LevelController( stage );
			screenController.currentStage = _currentStage;
			if( _currentStage < _stages.length )
				_stages[ _currentStage - 1 ].onComplete.addOnce( _nextStage );
			ScreenManager.changeScreen( _stages[ _currentStage - 1 ], screenController );
		}
		
		private function _nextStage():void
		{
			_stages[ _currentStage - 1 ] = null;
			_currentStage++;
 			screenController.currentStage = _currentStage;
			_stages[ _currentStage - 1 ].onComplete.addOnce( _nextStage );
			ScreenManager.changeScreen( _stages[ _currentStage - 1 ], screenController );
		}
		
		private function enterFrame( event:Event ) : void 
		{			
			deltaTime = getTimer() - lastTime;
		    lastTime += deltaTime;
			ScreenManager.update( deltaTime * 0.001 );
		}
		
		private function _keyDown( e:KeyboardEvent ):void
		{
			if( e.keyCode == Keyboard.RIGHT )
				this._nextStage();
		}
	}
}
