package models {
	import org.osflash.signals.Signal;

	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class ForegroundModel
	{
		public var onPosChanged:Signal = new Signal();
	   
		// Points where something can happen
		protected var _actionPoints:Array;
		public function get actionPoints():Array { return _actionPoints; }
		public function set actionPoints( a:Array ):void { _actionPoints = a; }
		
		// Points where player can move
		protected var _points:Array = [];
		public function get points():Array { return _points; }
		public function set points( p:Array ):void { this._points = p; }
		
		// Points where the camera should start to pan
		public var panPoints:Array = [];
		
		public var soundPoints:Array = [];
		public var soundRects:Array = [];
		
		public var tutorialPoints:Array;
				
		public var taggedObjects:Array = [];
		
		public var branchPoint:BranchPoint;
		
		public var completedActions:Array = [];
		
		public var width:Number = 0;
		
		public function get numObjectsTagged():int { return this.taggedObjects.length; }
		
		private var _x:Number = 0;
		public function get x():Number { return _x; }
		public function set x( x:Number):void { _x = x; onPosChanged.dispatch(); }
		
		public var relativeYPos:Number = 0;
		
		private var _y:Number = 0;
		public function get y():Number { return _y; }
		public function set y( y:Number):void { _y = y; onPosChanged.dispatch(); }
		
		public var _yOffset:Number = 0;
		public function set yOffset( y:Number ):void{ if( _yOffset == y ) return; _yOffset = y; onPosChanged.dispatch(); }
		public function get yOffset():Number{ return _yOffset; }
		public var _xOffset:Number = 0;
		public function set xOffset( x:Number ):void{ if( _xOffset == x ) return; _xOffset = x; onPosChanged.dispatch(); }
		public function get xOffset():Number{ return _xOffset; }
		
		public function ForegroundModel( actionPoints:Array )
		{
			this.actionPoints = actionPoints;
			this._createPath();
		}
		
		public function destroy():void
		{
			this.onPosChanged.removeAll();
			this.onPosChanged = null;
			
			panPoints = null;
			soundPoints = null;
			soundRects = null;
			tutorialPoints = null;
			taggedObjects = null;
			branchPoint = null;
			completedActions = null;
		}
		
		// Allows the branch point to be disabled the next time the player exits it
		public function disableNextBranchPoint():void
		{
			for( var i:int = 0; i < this.actionPoints.length; i++ )
			{
				if( actionPoints[ i ] is BranchPoint && actionPoints[ i ].enabled )
				{
					( actionPoints[ i ] as BranchPoint).allowDisable = true;
					// break or else this will disable the others as well
					break;
				}
			}
		}
		
		public function enableNextBranchPoint():void
		{
			for( var i:int = 0; i < this.actionPoints.length; i++ )
			{
				if( actionPoints[ i ] is BranchPoint && !actionPoints[ i ].enabled )
				{
					( actionPoints[ i ] as BranchPoint).enabled = true;
					( actionPoints[ i ] as BranchPoint).allowDisable = true;
					// break or else this will disable the others as well
					break;
				}
			}
		}
		
		protected function _createPath():void
		{
			var lastPoint:Point = actionPoints[ 0 ];
			var deltaX:Number;
			var deltaY:Number;
			var numPoints:Number;
			for( var i:int = 1; i < actionPoints.length; i++ )
			{
				deltaX = actionPoints[ i ].x - lastPoint.x;
				deltaY = actionPoints[ i ].y - lastPoint.y;
				numPoints = Math.max( Math.abs( deltaX ), Math.abs( deltaY ) ) / 4;
				for( var j:int = 0; j < numPoints; j++ )
				{
					points.push( new Point( lastPoint.x + deltaX * ( j / numPoints ), lastPoint.y + deltaY * ( j / numPoints ) ) );
				}
				lastPoint = actionPoints[ i ];
			}
		}
	}
}
