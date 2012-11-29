package views
{
	/**
	 * @author Adam
	 */
	public interface IScreen 
	{
		/**
		 * Update logic for this game scene.
		 */
		function update( dt:Number ):void;
		/**
		 * Load all of the data and graphics that this scene needs to function.
		 */
		function load( controller:* ):void;
		/**
		 * Unload everything that the garbage collector won't unload itself, including graphics.
		 */
		function unload():void;
	}
}
