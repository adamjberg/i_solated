package core {
	import controllers.SoundManager;

	import events.SoundManagerEvent;

	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class Sounds 
	{
		public static var onInitialSoundsLoaded:Signal = new Signal();
		
		private static const WEB:Boolean = true;
		private static const FILE_LOC:String = WEB ? "http://www.catharticgames.com/games/i_solated/assets/Sounds/" : "../assets/Sounds/";
		
		public static const BGM_START_CH1:String = 'BGMStartCh1';
		public static const BGM_LOOP_CH1:String = 'BGMLoopCh1';
		public static const BGM_START_CH2:String = 'BGMStartCh2';
		public static const BGM_LOOP_CH2:String = 'BGMLoopCh2';
		public static const BGM_END_CH2:String = 'BGMEndCh2';
		public static const BGM_CH3:String = 'BGMCh3';
		public static const BONUS_SONG:String = 'BonusTrack';
		public static const CREDITS:String = 'Credits';
		public static const REVEAL_ROOM_MUSIC:String = 'RevealRoomMusic';
		public static const START_JUMP:String = 'Start Jump';
		public static const PULSE:String = 'Pulse';
		public static const WIND:String = 'Wind';
		public static const WAVES_START:String = 'WavesStart';
		public static const WAVES:String = 'Waves';
		public static const SMALL_LANDING:String = ' Small landing';
		public static const CLIFF_WALKING:String = 'Cliff Walking';
		public static const FACTORY_WALKING:String = 'Factory Walking';
		public static const GRASS_WALKING:String = 'Grass Walking';
		public static const WALKING_WITH_ITEM:String = 'Walking With Item';
		public static const WALKING_WITH_ITEM_FACTORY:String = 'Walking With Item Factory';
		public static const TREE_BREAK:String = 'TreeBreak';
		public static const CRACK_ONE:String = 'CrackOne';
		public static const CRACK_TWO:String = 'CrackTwo';
		public static const LOG_BREAK:String = 'LogBreak';
		public static const WATER_FALL:String = 'Waterfall';		
		public static const WATER_FALL2:String = 'Waterfall2';
		public static const DRIPPING:String = 'Dripping';
		public static const RIVER:String = 'River';
		public static const WATER_WHEEL:String = 'WaterWheel';
		public static const PICK_UP_COG:String = 'pickUpCog';
		public static const PLACE_COG:String = 'placeCog';
		public static const PICK_UP_ROCK:String = 'pickUpRock';
		public static const BRIDGE_BREAK:String = 'brideBreak';
		public static const BRIDGE_PIECE_FALL:String = 'bridgePieceFall';
		public static const GATE_LIFTING:String = 'gateLifting';
		public static const PLACE_ROCK:String = 'placeRock';
		public static const BUCKET_MOVEMENT:String = 'bucketMovement';
		public static const ELEVATOR:String = 'elevator';
		public static const BUTTON_1:String = 'button1';
		public static const BUTTON_2:String = 'button2';
		public static const BUTTON_3:String = 'button3';
		public static const FACTORY_RIVER:String = 'factoryRiver';
		public static const SPARK:String = 'spark';
		public static const VALVE_SCENE:String = 'valveScene';
		public static const WATER_FILL_1:String = 'waterfill1';
		public static const WATER_FILL_2:String = 'waterFill2';
		public static const WATER_FILL_3:String = 'waterFill3';
		public static const SAND_FOOTSTEPS:String = 'sandFootsteps';
		public static const VALVE_PICKUP:String = 'valvePickUp';
		public static const FLOWER_SCENE:String = 'flowerScene';
		public static const RAIN:String = 'rain';
		public static const TIME_LAPSE:String = 'timeLapse';
		public static const INTO_TIME_LAPSE:String = 'IntoTimeLapse';
		public static const BEACH_SCENE:String = 'beachScene';
		public static const REST_SCENE:String = 'restScene';
		public static const WOOD_WALKING:String = 'woodWalking';			
		
		public static const WALKING_SOUNDS:Array = 
		[
			CLIFF_WALKING, FACTORY_WALKING, GRASS_WALKING, WALKING_WITH_ITEM, WALKING_WITH_ITEM_FACTORY, WOOD_WALKING
		];
		
		private static var soundManager:SoundManager;
		
		private static var chapterOneSounds:Array =
		[
			WIND, BGM_START_CH1, BGM_LOOP_CH1, REST_SCENE
		];
		
		private static var chapterTwoSounds:Array =
		[
			RIVER, TREE_BREAK, CRACK_ONE, CRACK_TWO, LOG_BREAK, WATER_FALL, WATER_FALL2,
			DRIPPING, BGM_START_CH2, BGM_LOOP_CH2, BGM_END_CH2, WATER_WHEEL, PICK_UP_COG,
			PLACE_COG, PICK_UP_ROCK, BRIDGE_BREAK, GATE_LIFTING, PLACE_ROCK, WOOD_WALKING
		];
		
		private static var factorySounds:Array = 
		[
			BUCKET_MOVEMENT, ELEVATOR, BUTTON_1, BUTTON_2, BUTTON_3, FACTORY_RIVER, SPARK, 
			VALVE_SCENE, WATER_FILL_1, WATER_FILL_2,WATER_FILL_3, VALVE_PICKUP, REVEAL_ROOM_MUSIC
		];
		
		private static var flowerSceneSounds:Array =
		[
			FLOWER_SCENE
		];
		
		private static var caveExitSounds:Array =
		[
			RAIN, BGM_CH3, INTO_TIME_LAPSE
		];
		
		private static var finalJourneySounds:Array =
		[
			SAND_FOOTSTEPS, WAVES_START, WAVES
		];
		
		private static const timeLapseSounds:Array = [ TIME_LAPSE ];
				
		private static var beachSounds:Array =
		[
			BEACH_SCENE
		];
		
		private static const GENERAL_SOUNDS:Array =
		[
			SMALL_LANDING, PULSE, START_JUMP, GRASS_WALKING, CLIFF_WALKING, WALKING_WITH_ITEM
		];
		
		private static var numSoundsLoaded:Number = 0;
		
		public static function init():void
		{
			soundManager = SoundManager.getInstance();
			soundManager.addEventListener( SoundManagerEvent.SOUND_ITEM_LOAD_COMPLETE, _checkIfAllSoundsAreLoaded );
			addInitialSounds();
		}
		
		private static function _checkIfAllSoundsAreLoaded( e:SoundManagerEvent ):void
		{
			numSoundsLoaded++;
			if( numSoundsLoaded == soundManager.sounds.length )
			{
				onInitialSoundsLoaded.dispatch();
				soundManager.removeEventListener( SoundManagerEvent.SOUND_ITEM_LOAD_COMPLETE, _checkIfAllSoundsAreLoaded );
				addGeneralSounds();
				addChapterOneSounds();
				addChapterTwoSounds();
				addFlowerSceneSounds();
				addFactorySounds();
				addCaveExitSounds();
				addTimeLapseSounds();
				addFinalJourneySounds();
				addBeachSceneSounds();
				addCreditsSounds();
			}
		}
		
		public static function transitionOutChapter1( time:Number, delay:Number ):void
		{
			transitionSoundsOut( chapterOneSounds, time, delay );
		}
		
		public static function transitionOutChapter2( time:Number, delay:Number ):void
		{
			transitionSoundsOut( chapterTwoSounds, time, delay );
		}
		
		public static function transitionOutFactory( time:Number, delay:Number ):void
		{
			transitionSoundsOut( factorySounds, time, delay );
		}
		
		public static function transitionOutFlowerScene( time:Number, delay:Number ):void
		{
			transitionSoundsOut( flowerSceneSounds, time, delay );
		}
		
		public static function transitionOutCaveExit( time:Number, delay:Number ):void
		{
			transitionSoundsOut( caveExitSounds, time, delay );
		}
		
		public static function transitionOutTimeLapse( time:Number, delay:Number ):void
		{
			transitionSoundsOut( timeLapseSounds, time, delay );
		}
		
		public static function transitionOutFinalJourney( time:Number, delay:Number ):void
		{
			transitionSoundsOut( finalJourneySounds, time, delay );
		}
		
		public static function transitionOutBeachScene( time:Number, delay:Number ):void
		{
			transitionSoundsOut( beachSounds, time, delay );
		}
		
		public static function transitionSoundsOut( sounds:Array, time:Number, delay:Number, onComplete:Function = null ):void
		{
			sounds.forEach( function( soundName:String, i:int, a:Array ):void
			{
				var si:SoundItem = soundManager.getSoundItem( soundName );
				if( si )
				{
					if( si.crossFade )
					{
						_fadeAndRemoveSound( SoundManager.getInstance().getSoundItem( si.name + SoundManager.LOOP_SUFFIX ), time, delay );
					}
					_fadeAndRemoveSound( si, time, delay );
				}
				
			});
			if( onComplete != null )
				onComplete();
		}
		
		private static function _fadeAndRemoveSound( si:SoundItem, time:Number, delay:Number = 0 ):void
		{
			TweenLite.killTweensOf( si );
			si.onFadeComplete.addOnce( function( si:SoundItem ):void
			{
				soundManager.removeSound( si.name ); 
			});
			si.fade( 0, time , delay, true );
		}
		
		private static function addInitialSounds():void
		{
			soundManager.addExternalSound( FILE_LOC + 'Wind Noise Ch. 1.mp3', WIND );
			soundManager.addExternalSound( FILE_LOC + 'Ch.1MusicStart.mp3', BGM_START_CH1 );
		}
		
		private static function addGeneralSounds():void
		{
			soundManager.addExternalSound( FILE_LOC + 'Pulse.mp3', PULSE );
			soundManager.addExternalSound( FILE_LOC + 'GrassWalking.mp3', GRASS_WALKING );
			soundManager.addExternalSound( FILE_LOC + 'GrassWalkingWithObject.mp3', WALKING_WITH_ITEM );
			soundManager.addExternalSound( FILE_LOC + 'FactoryFootsteps.mp3', FACTORY_WALKING );
			soundManager.addExternalSound( FILE_LOC + 'FactoryFootstepsWithObject.mp3', WALKING_WITH_ITEM_FACTORY );
		}
		
		private static function addChapterOneSounds():void
		{
			//CHAPTER 1
			soundManager.addExternalSound( FILE_LOC + 'Ch.1RestSceneSoundRevised.mp3', REST_SCENE );
			soundManager.addExternalSound( FILE_LOC + 'Ch.1MusicLoop.mp3', BGM_LOOP_CH1 );
			soundManager.addExternalSound( FILE_LOC + 'DirtWalking.mp3', CLIFF_WALKING );
			soundManager.addExternalSound( FILE_LOC + 'Start Jump Ch. 1.mp3', START_JUMP );
			soundManager.addExternalSound( FILE_LOC + 'Small Landing Ch. 1.mp3', SMALL_LANDING );
		}
		
		private static function addChapterTwoSounds():void
		{
			//CHAPTER 2
			soundManager.addExternalSound( FILE_LOC + 'Ch.2RiverLoop.mp3', RIVER );
			soundManager.addExternalSound( FILE_LOC + 'Catapult.mp3', TREE_BREAK );
			soundManager.addExternalSound( FILE_LOC + 'LogCrack1.mp3', CRACK_ONE );
			soundManager.addExternalSound( FILE_LOC + 'LogCrack2.mp3', CRACK_TWO );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2LogBreakWaterfall.mp3', LOG_BREAK );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2WaterfallLoop.mp3', WATER_FALL );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2WaterfallLoop.mp3', WATER_FALL2 );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2WaterfallDrops.mp3', DRIPPING );
			soundManager.addExternalSound( FILE_LOC + 'Ch2MusicStart.mp3', BGM_START_CH2 );
			soundManager.addExternalSound( FILE_LOC + 'Ch2MusicLoop.mp3', BGM_LOOP_CH2 );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2MusicEnding.mp3', BGM_END_CH2 );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2Waterwheel.mp3', WATER_WHEEL );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2CogPickup.mp3', PICK_UP_COG );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2CogPlacement.mp3', PLACE_COG );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2RockPickup.mp3', PICK_UP_ROCK );
			soundManager.addExternalSound( FILE_LOC + 'BridgeBreakWithPing.mp3', BRIDGE_BREAK );
			soundManager.addExternalSound( FILE_LOC + 'BridgePreBreakBounce.mp3', BRIDGE_PIECE_FALL );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2GateLifting.mp3', GATE_LIFTING );
			soundManager.addExternalSound( FILE_LOC + 'Ch.2RockPlacement.mp3', PLACE_ROCK );
			soundManager.addExternalSound( FILE_LOC + 'WoodFootSteps.mp3', WOOD_WALKING );				
		}
		
		private static function addFactorySounds():void
		{
			// FACTORY
			soundManager.addExternalSound( FILE_LOC + 'BucketLineMovement.mp3', BUCKET_MOVEMENT );
			soundManager.addExternalSound( FILE_LOC + 'ElevatorSound.mp3', ELEVATOR );
			soundManager.addExternalSound( FILE_LOC + 'FactoryButtonPush1.mp3', BUTTON_1 );
			soundManager.addExternalSound( FILE_LOC + 'FactoryButtonPush2.mp3', BUTTON_2 );
			soundManager.addExternalSound( FILE_LOC + 'FactoryButtonPush3.mp3', BUTTON_3 );
			soundManager.addExternalSound( FILE_LOC + 'FactoryRiver.mp3', FACTORY_RIVER );
			soundManager.addExternalSound( FILE_LOC + 'FactoryWireSpark.mp3', SPARK );
			soundManager.addExternalSound( FILE_LOC + 'ValveSceneSoundBounce.mp3', VALVE_SCENE );
			soundManager.addExternalSound( FILE_LOC + 'Waterfill1.mp3', WATER_FILL_1 );
			soundManager.addExternalSound( FILE_LOC + 'Waterfill2.mp3', WATER_FILL_2 );
			soundManager.addExternalSound( FILE_LOC + 'Waterfill3.mp3', WATER_FILL_3 );
			soundManager.addExternalSound( FILE_LOC + 'ValvePickUp.mp3', VALVE_PICKUP );
			soundManager.addExternalSound( FILE_LOC + 'RevealSceneMusic.mp3', REVEAL_ROOM_MUSIC );	
		}
		
		private static function addFlowerSceneSounds():void
		{
			// FLOWER SCENE
			soundManager.addExternalSound( FILE_LOC + 'DiscoverSceneSound.mp3', FLOWER_SCENE );
		}
		
		private static function addCaveExitSounds():void
		{
			// CHAPTER 3
			soundManager.addExternalSound( FILE_LOC + 'RainLoop.mp3', RAIN );
			soundManager.addExternalSound( FILE_LOC + 'Ch.3 Music.mp3', BGM_CH3 );
			soundManager.addExternalSound( FILE_LOC + 'LeadingToTimeLapse.mp3', INTO_TIME_LAPSE );
		}
		
		private static function addFinalJourneySounds():void
		{
			soundManager.addExternalSound( FILE_LOC + 'DragginInSand(Better).mp3', SAND_FOOTSTEPS );
			soundManager.addExternalSound( FILE_LOC + 'WavesLoop.mp3', WAVES );
			soundManager.addExternalSound( FILE_LOC + 'WavesStart.mp3', WAVES_START );
		}
		
		private static function addTimeLapseSounds():void
		{
			soundManager.addExternalSound( FILE_LOC + 'TimeLapseSoundOnlyPiano.mp3', TIME_LAPSE );
		}
		
		private static function addBeachSceneSounds():void
		{
			// BEACH SCENE
			soundManager.addExternalSound( FILE_LOC + 'BeachSceneWithEndingWaves.mp3', BEACH_SCENE );
		}
		
		private static function addCreditsSounds():void
		{
			soundManager.addExternalSound( FILE_LOC + 'Credits.mp3', CREDITS );
			soundManager.addExternalSound( FILE_LOC + 'BonusTrack.mp3', BONUS_SONG );
		}
	}
}

