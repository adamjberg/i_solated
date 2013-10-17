package controllers {
	import models.CameraModel;
	import models.ForegroundModel;
	import models.PanPoint;
	import models.PlayerModel;

	import flash.display.Stage;
	/**
	 * @author Adam
	 */
	public class CameraController 
	{
		private static const X_PAN_DISTANCE:Number = 20;
		private static const Y_PAN_DISTANCE:Number = 30;
		private static const X_STAGE_MULTIPLIER:Number = 0.5;
		private static const X_BUFFER:Number = 15;
		private static const Y_STAGE_MULTIPLIER:Number = 0.7;
		private static const Y_BUFFER:Number = 5;
		
		public var rightWall:Number = int.MIN_VALUE;
		public var cameraModel:CameraModel;
		private var _playerModel:PlayerModel;
		private var _foregroundModel:ForegroundModel;
		private var _foregroundController:ForegroundController;
		private var _playerController : PlayerController;
		private var _stage : Stage;
		private var _currentPanPoint:PanPoint;
		private var camXSpeed:Number = 0;
		private var camYSpeed:Number = 0;
		private var requireMovement:Boolean = true;
		private var allowPanBack : Boolean = true;
		private var enabled : Boolean = true;
		
		public function CameraController( stage:Stage, playerController:PlayerController, foregroundController:ForegroundController )
		{
			this._stage = stage;
			this._playerController = playerController;
			this._foregroundController = foregroundController;
			this._playerModel = playerController.playerModel;
			this._foregroundModel = foregroundController.foregroundModel;
			
			cameraModel = new CameraModel();
			
			this._addListeners();
		}
		
		public function destroy():void
		{
			this._removeListeners();
			
			this.cameraModel = null;
			this._playerModel = null;
			this._foregroundModel = null;
			this._playerController = null;
			this._foregroundController = null;
			this._stage = null;
			this._currentPanPoint = null;
		}
		
		private function _addListeners():void
		{
			this._playerController.onPlayerLanded.add( _adjustPlayerPosition );
			this._playerController.onAnimationPointReached.add( _adjustPlayerPosition );
		}
		
		private function _removeListeners():void
		{
			this._playerController.onPlayerLanded.remove( _adjustPlayerPosition );
			this._playerController.onAnimationPointReached.remove( _adjustPlayerPosition );
		}
		
		public function update( dt:Number ):void
		{
			var centerX:Number =  _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
			
			var leftBounds:Number = centerX - X_BUFFER;
			var rightBounds:Number = centerX + X_BUFFER;
			
			if( this.requireMovement )
			{
				if( _playerModel.xSpeed > 0 )
				{
					centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
					leftBounds = centerX - X_BUFFER;
					rightBounds = centerX + X_BUFFER;
				}
				else if( _playerModel.xSpeed < 0 && allowPanBack )
				{
					centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.defaultXOffset;
					leftBounds = centerX - X_BUFFER;
					rightBounds = centerX + X_BUFFER;	
				}
				else if( _playerModel.xSpeed < 0 )
				{
					centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
					leftBounds = centerX - X_BUFFER;
					rightBounds = centerX + X_BUFFER;
				}
			}
						
			if( ( _playerModel.xPos < leftBounds && _playerModel.xSpeed > 0 ) 
				|| ( _playerModel.xPos > rightBounds && _playerModel.xSpeed < 0 )
				|| ( _playerModel.xSpeed < 0 && _foregroundModel.x > -X_BUFFER )
				|| ( _playerModel.xPos > leftBounds && _foregroundModel.x < rightWall ) )
			{
				_playerController.updateXPos( dt, _playerModel.xSpeed );
			}
			else
			{				
				_foregroundController.updateXPos( dt, _playerModel.xSpeed );
				_panX( dt );
			}
			_playerController.updateYPos( dt, _playerModel.ySpeed );
			
			if( enabled )
			{
				_panY( dt );
							
				this._updateXOffsets();
				this._updateYOffsets();
			}
			
			_playerModel.relativeYPos = _playerModel.yPos - _foregroundModel.y;
			_playerModel.relativeXPos = _playerModel.xPos - _foregroundModel.x;
			_checkForPanPoint();
		}
		
		public function disable():void
		{
			enabled = false;	
		}
		
		public function enable():void
		{
			enabled = true;
		}
		
		public function panToPanPoint( panPoint:PanPoint ):void
		{
			var distance:Number = ( panPoint.endX - panPoint.x );
			
			// TODO: Allow pan points to set y and x speed separately
			//cameraModel.xPanSpeed = ( Math.abs( _playerModel.xOffset - panPoint.xOffset ) / distance ) * _playerModel.BASE_SPEED;
			//cameraModel.yPanSpeed = ( Math.abs( _playerModel.yOffset - panPoint.yOffset ) / distance ) * _playerModel.BASE_SPEED;
			
			cameraModel.xPanSpeed = cameraModel.yPanSpeed = panPoint.cameraSpeed;
			this._currentPanPoint = panPoint;
			if( _playerModel.xSpeed > 0 )
				panTo( panPoint.xOffset, panPoint.yOffset, _currentPanPoint.requireMovement, cameraModel.xPanSpeed, cameraModel.yPanSpeed, _currentPanPoint.allowPanBack );
			else
				panTo( cameraModel.defaultXOffset, cameraModel.defaultYOffset );
		}
		
		public function panTo( xOffset:Number, yOffset:Number, requireMovement:Boolean = true, xCameraSpeed:Number = -1, yCameraSpeed:Number = -1, allowPanBack:Boolean = true ):void
		{
			this.requireMovement = requireMovement;
			this.allowPanBack = allowPanBack;
			this.camXSpeed = xCameraSpeed;
			this.camYSpeed = yCameraSpeed;
			cameraModel.xOffset = xOffset;
			cameraModel.yOffset = yOffset;
		}
		
		public function setDefaultOffsets( xOffset:Number, yOffset:Number ):void
		{
			cameraModel.defaultXOffset = xOffset;
			cameraModel.defaultYOffset = yOffset;
		}
		
		public function _adjustPlayerPosition():void
		{
			this._playerModel.xPos = this._playerModel.currentPoint.x + this._foregroundModel.x;
			this._playerModel.yPos = this._playerModel.currentPoint.y + this._foregroundModel.y;
		}
		
		private function _panX( dt:Number ):void
		{
			var centerX:Number =  _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
			
			var leftBounds:Number = centerX - X_BUFFER;
			var rightBounds:Number = centerX + X_BUFFER;
			
			if( _foregroundModel.x < X_BUFFER )
			{
				var xSpeed:Number;
				var xDirection:int;
				
				if( this.requireMovement )
				{
					if( !_playerModel.allowCameraPan )
						return;
					if( _playerModel.xSpeed > 0 )
					{
						centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
						leftBounds = centerX - X_BUFFER;
						rightBounds = centerX + X_BUFFER;
					}
					else if( _playerModel.xSpeed < 0 && allowPanBack )
					{
						centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.defaultXOffset;
						leftBounds = centerX - X_BUFFER;
						rightBounds = centerX + X_BUFFER;	
					}
					else if( _playerModel.xSpeed < 0 )
					{
						centerX = _stage.stageWidth * X_STAGE_MULTIPLIER - cameraModel.xOffset;
						leftBounds = centerX - X_BUFFER;
						rightBounds = centerX + X_BUFFER;
					}
				}
								
				if( ( _playerModel.xPos < leftBounds || _playerModel.xPos > rightBounds ) )
				{
					cameraModel.xPanSpeed = Math.abs( _playerModel.xPos - centerX ) * 0.5;
					if( camXSpeed >= 0 )
					{
						xSpeed = camXSpeed;
					}
					else
						xSpeed = cameraModel.xPanSpeed;
					xDirection = ( _playerModel.xPos < centerX ) ? 1 : -1;
					_foregroundController.updateXPos( dt, -xSpeed * xDirection);
					_playerController.updateXPos( dt, xSpeed * xDirection );
				}
			}
		}
		
		private function _panY( dt:Number ):void
		{
			if( !_playerModel.allowCameraPan && this.requireMovement )
			{
				return;
			}
			var centerY:Number;
			var topBounds:Number;
			var bottomBounds:Number;
			if( _playerModel.xSpeed > 0 || !this.requireMovement )
			{
				centerY = _stage.stageHeight * Y_STAGE_MULTIPLIER - cameraModel.yOffset;
				topBounds = centerY - Y_BUFFER;
				bottomBounds = centerY + Y_BUFFER;
			}
			else if( _playerModel.xSpeed < 0 && this.allowPanBack )
			{
				centerY = _stage.stageHeight * Y_STAGE_MULTIPLIER - cameraModel.defaultYOffset;
				topBounds = centerY - Y_BUFFER;
				bottomBounds = centerY + Y_BUFFER;		
			}
			else if( _playerModel.xSpeed < 0 )
			{
				centerY = _stage.stageHeight * Y_STAGE_MULTIPLIER - cameraModel.yOffset;
				topBounds = centerY - Y_BUFFER;
				bottomBounds = centerY + Y_BUFFER;
			}
			if( ( _playerModel.yPos > bottomBounds || _playerModel.yPos < topBounds ) )
			{
				if( camYSpeed >= 0 )
					ySpeed = camYSpeed;
				else
				{
					cameraModel.yPanSpeed = Math.abs( _playerModel.yPos - centerY ) * 0.4;
					var ySpeed:Number = cameraModel.yPanSpeed;
				}
				var yDirection:int = _playerModel.yPos < centerY ? 1 : -1;
				_foregroundController.updateYPos( dt, -ySpeed * yDirection );
				_playerController.updateYPos( dt, ySpeed * yDirection );
			}
		}
		
				
		private function _checkForPanPoint():void
		{
			var playerXPos:Number = _playerModel.relativeXPos;
			var playerYPos:Number = _playerModel.relativeYPos;
			var panPoint:PanPoint;
			for( var i:int = 0; i < _foregroundModel.panPoints.length; i++ )
			{
				panPoint = _foregroundModel.panPoints[ i ];
				if( ( playerXPos > panPoint.x - X_PAN_DISTANCE && playerXPos < panPoint.x + X_PAN_DISTANCE ) && ( playerYPos <= panPoint.y + Y_PAN_DISTANCE && playerYPos >= panPoint.y - Y_PAN_DISTANCE ))
				{
					panToPanPoint( panPoint );
				}
			}
		}
		
		private function _updateXOffsets():void
		{
			var centerX:Number = _stage.stageWidth * X_STAGE_MULTIPLIER;
			_playerModel.xOffset = _playerModel.xPos - centerX;
		}
		
		private function _updateYOffsets():void
		{
			var centerY:Number = _stage.stageHeight * Y_STAGE_MULTIPLIER;
			_playerModel.yOffset = _playerModel.yPos - centerY;
		}		
	}
}
