package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	
	public class Hero
	{
		public const ANIM_IDLE:String= "Idle";
		public const ANIM_RUN:String= "Run";
		public const ANIM_JUMPIDLE:String= "Jump_Idle";
		public const ANIM_JUMPSTART:String= "Jump_Start";
		public const ANIM_DMG:String= "Damage";
		public const ANIM_SHOTIDLE:String= "Shot_Idle"
		public const ANIM_SHOTANIM:String= "Shot_End";
		
		public var hp:int = 100;
		public var model:MovieClip;
		public var speed:int = 10;
		
		
		public var fallSpeed:int = 1;
		public var grav:int = 1;
		public var granadebool:Boolean;
		/** Necesito el nivel en el que estoy */ 
		public var currentlvl:MovieClip;
		//////////Teclas/////////
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;
		public var space:Boolean;
		public var atk1:Boolean;
		public var moviendoce:Boolean;
		public var doublePressingRightDown:Boolean;
		public var doublePressingRightUp:Boolean;
		/////////////////////////
		public var upKey:int;
		public var downKey:int;
		public var leftKey:int;
		public var rightKey:int;
		public var shootKey:int;
		public var atk1Key:int;
		public var isjumping:Boolean=false;
		public var runtrigger:Boolean;
		public var block:Boolean=false;
		public var blockeodeanimacion:Boolean=false;
		/////////////////////////
		/** Variable para controlar si puede moverse o no */
		public var canmove:Boolean = true;
		/** Variable para controlar si puede saltar o no */
		public var canJump:Boolean = true;
		public var JumpContador:int=0
		///////////////////////////Armas y ataques/////////////////////////////
		public var granades:Vector.<Granade> = new Vector.<Granade>();
		/** pointingArrow es una flecha que apunta hacia donde se lanza la granada */ 
		public var pointingArrow:pointArrow;
		/** Holding se utiliza para que la funcion del eventlistener de teclado no se repita cuando se mantiene apretado */
		public var holding:Boolean=false;
		public var damagecounter:int;
		public var framecontador:int=60;
		public var throwingGranade:Boolean;
		///////////////////////////////////////////////////////////////////////
		public var gotHitByGranade:Boolean=false;
		public var directionToFlyByGranade:Point = new Point;
		public var forceAppliedByGranade:int = 20;
		public var arrowbool:Boolean=false;
		
		public function Hero(up:int, down:int, right:int, left:int, shoot:int, atk1:int)
		{
			upKey=up;
			downKey=down;
			leftKey=left;
			rightKey=right;
			shootKey=shoot;
			atk1Key=atk1;
			
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)			
		}
		public function Update():void
		{
			if(!Main.instance.gameEnded)
			{
				framecontador++;
				if (block&&framecontador==damagecounter)
				{
					block=false;
					changeAnimation(ANIM_IDLE);
				}
				checkKeys();
				fall();
				for (var i:int = 0; i < granades.length; i++) 
				{
					granades[i].update();
				}
				uptdateGranadeCounters();
				if(gotHitByGranade)
				{				
					flyByGranadeHit(directionToFlyByGranade, forceAppliedByGranade);
					forceAppliedByGranade--;
					if(forceAppliedByGranade<=5)
					{
						gotHitByGranade=false;
						forceAppliedByGranade=20;
					}
				}
			}
		}
		public function fall():void
		{
			if(fallSpeed!=0)
			{
				model.y += fallSpeed;
				fallSpeed+=grav;
				
				
				
			}
			else
			{
				fallSpeed=5;
			}
			if(fallSpeed>10&&!block)
			{
				changeAnimation(ANIM_JUMPIDLE);			
				
			}
			
		}
		public function spawn(PosX:int, PosY:int, parent:MovieClip):void
		{
			parent.addChild(model);
			model.x=PosX;
			model.y=PosY;
			currentlvl = parent;
			model.MC_sideHitBox.alpha=0;
			model.MC_botHitBox.alpha=0;
			model.MC_HitBox.alpha=0;
			model.MC_topHitBox.alpha=0;
			model.mc_forceApply.alpha=0;
		}
		public function move(direction:int):void
		{
			if(canmove)
			{
				
				if(!isjumping)
				{
					changeAnimation(ANIM_RUN);
				}
				model.x+=speed*direction;
				moviendoce=true;
				
			}
			model.scaleX=1*direction;
			canmove=true;
			runtrigger=isjumping;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////Granade and Arrow Functions///////////////////////////////////////////////
		public function throwGranade():void
		{
			
			var granade:Granade;
			granade = new Granade(model.x, model.y-10, currentlvl, pointingArrow.model.rotation, model.scaleX)
			granades.push(granade);
			throwingGranade=false;
			
		}
		public function arrowForThrowingGranade():void
		{
			pointingArrow = new pointArrow(model.x+10, model.y-model.height/2, currentlvl,model.scaleX);
			currentlvl.addEventListener(Event.ENTER_FRAME, updateArrowForThrowingGranade);
			arrowbool=true;
			changeAnimation(ANIM_SHOTIDLE);
			model.addEventListener("evento unlock", evdesblockeo)
			
			
			
		}		
		
		protected function evdesblockeo(event:Event):void
		{
			throwGranade();
			blockeodeanimacion=false;
		}
		public function deleteArrowForThrowingGranade():void
		{
			currentlvl.removeEventListener(Event.ENTER_FRAME, updateArrowForThrowingGranade);
			pointingArrow.destroy(currentlvl)
			arrowbool=false;
		}
		protected function updateArrowForThrowingGranade(event:Event):void
		{
			pointingArrow.update(model.x+10*model.scaleX, model.y-model.height/2);
		}
		public function uptdateGranadeCounters():void
		{
			
			for (var i:int = granades.length-1; i >= 0; i--) 
			{
				granades[i].currentTimeToExplode-=1000/60;
				if(granades[i].canDelete)
				{
					granades.splice(i,1)
				}
				else if (granades[i].currentTimeToExplode<=0 && !granades[i].exploded) 
				{
					trace("entro")
					granades[i].explode();
				}
			}
		}
		public function flyByGranadeHit(direction:Point, force:int):void
		{
			block=true;
			model.x += direction.x * force;
			model.y += direction.y * force;
			changeAnimation(ANIM_DMG);
			damagecounter=framecontador;
			damagecounter+=10
			if (!granadebool&&arrowbool==true)
			{
				granadebool==true
				deleteArrowForThrowingGranade();
				throwingGranade=false;
				holding=false;
			}
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		public function destroy():void
		{
			for (var i:int = granades.length-1; i >=0; i--) 
			{
				granades[i].destroy(currentlvl)
				granades.splice(i, 1);
			}
			if(arrowbool)
			{
				pointingArrow.destroy(currentlvl);
			}
			currentlvl.removeChild(model);	
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp)		
		}
		
		public function pause (numero:int):void
		{
			if (numero<0)
			{
				Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown)
				Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp)	
			}
				
			else
			{
				Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
				Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)	
			}
		}
		
		public function checkKeys():void
		{
			if (!block)
			{
				
				if(!throwingGranade)
				{
					
					
					if (up&&canJump&&JumpContador<2) 
					{
						fallSpeed=-18;
						canJump = false;
						JumpContador++;
						if(JumpContador==0)
						{
							changeAnimation(ANIM_JUMPSTART);
						}
						if(JumpContador==1)
						{
							changeAnimation(ANIM_JUMPIDLE);
						}
						isjumping=true;
						Main.instance.audioselection = new SoundController(Main.instance.jumpsound);
						
						Main.instance.audioselection.play(0);
						Main.instance.audioselection.volume=0.1;
					}
					if (down&&canmove) 
					{
						framecontador=0;
					}
					if (left) 
					{
						move(-1)
					}
					if (right) 
					{
						move(1)
					}
				}
				else
				{
					if(up && right)
					{
						pointingArrow.model.rotation=-45;
					}
					else if(right && down)
					{
						pointingArrow.model.rotation=45;
					}
					else if(left && up)
					{
						pointingArrow.model.rotation=-135;
					}
					else if(left && down)
					{
						pointingArrow.model.rotation=135;
					}
					else
					{
						if(up)
						{
							pointingArrow.model.rotation=-90;
						}
						if(down) 
						{
							pointingArrow.model.rotation=90;
						}
						if(left) 
						{
							pointingArrow.model.rotation=180;
						}
						if(right) 
						{
							pointingArrow.model.rotation=0;
						}
					}
				}
			}
			
		}
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case upKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					up=true;
					break;
				}
				case downKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					down=true;
					break;
				}
				case leftKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					left=true;
					break;
				}
				case rightKey:
				{
					doublePressingRightDown=false;
					doublePressingRightUp=false;
					right=true;
					break;
				}
				case atk1Key:
				{
					if(!holding&&Main.instance.pauseboolean==false&&!block)
					{
						holding=true;
						arrowForThrowingGranade();
						throwingGranade=true;
					}
					else if (!granadebool&&Main.instance.pauseboolean==false&&!block)
					{
						granadebool=true
						blockeodeanimacion=true;
						changeAnimation(ANIM_SHOTANIM);
						
						deleteArrowForThrowingGranade();
						holding=false;
						
					}
					break;
				}
			}
		}
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case upKey:
				{
					up=false;
					canJump=true;
					break;
				}
				case downKey:
				{
					down=false;
					break;
				}
				case leftKey:
				{
					left=false;
					moviendoce=false;
					if (!isjumping && !Main.instance.gameEnded&&blockeodeanimacion)
					{
						changeAnimation(ANIM_IDLE);
					}
					break;
				}
				case rightKey:
				{
					right=false;
					moviendoce=false;
					if (!isjumping && !Main.instance.gameEnded&&blockeodeanimacion)
					{
						changeAnimation(ANIM_IDLE);
					}
					break;
				}
					
				case atk1Key:
				{
					
					granadebool= false;
					break;
					
				}
			}
		}
		public function changeAnimation(name:String):void
		{
			if(model.currentLabel!=name)
			{
				model.gotoAndPlay(name)
			}
		}
	}
}