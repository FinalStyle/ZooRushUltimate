package
{
	
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	
	public class Granade
	{
		public var model:MovieClip;
		public var explosion:MovieClip;
		public var speed:Number = 30;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var force:int=10;
		public var fallSpeed:Number = 1;
		public var grav:int = 1;
		
		public var timeToExplode:int=1000;
		public var currentTimeToExplode:Number=timeToExplode;
		
		//public var coldownToApplyForceOnPlayer:int = 3000;
		public var currentColdownToApplyForceOnPlayer:Number = 0;
		
		public var fallen:Boolean=false;
		
		public var thisparent:MovieClip
		public function Granade(posX:Number, posY:Number, parent:MovieClip, rotation:Number, scaleX:int)
		{
			model = Locator.assetsManager.getMovieClip("MCGranade");
			explosion = Locator.assetsManager.getMovieClip("MC_Explosion");
			parent.addChild(model);
			model.x=posX;
			model.y=posY;
			radians = rotation * Math.PI / 180;
			degrees = rotation;
			direction.x = Math.cos(radians);
			direction.y = Math.sin(radians);
			model.MC_botHitBox.alpha=0;
			model.MC_topHitBox.alpha=0;
			
			var lanzamientosound:Sound=Locator.assetsManager.getSound("bombalanzamiento")
			
			Main.instance.audioselection=new SoundController (lanzamientosound)
			Main.instance.audioselection.play(0);
		}
		public function fall():void
		{
			model.y+=fallSpeed;
			fallSpeed+=grav;
		}
		public function update():void
		{
			fall();
			model.x += direction.x * speed;
			if(!fallen)
			{
				model.y += direction.y * speed;
			}
			currentColdownToApplyForceOnPlayer-=1000/60;
			if(currentColdownToApplyForceOnPlayer<=0)
			{
				force=50;
			}
			else
			{
				force=0;
			}
			
		}
		public function destroy(parent:MovieClip):void
		{
			model.addChild(explosion);
			explosion.gotoAndPlay(0)
			model.addEventListener(Event.ENTER_FRAME, updateExplosion);
			parent.removeChild(model);
		}
		
		protected function updateExplosion(event:Event):void
		{
			
				
		}
		
	}
}