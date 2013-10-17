package controllers {
	import models.ElevatorPuzzleModel;

	import org.osflash.signals.Signal;

	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	/**
	 * @author Adam
	 */
	public class ElevatorPuzzleController 
	{
		private const TIME_TIL_LOWER:Number = 8000;
		
		public var onPuzzleComplete:Signal = new Signal();
		public var onHideSpark:Signal = new Signal();
		public var onShowSpark:Signal = new Signal();
		public var onDisableLiftControls:Signal = new Signal();
		public var onEnableLiftControls:Signal = new Signal();
			
		public var elevatorPuzzleModel:ElevatorPuzzleModel;
		
		public function ElevatorPuzzleController( elevatorPuzzleModel:ElevatorPuzzleModel )
		{
			this.elevatorPuzzleModel = elevatorPuzzleModel;
		}
		
		public function jumpedOnElevator():void
		{
			elevatorPuzzleModel.onElevator = true;
		}
		
		public function jumpedOffElevator():void
		{
			elevatorPuzzleModel.onElevator = false;
		}
		
		public function liftButtonPressed():void
		{
			if( elevatorPuzzleModel.allowFullLift )
			{
				this.onPuzzleComplete.dispatch();
				elevatorPuzzleModel.elevatorHeight = ElevatorPuzzleModel.HIGH;
			}
			else if( elevatorPuzzleModel.allowHalfLift )
			{
				elevatorPuzzleModel.elevatorHeight = ElevatorPuzzleModel.MID;
				setTimeout( _lowerElevator, TIME_TIL_LOWER );
			}
		}
		
		public function toggleLeft():void
		{
			elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.LEFT ] = !elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.LEFT ];
			_buttonsChanged();		
		}
		
		public function toggleRight():void
		{
			elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.RIGHT ] = !elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.RIGHT ];
			_buttonsChanged();
		}
		
		public function toggleFarLeft():void
		{
			elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.FAR_LEFT ] = !elevatorPuzzleModel.buttons[ ElevatorPuzzleModel.FAR_LEFT ];
			_buttonsChanged();
		}
		
		private function _buttonsChanged():void
		{
			if( elevatorPuzzleModel.allowFullLift || elevatorPuzzleModel.allowHalfLift )
			{
				onEnableLiftControls.dispatch();
			}
			else
			{
				onDisableLiftControls.dispatch();
			}
			if( elevatorPuzzleModel.allowSpark )
			{
				onShowSpark.dispatch();
			}
			else
			{
				onHideSpark.dispatch();
			}
		}
		
		private function _lowerElevator():void
		{
			this.elevatorPuzzleModel.elevatorHeight = ElevatorPuzzleModel.LOW;
		}
	}
}
