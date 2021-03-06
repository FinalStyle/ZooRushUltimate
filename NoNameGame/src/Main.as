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
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	[SWF(height="720", width="1280", frameRate="60")]
	public class Main extends Locator
	{
		public static var instance:Main;
		
		public var level:MovieClip;
		public var gamestarted:Boolean=false;
		public var gameEnded:Boolean = false;
		
		public var allPlatformsOfLevel1:Array;
		public var allplatformsbase:Array;
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
		public var menuUp:Boolean;
		public var menuDown:Boolean;
		public var menu1:MovieClip;
		public var menu2:MovieClip;
		public var creditos:MovieClip;
		public var howToPlay:MovieClip;
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
			mouseEnabled=false;
			Mouse.hide()
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
			howToPlay=Locator.assetsManager.getMovieClip("MC_howToPlay");
			howToPlay.scaleX=0.5;
			howToPlay.scaleY=0.5;
			creditos.scaleX=0.5;
			creditos.scaleY=0.5;
			menu1.scaleX=0.5;
			menu1.scaleY=0.5;
			menu2.scaleX=0.5;
			menu2.scaleY=0.5;
			Locator.mainStage.addChild(menu1)
			menu1.MC_creditos.alpha=0
			menuUp=true;
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			
			
		}
		
		
		
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
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
					menuUp=true;
					menuDown=false;
					break;
				}
				case Keyboard.DOWN:
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
					menuDown=true;
					menuUp=false;
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
					if (menuUp==true&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1);
						Locator.mainStage.addChild(menu2);
						menu2.MC_level1.alpha=1;
						menu2.MC_level2.alpha=0;
						menuUp=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
						
						
					}
					else if (menuUp==false&&Locator.mainStage.contains(menu1))
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
						menuUp=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
					}
					else if (menuUp==false&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel2", 4);
						gamestarted=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
						
					}
					else if (menuUp==true&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel1", 2);
						gamestarted=true;
						audioselection = new SoundController(aceptarsounds);
						audioselection.play(0);
						audioselection.volume=0.4;
					}
					break;
				}
				case Keyboard.H:
				{
					if(Locator.mainStage.contains(menu1) && !Locator.mainStage.contains(howToPlay))
					{
						Locator.mainStage.addChild(howToPlay);
					}
					else if(Locator.mainStage.contains(menu1) && Locator.mainStage.contains(howToPlay))
					{
						Locator.mainStage.removeChild(howToPlay);
					}
				}
			}
			
		}
		public function evStartGame(level:String, playersCountForGame:int):void
		{
			bool=false;
			playersCount = playersCountForGame;
			var song:Sound=	Locator.assetsManager.getSound("song1");
			audio = new SoundController(song);
			audio.play(11)
			audio.volume=0.2;
			pause.getlevel(level);
			allPlatformsOfLevel1 = new Array();
			allplatformsbase = new Array();
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
			cam.lookAt(camLookAt);
			
			allPlatformsToArrayLevel1();
			allWallsToArrayLevel1();
			addPlayers(playersCount);
			
			playersGlobalPositionNearestToEdges= new Vector.<Point>;
			playersLocalPositionNearestToEdges= new Vector.<Point>;
			
			gameEnded=false;
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			
		}
		
		public function addPlayers(numberOfPlayers:int):void
		{
			
			var player:Hero;
			var gfilter:GlowFilter = new GlowFilter;
			gfilter.strength=5
			for (var j:int = 0; j < playersCount; j++) 
			{
				if(j==0)
				{
				
					gfilter..color=0xff0000;
					gfilter.strength=2;
					gfilter.quality=15;
					player = new RedPanda(Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.A,Keyboard.SPACE, Keyboard.Q);
					/*player.model.filters = [gfilter]*/
					
					
					allPlayers.push(player);
				}
				else if(j==1)
				{
					player = new RedPanda(Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.COMMA, Keyboard.M);
					//player.model.transform.colorTransform = new ColorTransform(0,0,115,1)
					gfilter= new GlowFilter;
					gfilter.color=0x0000ff
					gfilter.strength=5
					gfilter.strength=2;
					gfilter.quality=15;
					/*player.model.filters = [gfilter]*/
				/*	player.model.transform.colorTransform= new ColorTransform(2.55,2.06,0.88)*/
					/*player.model.transform.colorTransform= new ColorTransform(1.69,2.32,2.55)*/
					/*player.model.transform.colorTransform= new ColorTransform(1.69,1.92,2.05)*/
					player.model.transform.colorTransform= new ColorTransform(1.35,1.66,1.77)
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
		}
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////Zoom////////////////////////////////////////
		protected function zoomIn():void
		{
			if(canZoomIn && cam.zoom<=1.4)
			{
				cam.smoothZoom = cam.zoom * 1.1;
				sideLimitsX=100;
			}
		}
		
		protected function zoomOut():void
		{
			if(canZoomOut && cam.zoom>=0.3)
			{
				canZoomIn=false;
				cam.smoothZoom = cam.zoom / 1.3;
				sideLimitsX--
			}
			
		}		
		///////////////////////////////////////////////////////////////////////////////
		public function update(e:Event):void
		{	
			//trace(cam.zoom, canZoomIn)
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
				
				}
				checkPlayersColitions();
				
				if(allPlayers.length==1)
				{
					victorySet();
					gameEnded=true;
					if(camLookAt.x>allPlayers[0].model.x+10)
					{
						camLookAt.x-=8;
						zoomIn();
					}
					else if(camLookAt.x<allPlayers[0].model.x-10)
					{
						camLookAt.x+=8;
						zoomIn();
					}
					else
					{
						if (!pauseboolean)
						{
							pause.pauseon(stage.stageWidth/2, stage.stageHeight/2);
						}
					}
					
					if(camLookAt.y>allPlayers[0].model.y+10)
					{
						camLookAt.y-=8;
					}
					else if(camLookAt.y<allPlayers[0].model.y-10)
					{
						camLookAt.y+=8;
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
				audiovictory.play(0);
				audiovictory.volume=0.3;
				audioselection.play(0);
				audioselection.volume=0.3;
				bool=true
				allPlayers[0].block=true;
				if(allPlayers[0].arrowbool)
				{
					allPlayers[0].deleteArrowForThrowingGranade();
				}
				for (var i:int = allPlayers[0].granades.length-1; i >= 0; i--) 
				{
					allPlayers[0].granades[i].destroy(level);
					allPlayers[0].granades.splice(i, 1);
				}
				
				
			}
		}
		
		public function GetNearestPlayersToSidesLocal():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point(-10000, -10000);
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
			var highestValues:Point = new Point(-10000, -10000);
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
			if(playersGlobalPositionNearestToEdges[0].x>200 && 
				playersGlobalPositionNearestToEdges[1].x<stage.stageWidth-200 &&
				playersGlobalPositionNearestToEdges[0].y>150 && 
				playersGlobalPositionNearestToEdges[1].y<stage.stageHeight-150)
			{
				zoomIn()
			}
			if(!fixCamera)
			{
				trace(playersLocalPositionNearestToEdges[0].x , playersLocalPositionNearestToEdges[1].x , mid2Players.x);
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
						if (allPlayers[k].isjumping&&!allPlayers[k].block ||allPlayers[k].fallSpeed>8)
						{
							allPlayers[k].changeAnimation(allPlayers[k].ANIM_IDLE);
						}
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allPlatformsOfLevel1[i].y-allPlatformsOfLevel1[i].height+5;
						allPlayers[k].JumpContador=0;
						
						allPlayers[k].isjumping=false;
					}				
				}
				for (var c:int = 0; c < allplatformsbase.length; c++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allplatformsbase[c])&&allPlayers[k].fallSpeed>0)
					{
						if (allPlayers[k].isjumping&&!allPlayers[k].block ||allPlayers[k].fallSpeed>8)
						{
							allPlayers[k].changeAnimation(allPlayers[k].ANIM_IDLE);
						}
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allplatformsbase[c].y-allplatformsbase[c].height+5;
						allPlayers[k].JumpContador=0;
						
						allPlayers[k].isjumping=false;
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
				else if (level.getChildAt(i).name=="mc_platformbase")
				{
					
					allplatformsbase.push(level.getChildAt(i));
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
							allPlayers[j].granades[i].fallen=true;
							allPlayers[j].granades[i].model.y=allPlatformsOfLevel1[l].y-allPlatformsOfLevel1[l].height;
							allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-2;
							allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
						}      
					}
					
					allplatformsbase
					for (var c:int = 0; c < allplatformsbase.length; c++) 
					{
						if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allplatformsbase[c]) && allPlayers[j].granades[i].fallSpeed>10)
						{
							allPlayers[j].granades[i].fallen=true;
							allPlayers[j].granades[i].model.y=allplatformsbase[c].y-allplatformsbase[c].height;
							allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-2;
							allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
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
							allPlayers[j].granades[i].explode();
							
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
			
			for (var c:int = 0; c < allplatformsbase.length; c++) 
			{
				allplatformsbase.splice(c,1);
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
			audio.stop();
			
		}
	}
}