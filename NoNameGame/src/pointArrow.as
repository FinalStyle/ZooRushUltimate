package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class pointArrow
	{
		public var model:MovieClip;
		public var speed:int = 2;
		public var direction:int = 1;
		
		public function pointArrow(posX:int, posY:int, parent:MovieClip, scaleX:int)
		{
			model = Locator.assetsManager.getMovieClip("MCArrow");
			model.x = posX;
			model.y = posY;
			parent.addChild(model);
			if(scaleX>0)
			{
				model.rotation=0;
			}
			else
			{
				model.rotation=	180;
			}
		}
		public function update(posX:int, posY:int):void
		{			
			model.x = posX;
			model.y = posY;
		}
		public function destroy(parent:MovieClip):void
		{
			parent.removeChild(model)
		}
	}
}