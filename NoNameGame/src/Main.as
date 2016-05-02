package
{
	import Characters.RedPanda;
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	
	[SWF(height="720", width="1280", frameRate="60")]
	public class Main extends Locator
	{
		public static var instance:Main;
		
		public var level:MovieClip;
		public var gamestarted:Boolean=false;
		public var gameEnded:Boolean = false;
		
		public var allPlatformsOfLevel1:Array;
		public var allWallsOfLevel1:Array;
		public var deadline:MovieClip;
		

		public var allPlayers:Vector.<Hero>;
		public var playersCount:int;
		//////////////////////////////////////CameraSet////////////////////////////////////////////
		public var camLookAt:MovieClip;
		public var mid2Players:Point;
		public var playersGlobalPositions:Vector.<Point>;
		public var playersLocalPositions:Vector.<Point>;
		public var playersGlobalPositionNearestToEdges:Vector.<Point>;
		public var playersLocalPositionNearestToEdges:Vector.<Point>;
		public var canZoomIn:Boolean=true;
		public var canZoomOut:Boolean=true;
		public var cam:Camera;
		public var sideLimitsX:Number;
		public var pause:Pause=new Pause;
		public var pauseboolean:Boolean=false;
		public var stop:Boolean=false;
		public var fixCamera:Boolean;
		public var fixCameraTimer:Number;
		/////////////////////////////////////////Menu//////////////////////////////////////////////////
		public var w:Boolean;
		public var s:Boolean;
		public var menu1:MovieClip;
		public var menu2:MovieClip;
		public var creditos:MovieClip;
		/////////////////////////////////////////Audio//////////////////////////////////////////////////
		public var audio:SoundController;
		public var audioselection:SoundController;
		public var audiovictory:SoundController;
		public var selectionsound:Sound;
		public var backsound:Sound;
		public var aceptarsounds:Sound;
		public var jumpsound:Sound;
		public var bool:Boolean;
		
		
		
		
		
		public function Main()
		{
			mainStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			mainStage.scaleMode = StageScaleMode.EXACT_FIT;
			instance = this;
			
			mainfunction();
			
		}
		
		public function mainfunction():void
			
		{
			Locator.assetsManager.loadLinks("linksleveltry.txt");
			Locator.assetsManager.addEventListener(Event.COMPLETE, evMainMenu);
		}
		
		public function evMainMenu(event:Event):void
		{
			gamestarted=false;
			selectionsound=Locator.assetsManager.getSound("soundchangeselection");
			backsound=Locator.assetsManager.getSound("soundselectionatras");
			aceptarsounds=Locator.assetsManager.getSound("soundselectionaceptar");
			jumpsound=Locator.assetsManager.getSound("jumpsound");
			menu1=Locator.assetsManager.getMovieClip("MC_Menu1");
			menu2=Locator.assetsManager.getMovieClip("MC_Menu2");
			creditos=Locator.assetsManager.getMovieClip("MC_Creditos");
			menu1.scaleX=0.5;
			menu1.scaleY=0.5;
			menu2.scaleX=0.5;
			menu2.scaleY=0.5;
			Locator.mainStage.addChild(menu1)
			menu1.MC_creditos.alpha=0
			w=true;
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			
			
		}
		
		
		
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.W:
				{
					if (Locator.mainStage.contains(menu1))
					{
						menu1.MC_jugar.alpha=1;
						menu1.MC_creditos.alpha=0;
						
						audioselection = new SoundController(selectionsound);
						audioselection.play(0);
						audioselection.volume=0.3;
					}
					else if (Locator.mainStage.contains(menu2))
					{
						menu2.MC_level2.alpha=0;
						menu2.MC_level1.alpha=1;
						
						audioselection = new SoundController(selectionsound);
						audioselection.play(0);
						audioselection.volume=0.3;
					}
					w=true;
					s=false;
					break;
				}
				case Keyboard.S:
				{
					if (Locator.mainStage.contains(menu1))
					{
						menu1.MC_jugar.alpha=0;
						menu1.MC_creditos.alpha=1;
						
						audioselection = new SoundController(selectionsound);
						audioselection.play(0);
						audioselection.volume=0.3;
					}
					else if (Locator.mainStage.contains(menu2))
					{
						menu2.MC_level1.alpha=0;
						menu2.MC_level2.alpha=1;
						
						audioselection = new SoundController(selectionsound);
						audioselection.play(0);
						audioselection.volume=0.3;
					}
					s=true;
					w=false;
					break;
				}
				case Keyboard.P:
				{
					if (gamestarted)
					{
						if (!pauseboolean)
						{
							pause.pauseon(stage.stageWidth/2, stage.stageHeight/2);
							
						}
						else if (pauseboolean)
						{
							pause.pausedoff();
						}
					}
					break;
				}
				case Keyboard.ENTER:
				{
					if (w==true&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1);
						Locator.mainStage.addChild(menu2);
						menu2.MC_level1.alpha=1;
						menu2.MC_level2.alpha=0;
						w=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
						
						
					}
					else if (w==false&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1);
						Locator.mainStage.addChild(creditos);
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
					}
					else if (Locator.mainStage.contains(creditos))
					{
						Locator.mainStage.removeChild(creditos);
						Locator.mainStage.addChild(menu1);
						menu1.MC_jugar.alpha=1;
						menu1.MC_creditos.alpha=0;
						w=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
					}
					else if (w==false&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel2", 4);
						gamestarted=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
						
					}
					else if (w==true&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel1", 2);
						gamestarted=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
					}
					
				}
			}
			
		}
		public function evStartGame(level:String, playersCountForGame:int):void
		{
			playersCount = playersCountForGame;
			var player:Hero;
			var song:Sound=	Locator.assetsManager.getSound("song1");
			audio = new SoundController(song);
			audio.play(11)
			audio.volume=0.2;
			pause.getlevel(level);
			allPlatformsOfLevel1 = new Array();
			allWallsOfLevel1= new Array();
			
			allPlayers= new Vector.<Hero>;
			
			//////////////////////////////////////CameraSet////////////////////////////////////////////
			mid2Players = new Point(0, 0);
			playersGlobalPositions = new Vector.<Point>;
			playersLocalPositions = new Vector.<Point>;
			
			sideLimitsX=100;
			///////////////////////////////////////////////////////////////////////////////////////////
			
			cam = new Camera();
			cam.on();
			
			
			
			this.level=Locator.assetsManager.getMovieClip(level);
			this.level.MC_spawn.alpha=0
			this.level.MC_spawn2.alpha=0
			camLookAt=Locator.assetsManager.getMovieClip("MCBackGround");
			camLookAt.scaleX = camLookAt.scaleY = 0.05;
			camLookAt.alpha=0;
			camLookAt.x=stage.stageWidth/2;
			camLookAt.y=stage.stageHeight/2;
			this.level.addChild(camLookAt);
			
			deadline=this.level.MC_dead;
			deadline.alpha=0;
			
			cam.addToView(this.level);
			cam.lookAt(camLookAt)
			
			allPlatformsToArrayLevel1();
			allWallsToArrayLevel1();
			
			for (var j:int = 0; j < playersCount; j++) 
			{
				if(j==0)
				{
					player = new RedPanda(Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.A,Keyboard.SPACE, Keyboard.Q);
					allPlayers.push(player);
				}
				else if(j==1)
				{
					player = new RedPanda(Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.COMMA, Keyboard.M);
					allPlayers.push(player);
				}
				else if(j==2)
				{
					player = new RedPanda(Keyboard.Y, Keyboard.H, Keyboard.J, Keyboard.G, Keyboard.K, Keyboard.L);
					allPlayers.push(player);
				}
				else if(j==3)
				{
					player = new RedPanda(Keyboard.NUMPAD_8, Keyboard.NUMPAD_5, Keyboard.NUMPAD_6, Keyboard.NUMPAD_4, Keyboard.NUMPAD_7, Keyboard.NUMPAD_9);
					allPlayers.push(player);
				}	
			}
			
			
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				if(i==0)
				{
					allPlayers[i].spawn(this.level.MC_spawn.x, this.level.MC_spawn.y, this.level);
				}
				else if(i==1)
				{
					allPlayers[i].model.scaleX*=-1;
					allPlayers[i].spawn(this.level.MC_spawn2.x, this.level.MC_spawn2.y, this.level);
				}
				else if(i==2)
				{
					allPlayers[i].spawn(this.level.MC_spawn.x+500, this.level.MC_spawn.y, this.level);
				}
				else if(i==3)
				{
					allPlayers[i].model.scaleX*=-1;
					allPlayers[i].spawn(this.level.MC_spawn2.x-500, this.level.MC_spawn2.y, this.level);
				}
				getPlayerPositionFromLocalToGlobal(allPlayers[i]);
			}
			
			playersGlobalPositionNearestToEdges= new Vector.<Point>;
			playersLocalPositionNearestToEdges= new Vector.<Point>;
			
			gameEnded=false;
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			//Locator.mainStage.addEventListener(MouseEvent.CLICK, offCamera);
			
		}
		
		/*protected function offCamera(event:MouseEvent):void
		{
		zoomIn();
		}*/
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////Zoom////////////////////////////////////////
		protected function zoomIn():void
		{
			if(canZoomIn)
			{
				cam.smoothZoom = cam.zoom * 1.1;
			}
		}
		
		protected function zoomOut():void
		{
			if(canZoomOut)
			{
				canZoomIn=false;
				cam.smoothZoom = cam.zoom / 1.3;
			}
			
		}		
		///////////////////////////////////////////////////////////////////////////////
		public function update(e:Event):void
		{	
			cam.lookAt(camLookAt)
			if (!pauseboolean)
			{
				for (var i:int = 0; i < allPlayers.length; i++) 
				{
					allPlayers[i].Update();
				}
				if(!gameEnded)
				{
					checkDeaths();
					/////////////////actualizo posiciones guardadas////////////////////
					updatePlayerGlobalAndLocalPositions();
					GetNearestPlayersToSides();
					GetNearestPlayersToSidesLocal();
					checkCamera();
					///////////////////////////Collitions//////////////////////////////
					granadeCollitions()
					if(cam.zoom>=1.4 || cam.zoom<=0.3)
					{
						canZoomIn=false
					}
				}
				checkPlayersColitions();
				
				if(allPlayers.length==1)
				{
					victorySet();
					gameEnded=true;
					if(camLookAt.x>allPlayers[0].model.x+5)
					{
						camLookAt.x-=3;
						zoomIn();
					}
					else if(camLookAt.x<allPlayers[0].model.x-5)
					{
						camLookAt.x+=3;
						zoomIn();
					}
					if(camLookAt.y>allPlayers[0].model.y+5)
					{
						camLookAt.y-=3;
					}
					else if(camLookAt.y<allPlayers[0].model.y-5)
					{
						camLookAt.y+=3;
					}
				}
			}
		}
		public function victorySet():void
		{
			if (!bool)
			{
				var yeah:Sound=Locator.assetsManager.getSound("yeahsound")
				var horn:Sound=Locator.assetsManager.getSound("victoryhorn")
				audioselection = new SoundController(yeah);
				audiovictory = new SoundController(horn);
				audiovictory.play(2);
				audiovictory.volume=0.3;
				audioselection.play(0);
				audioselection.volume=0.3;
				bool=true
				allPlayers[0].block=true;
				if(allPlayers[0].arrowbool)
				{
					allPlayers[0].deleteArrowForThrowingGranade();
				}
				for (var i:int = 0; i < allPlayers[0].granades.length; i++) 
				{
					allPlayers[0].granades[i].destroy(level);
					allPlayers[0].granades.splice(i, 1);
				}
				
			}
		}
		public function GetNearestPlayerToCannon(cannon:MovieClip):Point 
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			pLocal= new Point(cannon.x, cannon.y);
			pGlobal = cannon.parent.localToGlobal(pLocal);
			var nearestLeftPosition:Point = new Point(-10000);
			var nearestRightPosition:Point = new Point (10000);
			var nearestPlayerPosition:Point = new Point;
			
			for (var j:int = 0; j < playersLocalPositions.length; j++) 
			{
				if(playersLocalPositions[j].x<=pLocal.x && playersLocalPositions[j].x>nearestLeftPosition.x)
				{
					nearestLeftPosition.x=playersLocalPositions[j].x;
					nearestLeftPosition.y=playersLocalPositions[j].y;
				}
				if(playersLocalPositions[j].x>=pLocal.x && playersLocalPositions[j].x<nearestRightPosition.x)
				{
					nearestRightPosition.x=playersLocalPositions[j].x;
					nearestRightPosition.y=playersLocalPositions[j].y;
				}
			}
			if(pLocal.x - nearestLeftPosition.x < nearestRightPosition.x - pLocal.x)
			{
				nearestPlayerPosition = nearestLeftPosition
			}
			if(pLocal.x - nearestLeftPosition.x > nearestRightPosition.x - pLocal.x)
			{
				nearestPlayerPosition = nearestRightPosition
			}
			return nearestPlayerPosition;
		}
		
		public function GetNearestPlayersToSidesLocal():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point;
			
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersLocalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersLocalPositions[i].y;
				}
				if(playersLocalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersLocalPositions[i].y;
				}
			}
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersLocalPositionNearestToEdges=tempPlayer;
		}
		public function GetNearestPlayersToSides():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point;
			
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersGlobalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersGlobalPositions[i].y;
				}
				if(playersGlobalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersGlobalPositions[i].y;
				}
			}
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersGlobalPositionNearestToEdges=tempPlayer;
		}
		public function getPlayerPositionFromLocalToGlobal(player:Hero):void
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			
			pLocal= new Point(player.model.x, player.model.y);
			pGlobal = player.model.parent.localToGlobal(pLocal);
			playersLocalPositions.push(pLocal);
			playersGlobalPositions.push(pGlobal);
		}
		public function updatePlayerGlobalAndLocalPositions():void
		{
			var tempPLocal:Point;
			var tempPGlobal:Point;
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				tempPLocal= new Point(allPlayers[i].model.x, allPlayers[i].model.y);
				tempPGlobal = allPlayers[i].model.parent.localToGlobal(tempPLocal);
				playersLocalPositions[i]=tempPLocal;
				playersGlobalPositions[i]=tempPGlobal;
			}
		}
		
		public function checkCamera():void
		{
			
			mid2Players.x = (playersLocalPositionNearestToEdges[0].x + playersLocalPositionNearestToEdges[1].x)/2;
			mid2Players.y = (playersLocalPositionNearestToEdges[0].y + playersLocalPositionNearestToEdges[1].y)/2;
			if(playersGlobalPositionNearestToEdges[0].x<sideLimitsX)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].x>stage.stageWidth-sideLimitsX)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[0].y<100)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].y>stage.stageHeight-100)
			{
				zoomOut()
			}
			if(playersGlobalPositionNearestToEdges[0].x>300 && 
				playersGlobalPositionNearestToEdges[1].x<stage.stageWidth-300 &&
				playersGlobalPositionNearestToEdges[0].y>300 &&
				playersGlobalPositionNearestToEdges[1].y<stage.stageHeight-300)
			{
				zoomIn()
			}
			if(!fixCamera)
			{
				camLookAt.x=mid2Players.x;
				camLookAt.y=mid2Players.y;
			}
			else
			{
				if(camLookAt.x>=mid2Players.x+10)
				{
					camLookAt.x-=5;
				}
				else if(camLookAt.x<=mid2Players.x-10)
				{
					camLookAt.x+=5;
				}
				if(camLookAt.y>=mid2Players.y+10)
				{
					camLookAt.y-=5;
				}
				else if(camLookAt.y<=mid2Players.y-10)
				{
					camLookAt.y+=5;
				}
				fixCameraTimer-=1000/60;
				if(fixCameraTimer<=0)
				{
					fixCamera=false;
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//****************************************** Colition Checks ***********************************************************//
		public function checkDeaths():void
		{
			for (var k:int = allPlayers.length-1; k >= 0; k--) 
			{
				if (allPlayers[k].model.MC_botHitBox.hitTestObject(deadline))
				{
					allPlayers[k].destroy();
					allPlayers.splice(k, 1);
					playersGlobalPositionNearestToEdges=new Vector.<Point>;
					playersLocalPositionNearestToEdges=new Vector.<Point>;
					playersGlobalPositions= new Vector.<Point>;
					playersLocalPositions= new Vector.<Point>;
					fixCamera=true;
					fixCameraTimer=2000;
				}
			}
		}
		public function checkPlayersColitions():void
		{
			for (var k:int =  allPlayers.length-1; k >= 0; k--) 
			{
				
				for (var i:int = 0; i < allPlatformsOfLevel1.length; i++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[i])&&allPlayers[k].framecontador>=6&&allPlayers[k].fallSpeed>0)
					{
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allPlatformsOfLevel1[i].y-allPlatformsOfLevel1[i].height+5;
						allPlayers[k].JumpContador=0;
						if (allPlayers[k].isjumping&&!allPlayers[k].block)
						{
							allPlayers[k].changeAnimation(allPlayers[k].ANIM_IDLE);
						}
						allPlayers[k].isjumping=false;
						allPlayers[k].model.rotation=allPlayers[k].rotacionoriginal;
					}				
				}
				for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
				{
					if(allPlayers[k].model.MC_sideHitBox.hitTestObject(allWallsOfLevel1[j]))
					{
						allPlayers[k].canmove=false;
					}
				}
			}
		}
		public function allPlatformsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_platform")
				{
					allPlatformsOfLevel1.push(level.getChildAt(i));
					level.getChildAt(i).alpha=0;
					
				}
			}
		}
		public function allWallsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_wall")
				{
					allWallsOfLevel1.push(level.getChildAt(i));
					level.getChildAt(i).alpha=0;
				}
			}
		}	
		
		public function granadeCollitions():void
		{
			for (var j:int = allPlayers.length-1; j >= 0; j--) 
			{
				for (var i:int = allPlayers[j].granades.length-1; i >= 0; i--) 
				{
					for (var l:int = 0; l < allPlatformsOfLevel1.length; l++) 
					{
						if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[l]) && allPlayers[j].granades[i].fallSpeed>10)
						{
							trace(allPlayers[j].granades[i].fallSpeed)
							allPlayers[j].granades[i].fallen=true;
							allPlayers[j].granades[i].model.y=allPlatformsOfLevel1[l].y-allPlatformsOfLevel1[l].height;
							allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-2;
							allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
							trace("colisiona")
							
							
						}      
					}
					for (var k:int= allPlayers.length-1; k >= 0; k--) 
					{
						if(k!=j && allPlayers[j].granades[i].model.hitTestObject(allPlayers[k].model) && allPlayers[j].granades[i].currentColdownToApplyForceOnPlayer<=0)
						{
							var direction:Point = new Point;
							var distance:Point = new Point;
							var radians:Number;
							var degrees:Number;
							
							distance.x = allPlayers[k].model.x- allPlayers[j].granades[i].model.x;
							distance.y = allPlayers[k].model.y- allPlayers[j].granades[i].model.y;
							radians = Math.atan2(distance.y, distance.x);
							
							direction.x = Math.cos(radians);
							direction.y = Math.sin(radians);
							allPlayers[k].gotHitByGranade=true;
							allPlayers[k].directionToFlyByGranade=direction;
							allPlayers[j].granades[i].destroy(level);
							allPlayers[j].granades.splice(i, 1);
							break;
						}    
					}
					
				}
			}
		}
		
		public function destroyall():void
		{
			for (var k:int = 0; k < allPlatformsOfLevel1.length; k++) 
			{
				allPlatformsOfLevel1.splice(k,1);
			}
			
			for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
			{
				allWallsOfLevel1.splice(j,1);
			}
			for (var i:int = allPlayers.length-1; i >= 0; i--) 
			{
				allPlayers[i].destroy();
				allPlayers.splice(i,1);
			}
			cam.off();
			cam=new Camera
			Locator.mainStage.removeEventListener(Event.ENTER_FRAME, update)
			//Locator.mainStage.removeEventListener(MouseEvent.CLICK, offCamera);
			audio.stop();
		}
	}
}