package views {
	import core.SpriteManager;

	import models.PulseModel;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class PostForegroundTwo extends PostForeground 
	{
		public static const SPRING_BOARD_ROCK:String = 'springBoardRock';
		public static const POST_TREE:String = 'postTree';
		public static const SPRING_BOARD:String = 'springBoard';
		public static const TREE_FALL:String = 'treeBreak';
		public static const ROCK:String = 'rock';
		public static const CONTROL_BOX:String ='postControlBox';
		public static const ROCK_BLOCK:String = 'rockBlock';
		
		public var onRockClicked:Signal = new Signal();
		public var onSpringBoardClicked:Signal = new Signal();
		public var onTreeBreakClicked:Signal = new Signal();
		public var onTreeBreakComplete:Signal = new Signal();
		public var onControlBoxClicked:Signal = new Signal();
		public var onOpenGate:Signal = new Signal();

		private var rock:Sprite;
		private var treeBreak:TreeBreak;
		private var springBoardRock:Sprite;
		private var springBoard:Sprite;
		private var postTree:Sprite;
		private var controlBox:MovieClip;
		private var controlBoxAnimation:PostControlBox;

		public function PostForegroundTwo( foreground:Sprite, pulseModel:PulseModel ) 
		{
			treeBreak = new TreeBreak( 
				foreground.removeChild( foreground.getChildByName( TREE_FALL ) ) as MovieClip				
			);
			springBoard = foreground.getChildByName( SPRING_BOARD ) as Sprite;
			springBoardRock = foreground.removeChild( foreground.getChildByName( SPRING_BOARD_ROCK ) ) as Sprite;
			rock = foreground.getChildByName( ROCK ) as Sprite;
			postTree = foreground.getChildByName( POST_TREE ) as Sprite;
			super( foreground, [ ROCK, SPRING_BOARD, POST_TREE, CONTROL_BOX, ROCK_BLOCK ], pulseModel );
			controlBox = foreground.removeChild( foreground.getChildByName( CONTROL_BOX ) ) as MovieClip;
			
			controlBoxAnimation = new PostControlBox( controlBox );
			controlBoxAnimation.mouseChildren = true;
			controlBoxAnimation.buttonMode = true;	
			
			this.foreground.addChild( controlBoxAnimation );
			this._addListeners();
		}
		
		private function _addListeners():void
		{
			controlBoxAnimation.addEventListener( MouseEvent.MOUSE_DOWN, _onControlBoxClicked );
			controlBoxAnimation.onFunctional.addOnce( this.onOpenGate.dispatch );
		}
		
		private function _removeListeners():void
		{
			controlBoxAnimation.removeEventListener( MouseEvent.MOUSE_DOWN, _onControlBoxClicked );
			controlBoxAnimation.onFunctional.remove( this.onOpenGate.dispatch );
		}
		
		override public function destroy():void
		{
			super.destroy();
			treeBreak.destroy();
			controlBoxAnimation.destroy();
			
			
			this._removeListeners();
			
			onRockClicked.removeAll();
			onSpringBoardClicked.removeAll();
			onTreeBreakClicked.removeAll();
			onTreeBreakComplete.removeAll();
			onControlBoxClicked.removeAll();
			onOpenGate.removeAll();
			
			onRockClicked = null;
			onSpringBoardClicked = null;
			onTreeBreakClicked = null;
			onTreeBreakComplete = null;
			onControlBoxClicked = null;
			onOpenGate = null;
			
			rock = null;
			treeBreak = null;
			springBoard = null;
			springBoardRock = null;
			postTree = null;
			controlBox = null;
			controlBoxAnimation = null;
		}
		
		public function enableTreeBreak():void
		{
			this.treeBreak.mouseEnabled = true;
		}
		
		public function disableTreeBreak():void
		{
			this.treeBreak.mouseEnabled = false;
		}
		
		public function replaceTreeBreak():void
		{
			foreground.addChild( treeBreak );
			if( foreground.contains( springBoardRock ) )
				foreground.removeChild( springBoardRock );
			foreground.removeChild( springBoard );
			foreground.removeChild( postTree );
			treeBreak.mouseChildren = false;
			treeBreak.mouseEnabled = false;
			treeBreak.buttonMode = true;
			treeBreak.addEventListener( MouseEvent.MOUSE_DOWN, _treeBreakClicked );
		}
		
		public function enableSpringBoard():void
		{
			springBoard.addEventListener( MouseEvent.MOUSE_DOWN, _onSpringBoardClicked );
			this.springBoard.mouseEnabled = true;
		}
		
		public function disableSpringBoard():void
		{
			this.springBoard.mouseEnabled = false;
		}
		
		public function enableRockPickUp():void
		{
			SpriteManager.enableMouse( rock );
			rock.addEventListener( MouseEvent.MOUSE_DOWN, _onRockClicked );
		}
		
		public function enableCogPlacement():void
		{
			this.controlBoxAnimation.mouseChildren = false;
			controlBoxAnimation.buttonMode = true;
			controlBoxAnimation.mouseEnabled = true;
		}
		
		public function disableCogPlacement():void
		{
			this.controlBoxAnimation.mouseChildren = false;
			this.controlBoxAnimation.mouseEnabled = false;
		}
		
		public function addCogToControlBox():void
		{
			controlBoxAnimation.addNextCog();
			disableCogPlacement();
		}
		
		public function removeRock():void
		{
			if( foreground.contains( rock ) )
			{
				rock.removeEventListener( MouseEvent.MOUSE_DOWN, _onRockClicked );
				SpriteManager.disableMouse( rock );
				foreground.removeChild( rock );
			}
		}
		
		public function placeRock():void
		{
			this.foreground.addChild( this.springBoardRock );
			SpriteManager.disableMouse( springBoard );
			springBoard.removeEventListener( MouseEvent.MOUSE_DOWN, _onSpringBoardClicked );
		}
		
		public function playTreeBreak():void
		{
			this.clearMask();
			var rect:Rectangle = treeBreak.getBounds( this );
			this.foregroundMask.graphics.beginFill( 0 );
			this.foregroundMask.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			this.treeBreak.onComplete.addOnce( this.onTreeBreakComplete.dispatch );
			SpriteManager.disableMouse( treeBreak );
			this.treeBreak.play();
			this.treeBreak.mouseEnabled = false;
			this.treeBreak.buttonMode = false;
		}
		
		public function removeStuckCog():void
		{
			controlBoxAnimation.startFirstCog();
		}
		
		private function _onSpringBoardClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onSpringBoardClicked.dispatch();
		}
		
		private function _onRockClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			onRockClicked.dispatch();
		}
		
		private function _treeBreakClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onTreeBreakClicked.dispatch();
		}
		
		private function _onControlBoxClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onControlBoxClicked.dispatch();
		}
	}
}