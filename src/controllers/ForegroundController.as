package controllers {
	import core.Arrays;

	import models.ActionPoint;
	import models.AnimationPoint;
	import models.BeachForeground;
	import models.BranchPoint;
	import models.CaveExitForeground;
	import models.Directions;
	import models.ForegroundModel;
	import models.JumpPoint;
	import models.PanPoint;
	import models.StageOneForeground;
	import models.StageThreeForeground;
	import models.StageTwoForeground;

	import org.osflash.signals.Signal;

	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class ForegroundController 
	{
		
		private static const Y_DISTANCE_ACCEPT_BRANCH:Number = 75;
						
		public var foregroundModel:ForegroundModel;
		
		public function set currentStage( s:int ):void
		{
			foregroundModel = null;
			if( s == 1 )
				foregroundModel = new StageOneForeground();
			else if( s == 2 )
				foregroundModel = new StageTwoForeground();
			else if( s == 3 )
				foregroundModel = new StageThreeForeground();
			else if( s == 5 )
				foregroundModel = new CaveExitForeground();
			else if( s == 7 )
				foregroundModel = new BeachForeground();
		}
		
		public function ForegroundController()
		{
		}
		
		public function destroy():void
		{
			if( this.foregroundModel )
				this.foregroundModel.destroy();
			this.foregroundModel = null;
			
		}
		
		public function updateXPos( dt:Number, speed:Number ):void
		{
			foregroundModel.x -= speed * dt;
		}
		
		public function updateYPos( dt:Number, speed:Number ):void
		{
			foregroundModel.y -= speed * dt;
		}
		
		public function objectTagged( name:String ):void
		{
			foregroundModel.taggedObjects.push( name );
			foregroundModel.completedActions.push( name );
			_enablePointsFor( name );
			_checkEnableBranchPoint();
		}
		
		public function actionCompleted( name:String ):void
		{
			foregroundModel.completedActions.push( name );
			_checkEnableBranchPoint();
		}
		
		public function getAppropriatePoint( x:Number, y:Number ):Point
		{
			var closestPoint:Point;
			var xDiff:Number;
			var smallestXDiff:Number = Number.MAX_VALUE;
			foregroundModel.points.forEach( function( point:Point, i:int, a:Array ):void
			{
				xDiff = Math.abs( point.x - x );
				if( xDiff < smallestXDiff )
				{
					smallestXDiff = xDiff;
					closestPoint = point;
				}
			} );
			return closestPoint;
		}
		
		public function getPath( startPoint:Point, endPoint:Point ):Array
		{
			if( endPoint.x <= foregroundModel.actionPoints[ 0 ].x )
			{
				return [];
			}
			if( foregroundModel.branchPoint )
			{
				if( startPoint.x < foregroundModel.branchPoint.x )
					foregroundModel.branchPoint = null;
			}
			
			
			var endX:Number = endPoint.x;
			var startX:Number = startPoint.x;
			var right:Boolean = endX - startX > 0;
			var requiredPoints:Array = [];
			var lastReqPoint:*;
			var i:int;
			if( right )
			{
				if( foregroundModel.branchPoint && foregroundModel.branchPoint.enabled )
				{
					foregroundModel.branchPoint.points.forEach( function( point:Point, i:int, a:Array ):void
					{
						if( startX <= point.x && endX >= point.x )
						{
							requiredPoints.push( point );
							lastReqPoint = point;
						}
					});
					return requiredPoints;
				}
				else
				{
					for( i = 0; i < foregroundModel.actionPoints.length; i++ )
					{	
						var point:* = foregroundModel.actionPoints[ i ];
						if( startX <= point.x && endX >= point.x )
						{
							if( point is BranchPoint && point.enabled )
							{
								requiredPoints.push( point );
								if( ( point as BranchPoint ).forcePath || ( point.pathDirection == Directions.DOWN && endPoint.y > point.points[ 0 ].y - Y_DISTANCE_ACCEPT_BRANCH ) || 
									( point.pathDirection == Directions.UP && endPoint.y < point.points[ 0 ].y - Y_DISTANCE_ACCEPT_BRANCH ) )
								{
									point.points.forEach( function( point:Point, i:int, a:Array ):void
									{
										if( startX <= point.x && endX >= point.x )
										{
											requiredPoints.push( point );
											lastReqPoint = point;
										}
									});
									foregroundModel.branchPoint = point;
									return requiredPoints;
								}
								else
									continue;
							}
							else
							{
								requiredPoints.push( point );
								lastReqPoint = point;
							}
						}
					}
				}
			}
			
			// The left direction one needs to search the array backwards
			else
			{
				if( foregroundModel.branchPoint )
				{
					for( i = foregroundModel.branchPoint.points.length - 1; i >= 0; i-- )
					{
						point = foregroundModel.branchPoint.points[ i ];
						if( startX >= point.x && endX <= point.x )
						{
							requiredPoints.push( point );
							lastReqPoint = point;
						}
					}
					if( foregroundModel.branchPoint.x < endX )
						return requiredPoints;
					// Set the start x to the last added point in the branch
					// Otherwise the regular points will add points starting from the player's original position
					else
					{
						startX = foregroundModel.branchPoint.x;
					}
				}
				for( i = foregroundModel.actionPoints.length - 1; i >= 0; i-- )
				{
					point = foregroundModel.actionPoints[ i ];
					if( startX >= point.x && endX <= point.x )
					{
						requiredPoints.push( point );
						lastReqPoint = point;
					}
				}
			}
			
			// Make sure the end point x Pos is greater than this first action point
			// Check the last action point to see if it was a jump and stop if it is.
			// If the last req point doesnt exist go ahead and find an appropriate point
			if( endPoint is AnimationPoint )
			{
				requiredPoints.push( endPoint )
			}
			else if( !( lastReqPoint is JumpPoint ) )
			{
				requiredPoints.push( getAppropriatePoint( endPoint.x, endPoint.y ) );
			}
			return requiredPoints;
		}
		
		public function branchPointReached( direction:int ):void
		{
			if( foregroundModel.branchPoint && direction == Directions.LEFT )
			{
				foregroundModel.branchPoint.attemptToDisable();
				foregroundModel.branchPoint = null;
			}
		}
		
		public function areObjectsTagged( objects:Array ):Boolean
		{
			return Arrays.contains( this.foregroundModel.taggedObjects, objects );
		}
		
		public function areActionsComplete( actions:Array ):Boolean
		{
			return Arrays.contains( this.foregroundModel.completedActions, actions );
		}
		
		private function _checkEnableBranchPoint():void
		{
			var point:*;
			var numReqActions:int;
			var numCorrectActions:int;
			for( var i:int = 0; i < foregroundModel.actionPoints.length; i++ )
			{
				point = foregroundModel.actionPoints[ i ];
				if( point is BranchPoint && point.requiredActions )
				{
					numReqActions = point.requiredActions.length;
					numCorrectActions = 0;
					
					for( var j:int = 0; j < point.requiredActions.length; j++ )
					{
						for( var k:int = 0; k < foregroundModel.completedActions.length; k++ )
						{
							if( point.requiredActions[ j ] == foregroundModel.completedActions[ k ] )
								numCorrectActions++;
						}
					}
					if( numCorrectActions >= numReqActions )
						( point as BranchPoint ).allowDisable = true;
				}
			}
		}
		
		private function _enablePointsFor( name:String ):void
		{
			this.foregroundModel.actionPoints.forEach( function( point:*, i:int, a:Array ):void
			{
				if( point is ActionPoint && point.requiredTag )
				{
					if( point.requiredTag == name )
					{
						point.enable();
					}
				}
			});
		}
	}
}
