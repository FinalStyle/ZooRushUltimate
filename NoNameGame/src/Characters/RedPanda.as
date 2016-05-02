package Characters
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class RedPanda extends Hero
	{
		public function RedPanda(up:int, down:int, right:int, left:int, shoot:int, atk1:int)
		{
			super(up, down, right, left, shoot, atk1)
			model = Locator.assetsManager.getMovieClip("MCPlayer");
				
			
		}
		
	}
}