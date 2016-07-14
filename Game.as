package
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Mouse;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	
	/**
	 * 优点：
	 * 1.游戏性高，逻辑性强
	 * 2.游戏画面还行
	 * 3.面向对象编程，可扩展性强（如加入新的敌人编写新的as文件即可）
	 * 4.游戏中UI显示各种信息，子弹数，生命，游戏时间，音效设置按钮等
	 *
	 * 缺点：
	 * 1.代码有点乱，变量名起的不好
	 * 2.游戏素材大多数非原创（从素材网下载后经过修改得到的）
	 *
	 */
	
	public class Game extends Sprite
	{
		//游戏状态
		private const GAME_MENU:uint = 1;
		private const GAME_PLAYING:uint = 2;
		private const GAME_WIN:uint = 3;
		private const GAME_OVER:uint = 4;
		//当前游戏状态
		private var mGameState = 1;
		//游戏界面UI
		private var gameMenu:GameMenu = new GameMenu();//开始菜单
		private var gameUI:GameUI = new GameUI();//游戏中UI
		private var gameOver:GameEnd = new GameEnd();//GameOver的界面
		
		private var gameScore:int = 0;//游戏积分
		
		private var isAddEnemy:Boolean = true; //是否要添加敌人
		
		private var myTimer:Timer = new Timer(1000, int.MAX_VALUE);//用了计游戏的时间
		private var gameTimeSum:int = 0; //游戏时间秒数
		
		private var myPlayer:Player;//主角
		
		private var isjump:Boolean = false;//是否在跳高
		private var isOnLand:Boolean = true;//是否着地
		
		private var keyObj:Object = {};
		
		private var mybull:myBullet;//子彈容器
		
		private var mGun:myGun;//枪，myGun类
		
		private var shoot:Shoot = new Shoot;//瞄准镜,跟随鼠标
		
		private var myEnemy:MovieClip = new MovieClip();//敌人容器，enemy.as类
		
		private var myEnemy2:MovieClip = new MovieClip();
		
		private var myEnemy3:MovieClip = new MovieClip();
		
		private var Bg:MovieClip = new MovieClip;//背景方块容器
		private var Mc:Array = new Array;//地面容器
		private var Vy:Number = 0;//player垂直速度,用来模拟重力
		
		//储存背景云的容器
		private var myCloud = new cloud();
		
		//音效处理,背景音乐
		private var myMusic:Sound = new Sound;
		private var channel:SoundChannel = new SoundChannel();
		private var changeForm:SoundTransform = new SoundTransform();
		
		private var isBgmMute:Boolean = false;
		private var isSoundMute:Boolean = false;
		
		public function Game():void
		{
			
			//初始化音乐
			myMusic.load(new URLRequest("bgm.mp3"));
			channel = myMusic.play(0, int.MAX_VALUE);
			changeForm.volume = 0.2;
			channel.soundTransform = changeForm;
			
			myPlayer = new Player(Bg, Mc, bg);
			
			stage.addChild(myPlayer);
			
			//添加动态云背景
			stage.addChild(myCloud);
			//根据player元件文字生成mGun，实例化
			mGun = new myGun(myPlayer.getX(), myPlayer.getY());
			//添加枪到舞台
			stage.addChild(mGun);
			
			//添加瞄准镜
			stage.addChildAt(shoot, 4);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, Mouse_move);
			
			stage.addEventListener(Event.ENTER_FRAME, GameEvent);
			//键盘按键监听
			stage.addEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, myKeyUp);
			
			//把地面元件mc0存到Mc数组中
			Mc.push(mc0);
			//初始化界面，先置为游戏菜单状态
			changeGameState(GAME_MENU);
		
		}
		
		//改变游戏状态
		private function changeGameState(GameState:uint):void
		{//把游戏当前状态，记录为新的状态
			mGameState = GameState;
			
			switch (GameState)
			{
			case GAME_MENU: 
				//清除其他状态的UI元件
				if (stage.contains(gameUI))
				{
					myTimer.reset();
					myTimer.removeEventListener(TimerEvent.TIMER, countTime);
					gameTimeSum = 0;
					gameUI.back_menu.removeEventListener(MouseEvent.CLICK, backToMenu);
					stage.removeEventListener(MouseEvent.CLICK, mybull.fire);
					stage.removeChild(gameUI);
				}
				if (stage.contains(gameOver))
				{
					gameOver.btn_back_menu.removeEventListener(MouseEvent.CLICK, backToMenu);
					stage.removeChild(gameOver);
					
					myPlayer.visible = true;
					mGun.visible = true;
				}
				
				if (Bg.numChildren != 0)
				{
					Bg.removeChildren(0, int.MAX_VALUE);
				}
				
				
				//删除敌人容器内的敌人
				while (myEnemy.numChildren != 0)
				{
					
					var en:enemy = myEnemy.getChildAt(0) as enemy;
					en.removeListener();
					myEnemy.removeChildAt(0);
				}
				
				if (myEnemy2.numChildren != 0)
				{
					myEnemy2.removeChildren(0, int.MAX_VALUE);
				}
				
				if (myEnemy3.numChildren != 0)
				{
					myEnemy3.removeChildren(0, int.MAX_VALUE);
				}
				
				//重置分数
				gameScore = 0;
				isAddEnemy = true;
				//重置时间
				gameTimeSum = 0;
			
				
				//加载开始菜单
				gameMenu.x = 15;
				gameMenu.y = 15;
				stage.addChild(gameMenu);
				
				myEnemy.x = 0;
				myEnemy.y = 0;
				
				myEnemy.addChild(new enemy());
				
				stage.addChild(myEnemy);
				
				Bg.x = 0;
				bg.x = -470;
				
				//myEnemy2.addChild(new enemy2());
				
				stage.addChild(myEnemy2);
				
				gameMenu.start_game.addEventListener(MouseEvent.CLICK, startgame);
				gameMenu.exit_game.addEventListener(MouseEvent.CLICK, exitgame);
				gameMenu.btn_vol.addEventListener(MouseEvent.CLICK, changeMute);
				
				break;
			case GAME_PLAYING: 
				//开始玩游戏
				if (stage.contains(gameMenu))
				{
					gameMenu.start_game.removeEventListener(MouseEvent.CLICK, startgame);
					stage.removeChild(gameMenu);
				}
				//加载游戏时的画面
				gameUI.x = 0;
				gameUI.y = 0;
				gameUI.back_menu.addEventListener(MouseEvent.CLICK, backToMenu);
				gameUI.btn_soundEffect.addEventListener(MouseEvent.CLICK, soundEffectOn);
				gameUI.btn_Bgm.addEventListener(MouseEvent.CLICK, bgmOn);
				
				
				myTimer.addEventListener(TimerEvent.TIMER, countTime);
				stage.addChild(gameUI);
				myTimer.start();
				gameUI.game_time.text = "0分0秒";
				
				stage.addChild(myEnemy3);
				
				//设置FPS
				stage.frameRate = 40;
				//实例化子弹容器
				mybull = new myBullet(mGun.getGun(), shoot, Mc, Bg, isSoundMute);
				//添加开火点击监测器
				stage.addEventListener(MouseEvent.CLICK, mybull.fire);
				
				stage.addChild(mybull);
				mybull.setIsMute(isSoundMute);
				//加载关卡
				loadLeve1();
				
				soundEffectOn(null);
				soundEffectOn(null);
				
				bgmOn(null);
				bgmOn(null);
				
				break;
			
			case GAME_WIN:
				
				break;
			
			case GAME_OVER: 
				//清除playing的界面，敌人等数据
				
				//删除敌人容器内的敌人
				while (myEnemy.numChildren != 0)
				{
					
					var en_1:enemy = myEnemy.getChildAt(0) as enemy;
					en_1.removeListener();
					myEnemy.removeChildAt(0);
				}
				
				if (mybull.numChildren != 0)
				{
					mybull.removeChildren(0, int.MAX_VALUE);
				}
				
				if (myEnemy2.numChildren != 0)
				{
					myEnemy2.removeChildren(0, int.MAX_VALUE);
				}
				
				if (myEnemy3.numChildren != 0)
				{
					myEnemy3.removeChildren(0, int.MAX_VALUE);
				}
				//删除场景
				if (Bg.numChildren != 0)
				{
					Bg.removeChildren(0, int.MAX_VALUE);
				}
				//删除游戏中界面
				if (stage.contains(gameUI))
				{
					stage.removeChild(gameUI);
					stage.removeEventListener(MouseEvent.CLICK, mybull.fire);
				}
				
				myPlayer.visible = false;
				mGun.visible = false;
				
				//加载gameover界面
				gameOver.x = 459;
				gameOver.y = 270;
				gameOver.btn_back_menu.addEventListener(MouseEvent.CLICK, backToMenu);
				stage.addChildAt(gameOver, 3);
				break;
				
			}
		
		}
		
		function changeMute(e:MouseEvent):void
		{
			if (isSoundMute)
			{
				gameMenu.btn_vol.vol_on.visible = false;
				gameMenu.btn_vol.vol_off.visible = true;
				
				isSoundMute = false;
				isBgmMute = false;
				changeForm.volume = 0.2;
				channel.soundTransform = changeForm;
			}
			else
			{
				
				gameMenu.btn_vol.vol_on.visible = true;
				gameMenu.btn_vol.vol_off.visible = false;
				isSoundMute = true;
				isBgmMute = true;
				changeForm.volume = 0;
				channel.soundTransform = changeForm;
			}
			
			myPlayer.setIsMute(isSoundMute);
			//mybull.setIsMute(isSoundMute);
		
		}
		
		//开始游戏
		function startgame(e:MouseEvent):void
		{
			changeGameState(GAME_PLAYING);
		}
		
		//退出游戏
		function exitgame(e:MouseEvent):void
		{
			fscommand("quit");
		}
		
		//返回菜单
		function backToMenu(e:MouseEvent):void
		{
			changeGameState(GAME_MENU);
		}
		
		//音效静音
		function soundEffectOn(e:MouseEvent):void
		{
			if (isSoundMute)
			{
				gameUI.btn_soundEffect.vol_on.visible = false;
				gameUI.btn_soundEffect.vol_off.visible = true;
				isSoundMute = false;
			}
			else
			{	
				gameUI.btn_soundEffect.vol_on.visible = true;
				gameUI.btn_soundEffect.vol_off.visible = false;
				isSoundMute = true;
			}
			
			myPlayer.setIsMute(isSoundMute);
			mybull.setIsMute(isSoundMute);
		}
		
		//背景音乐静音
		function bgmOn(e:MouseEvent):void
		{
			if (isBgmMute)
			{
				gameUI.btn_Bgm.vol_on.visible = false;
				gameUI.btn_Bgm.vol_off.visible = true;
				
				isBgmMute = false;
				changeForm.volume = 0.2;
				channel.soundTransform = changeForm;
			}
			else
			{
				
				gameUI.btn_Bgm.vol_on.visible = true;
				gameUI.btn_Bgm.vol_off.visible = false;
				isBgmMute = true;
				changeForm.volume = 0;
				channel.soundTransform = changeForm;
			}
			
		}
		
		private function countTime(e:TimerEvent):void
		{//游戏时间加1
			gameTimeSum++;
			if (stage.contains(gameUI))
			{
				var cen:int = gameTimeSum / 60;
				var scr:int = gameTimeSum % 60;
				gameUI.game_time.text = cen + "分" + scr + "秒";
			}
		}
		
		//加载场景1
		function loadLeve1():void
		{
			//第一种生成地图方式
			
			for (var i:int = 0; i < 4; i++)
			{
				var bg:BgItem = new BgItem;
				bg.x = 120 + 25 * i;
				bg.y = 385;
				Bg.addChild(bg);
			}
			
			for (var i1:int = 0; i1 < 12; i1++)
			{
				var bg1:BgItem = new BgItem;
				bg1.x = 400 + 25 * i1;
				bg1.y = 300;
				Bg.addChild(bg1);
			}
			
			for (var i2:int = 0; i2 < 9; i2++)
			{
				var bg2:BgItem = new BgItem;
				bg2.x = 100 + 25 * i2;
				bg2.y = 180;
				Bg.addChild(bg2);
			}
			
			for (var i3:int = 0; i3 < 9; i3++)
			{
				var bg3:BgItem = new BgItem;
				bg3.x = 700 + 25 * i3;
				bg3.y = 220;
				Bg.addChild(bg3);
			}
			
			for (var i4:int = 0; i4 < 9; i4++)
			{
				var bg4:BgItem = new BgItem;
				bg4.x = 900 + 25 * i4;
				bg4.y = 350;
				Bg.addChild(bg4);
			}
			
			for (var i5:int = 0; i5 < 6; i5++)
			{
				var bg5:BgItem = new BgItem;
				bg5.x = 1300 + 50 * i5;
				bg5.y = 300 - 30 * i5;
				Bg.addChild(bg5);
			}
			
			for (var i6:int = 0; i6 < 6; i6++)
			{
				var bg6:BgItem = new BgItem;
				bg6.x = 1700 + 50 * i6;
				bg6.y = 200 + 40 * i6;
				Bg.addChild(bg6);
			}
			
			for (var i7:int = 0; i7 < 6; i7++)
			{
				var bg7:BgItem = new BgItem;
				bg7.x = 2100 + 25 * i7;
				bg7.y = 240;
				Bg.addChild(bg7);
			}
			
			//第二种生成地图方式
			/*
			   for (var i:int = 0; i < 4; i++)
			   {
			   var bg:BgItem = new BgItem;
			   bg.x = 120 + 25 * i;
			   bg.y = 385;
			   Bg.addChild(bg);
			   }
			
			   var blockX:int = 220;
			   for (var i7:int = 0; i7 < 10; i7++)
			   {
			   var blockNum:int = Math.random() * 10 + 5;
			   var blockY = Math.random()*300 + 150;
			   for (var i8:int = 0; i8 < blockNum;i8++ ){
			   var bg8:BgItem = new BgItem;
			   bg8.x = blockX + 25 * i8;
			   bg8.y = blockY+Math.random()*15;
			   Bg.addChild(bg8);
			   //blockX = bg8.x +25;
			   }
			   blockX += 25 * blockNum+Math.random()*40+125;
			
			   }
			*/
			stage.addChildAt(Bg, 2);
		}
		
		function Mouse_move(e:MouseEvent):void
		{
			var hx:Number;
			var hy:Number;
			var angle:Number;
			//设置瞄准器跟随鼠标
			shoot.x = e.stageX + shoot.width / 2;
			shoot.y = e.stageY + shoot.height / 2;
			
			hx = e.stageX - myPlayer.getX();//鼠标距离player,x距离
			hy = e.stageY - myPlayer.getY();//鼠标距离player,y距离
			
			//根据鼠标位置与player位置计算角度
			angle = Math.atan2(Math.abs(hy), Math.abs(hx)) * 180 / Math.PI;
			
			//根据鼠标位置决定player是否翻转
			myPlayer.setScale(e);
			
			//根据player，鼠标的坐标，设置枪跟随player，角度等数据
			mGun.setGunRotate(e, myPlayer.getX(), myPlayer.getY(), angle);
		}
		
		function GameEvent(event:Event):void
		{
			//设置枪跟随player,调用枪类的方法
			mGun.setGunXY(myPlayer.getX(), myPlayer.getY() - 2);
			
			var myp:myplayer = myPlayer.getPlayer();
			
			//用来判断是否碰到东西
			var hit:Boolean = false;
			
			//隐藏鼠标
			Mouse.hide();
			
			myPlayer.setKeyObj(keyObj);
			
			//根据不同游戏状态作出不同处理
			switch (mGameState)
			{
			case GAME_PLAYING:
				
				if (myEnemy)
				{
					
					var num:int = myEnemy.numChildren;
					
					for (var j:int = 0; j < num; j++)
					{
						
						var ab:enemy = myEnemy.getChildAt(j) as enemy;
						
						ab.isEnemyAngry(myPlayer.getX(), myPlayer.getY());
						
						ab.setKeyObj(keyObj);
						
						ab.isBgMove(myPlayer.getX(), myPlayer.getY(),bg.x);
						
						if (ab.GetHp() == 0)
						{
							ab.removeListener();
							myEnemy.removeChild(ab);
							num = myEnemy.numChildren;
							break;
						}
						
						if (myp.hitTestObject(ab))
						{
							myPlayer.PlayerHurt();
						}
						
						if (mybull)
						{
							
							var num2:int = mybull.numChildren;
							
							for (var i:int = 0; i < num2; i++)
							{
								
								var ab2:bullet = mybull.getChildAt(i) as bullet;
								
								if (ab2.hitTestObject(ab))
								{
									
									ab.enemy2Hp();
									
									mybull.removeChild(ab2);
									num2 = mybull.numChildren;
									gameScore += 2;
									
								}
								
							}
							
						}
					}
				}
				
				if (myEnemy2)
				{
					
					var num3:int = myEnemy2.numChildren;
					
					for (var j_3:int = 0; j_3 < num3; j_3++)
					{
						
						var ac:enemy2 = myEnemy2.getChildAt(j_3) as enemy2;
						ac.enemy2Move(myPlayer.getX(), myPlayer.getY());
						
						if (ac.GetHp() == 0)
						{
							myEnemy2.removeChild(ac);
							
							num3 = myEnemy2.numChildren;
							break;
						}
						
						if (myp.hitTestObject(ac))
						{
							myPlayer.PlayerHurt();
						}
						
						if (mybull)
						{
							
							var num4:int = mybull.numChildren;
							
							for (var i_4:int = 0; i_4< num4; i_4++)
							{
								
								var ac2:bullet = mybull.getChildAt(i_4) as bullet;
								
								if (ac2.hitTestObject(ac))
								{
									
									ac.enemy2Hp();
									
									mybull.removeChild(ac2);
									
									num4 = mybull.numChildren;
									
									gameScore += 3;
									
								}
							}
						}
					}
				}
				
				if (myEnemy3)
				{
					
					var num5:int = myEnemy3.numChildren;
					
					for (var j_5:int = 0; j_5 < num5; j_5++)
					{
						
						var ad:enemy3 = myEnemy3.getChildAt(j_5) as enemy3;
						ad.enemy3Move(myPlayer.getY());
						
						if (ad.GetHp() == 0)
						{
							myEnemy3.removeChild(ad);
							
							num5 = myEnemy3.numChildren;
							break;
						}
						
						if (myp.hitTestObject(ad))
						{
							myPlayer.PlayerHurt();
						}
						
						if (ad.x < -50)
						{
							if (myEnemy3.contains(ad))
							{
								myEnemy3.removeChild(ad);
								break;
							}
						}
						
						if (mybull)
						{
							
							var num6:int = mybull.numChildren;
							
							for (var i_6:int = 0; i_6 < num6; i_6++)
							{
								
								var ad2:bullet = mybull.getChildAt(i_6) as bullet;
								
								if (ad2.hitTestObject(ad))
								{
									
									ad.enemy3Hp();
									
									mybull.removeChild(ad2);
									
									num6 = mybull.numChildren;
									
									gameScore += 4;
									
								}
								
							}
							
						}
					}
					
				}
				
				debug.text = "bg:" + bg.x;
				
				gameUI.bulletNum_txt.text = "子弹详情：" + mybull.getLoadNum() + "/" + mybull.getBulletNum();
				gameUI.player_life.text = "生命值：" + myPlayer.GetPlayerHp();
				gameUI.Score_Text.text = "分数：" + gameScore;
				
				//重装填
				if (keyObj[82])
				{//判断是否需要重装填
					if (!mybull.isReload)
					{
						mybull.bulletReload();
					}
				}
				
				//根据背景坐标判断是否需要添加敌人
				//isAddEnemy 由定时器来决定置为 true
				if (isAddEnemy)
				{
					isAddEnemy = false;
					
					if (bg.x > -1038)
					{
						var num_1:int = Math.random() * 3 + 4;
						for (var i_11:int = 0; i_11 < num_1; i_11++)
						{
							var en1:enemy = new enemy();
							
							myEnemy.addChild(en1);
						}
						
					}
					else if (bg.x <= -1038 && bg.x >= -1588)
					{
						var num_2:int = Math.random() * 3 + 3;
						for (var i_21:int = 0; i_21 < num_2; i_21++)
						{
							var en2:enemy2 = new enemy2();
							
							myEnemy2.addChild(en2);
						}
						
					}
					else if (bg.x < -1588)
					{
						
						var num_3_1:int = Math.random() * 3 + 4;
						for (var i_31:int = 0; i_31 < num_3_1; i_31++)
						{
							var en11:enemy = new enemy();
							
							myEnemy.addChild(en11);
						}
						var num_3_2:int = Math.random() * 3 + 4;
						for (var i_32:int = 0; i_32 < num_3_2; i_32++)
						{
							var en22:enemy2 = new enemy2();
							
							myEnemy2.addChild(en22);
						}
						
						var num_3_3:int = Math.random() * 3 + 4;
						var en3Timer:Timer = new Timer(2000, num_3_3);
						en3Timer.addEventListener(TimerEvent.TIMER, addEn3)
						en3Timer.start();
						
					}
					
					mybull.AddbulletNum(60);
					
					var addEnemyTimer:Timer = new Timer(1000, 20);
					addEnemyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, addEnemy);
					addEnemyTimer.start();
				}
				
				if (myPlayer.GetPlayerHp() <= 0)
				{
					//游戏失败，改变状态	
					changeGameState(GAME_OVER);
					myPlayer.SetPlayerHp(10);
				}
				
				//判断游戏是否胜利
				break;
			}
		}
		
		//刷新
		function addEn3(e:TimerEvent)
		{
			var en:enemy3 = new enemy3();
			myEnemy3.addChild(en);
		}
		
		//倒计时刷新怪物
		function addEnemy(e:TimerEvent)
		{
			isAddEnemy = true;
		}
		
		function myKeyDown(e:KeyboardEvent)
		{
			keyObj[e.keyCode] = true;
		}
		
		function myKeyUp(e:KeyboardEvent)
		{
			keyObj[e.keyCode] = false;
		}
	}
}