package views {
	import models.Items;
	import models.JumpAnimationModel;
	import models.PlayerModel;
	/**
	 * @author Adam
	 */
	public class PlayerAnimations
	{
		public static const CITY_GAZE:String = "CityGaze";
		public static const JUMP_UP:String = "JumpUp";
		public static const SIDE_JUMP:String = "SideJump";
		public static const JUMP_DOWN_SMALL:String = 'JumpDownSmall';
		public static const JUMP_DOWN_LARGE:String = 'JumpDownLarge';
		public static const PULSE:String = 'Pulse';
		public static const PICK_COG_UP:String = 'PickCogUp';
		public static const PICK_ROCK_UP:String = 'PickRockUp';
		public static const PICK_VALVE_UP:String = 'PickValveUp';
		public static const NORMAL_WALK:String ='NormalWalk';
		public static const NORMAL_STAND:String = 'NormalStand';
		public static const CARRY_ROCK_STAND:String = 'CarryRockStand';
		public static const CARRY_COG_STAND:String = 'CarryCogStand';
		public static const CARRY_VALVE_STAND:String = 'CarryValveStand';
		public static const CARRY_ROCK_WALK:String = 'CarryRockWalk';
		public static const CARRY_COG_WALK:String = 'CarryCogWalk';
		public static const CARRY_VALVE_WALK:String = 'CarryValveWalk';
		public static const PUT_DOWN:String = 'PutDown';
		public static const SLOW_TO_REST:String = 'Slow To Rest';
		public static const PLACE_COG:String = 'PlaceCog';
		public static const BUTTON_PRESS:String = 'buttonPress';
		public static const RUNNING:String = 'running';

		public static var playerModel:PlayerModel;

		public static function get WALKING():String
		{
			if( !playerModel )
				return NORMAL_WALK;
			if( playerModel.item == Items.NO_ITEM )
				return NORMAL_WALK;
			if( playerModel.item == Items.COG )
				return CARRY_COG_WALK;
			else if( playerModel.item == Items.VALVE )
				return CARRY_VALVE_WALK;
			else if( playerModel.item == Items.ROCK )
				return CARRY_ROCK_WALK;
			else
				return NORMAL_WALK;
		}
		
		public static function get STANDING():String
		{
			if( !playerModel )
				return NORMAL_STAND;
			if( playerModel.allowCityGaze )
				return CITY_GAZE;
			if( playerModel.item == Items.NO_ITEM )
				return NORMAL_STAND;
			if( playerModel.item == Items.COG )
				return CARRY_COG_STAND;
			else if( playerModel.item == Items.VALVE )
				return CARRY_VALVE_STAND;
			else if( playerModel.item == Items.ROCK )
				return CARRY_ROCK_STAND;
			return NORMAL_STAND;
		}
		
		public static function get PICK_UP():String
		{
			if( !playerModel || playerModel.item == Items.ROCK || playerModel.item == Items.NO_ITEM )
				return PICK_ROCK_UP;
			else if (playerModel.item == Items.COG )
				return PICK_COG_UP;
			else if( playerModel.item == Items.VALVE )
				return PICK_VALVE_UP;
			return PICK_ROCK_UP;
		}
		
		private static var animations:Object = {};
		
		/**
		 * Create the proper animated and return it.
		 */
		public static function getAnimation( type:String ):*
		{
			if( !animations[ type ] )
			{
				var animation:Animation;
				switch( type )
				{
					case CITY_GAZE:
						animation = new CityGaze( type );
						break;
					case NORMAL_STAND:
						animation = new Standing( type );
						break;
					case JUMP_UP:
						animation = new JumpUp( type );
						break;
					case NORMAL_WALK:
						animation = new Walking( type );
						break;
					case SIDE_JUMP:
						animation = new SideJump( type );
						break;
					case JUMP_DOWN_SMALL:
						animation = new JumpDownSmall( type );
						break;
					case PULSE:
						animation = new PulseAnimation( type );
						break;
					case JUMP_DOWN_LARGE:
						animation = new JumpDownLarge( type );
						break;
					case CARRY_ROCK_STAND:
						animation = new CarryRockStand( type );
						break;
					case CARRY_VALVE_STAND:
						animation = new CarryValveStand( type );
						break;
					case CARRY_COG_STAND:
						animation = new CarryCogStand( type );
						break;
					case CARRY_ROCK_WALK:
						animation = new CarryRockWalk( type );
						break;
					case CARRY_COG_WALK:
						animation = new CarryCogWalk( type );
						break;
					case CARRY_VALVE_WALK:
						animation = new CarryValveWalk( type );
						break;
					case PICK_ROCK_UP:
						animation = new PickRockUp( type );
						break;
					case PICK_COG_UP:
						animation = new PickCogUp( type );
						break;
					case PICK_VALVE_UP:
						animation = new PickValveUp( type );
						break;
					case PUT_DOWN:
						animation = new PutDown( type );
						break;
					case PLACE_COG:
						animation = new PlaceCog( type );
						break;
					case SLOW_TO_REST:
						animation = new SlowDownAnimation( type );
						break;
					case BUTTON_PRESS:
						animation = new ButtonPress( type );
						break;
					case RUNNING:
						animation = new Running( type );
						break;
				}
				if( animation )
					animations[ type ] = animation;
			}
			return animations[ type ];
		}
		
		public static function getModel( type:String ):JumpAnimationModel
		{
			return getAnimation( type ).model;
		}
		
	}
}
