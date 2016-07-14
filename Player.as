package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Mouse;
	import flash.display.DisplayObject;
	import flash.media.SoundTransform;
	
	public class Player extends MovieClip
	{
		private var mPlayer:myplayer;//元件myplayer
		
		private var keyObj:Object = {};
		
		private var isjump:Boolean = false;//是否在跳高
		private var isOnLand:Boolean = true;//是否着地
		private var isWalking:Boolean = false;//是否在行走，动作用
		
		private var hp:int = 10;//生命数
		
		private var Bg:MovieClip = new MovieClip;//背景方块容器
		private var Mc:Array = new Array;//地面容器
		private var bg:MovieClip;
		private var isMute:Boolean = false;
		
		private var Vy:Number = 0;//player垂直速度,用来模拟重力
		
		private var hitground:Sound = new hit_ground;//人着地声音
		private var sc:SoundChannel = new SoundChannel();
		private var st:SoundTransform = new SoundTransform();
		
		private var isGod:Boolean = false;//是否无敌
		
		public function Player(Bg:MovieClip, Mc:Array, bg:MovieClip)
		{
			this.Bg = Bg;
			this.Mc = Mc;
			this.bg = bg;
			
			
			mPlayer = new myplayer();
			
			mPlayer.x = 40.6;
			mPlayer.y = 470.15;
			addChild(mPlayer);
			
			addEventListener(Event.ENTER_FRAME, PlayerMove);
		
		}
		
		public function setIsMute(isMute:Boolean):void{
			this.isMute = isMute;
		}
		
		public function setScale(e:MouseEvent):void
		{
			if (e.stageX > mPlayer.x)
			{
				mPlayer.scaleX = 1;
			}
			else
			{
				mPlayer.scaleX = -1;
			}
		
		}
		
		//获得player对象，用于主类调用
		public function getPlayer():myplayer
		{
			return mPlayer;
		}
		
		public function getX():Number
		{
			return mPlayer.x;
		}
		
		public function getY():Number
		{
			return mPlayer.y;
		}
		
		public function PlayerMove(e:Event):void
		{
			//用来判断是否碰到东西
			var hit:Boolean = false;
			
			if (!isjump)
			{//不是在跳高，则模拟重力，并实时检测是否有碰到场景，地面
				for (var i:uint = 0; i < 1; i++)
				{
					if (Mc[i] == null)
					{
						continue;
					}
					//判断是否碰地面元素
					if (mPlayer.hitTestObject(Mc[i]))
					{
						hit = true;
						if (!isOnLand)
						{
							if (!isMute)
							{	
								sc = hitground.play(0, 1);
								//修改音量为一半
								st.volume = 0.3;
								sc.soundTransform = st;
							}
							
						}
						isOnLand = true;
					}
					
				}
				//判断背景场景是否存在
				if (Bg)
				{
					var num:int = Bg.numChildren;
					
					for (var j:int = 0; j < num; j++)
					{
						if (Bg.getChildAt(j) == null)
						{
							continue;
						}
						//判断player是否碰到bg内的child
						if (mPlayer.hitTestObject(Bg.getChildAt(j)))
						{
							//缩小碰撞范围，因为player有可能加速过快
							if ((mPlayer.y + mPlayer.height / 2 - 15) < (Bg.getChildAt(j).y + 5))
							{
								
								hit = true;
								if (!isOnLand)
								{
									if (!isMute)
									{
										sc = hitground.play(0, 1);
										//修改音量为一半
										st.volume = 0.3;
										sc.soundTransform = st;
									}
								}
								isOnLand = true;
							}
						}
					}
				}
				
				if (hit)
				{//如果在以上判断中，hit 为true，把向上的速度置0
					Vy = 0;
					isjump = false;
						//isOnLand = true;
				}
				else
				{//没有碰到任何东西，模拟重力，下降，Vy速度越来越快
					Vy += 0.3;
					mPlayer.y += Vy;
					
				}
				
			}
			else
			{//在跳高，则模拟重力，Vy在不断减少，知道减到为0再把跳高状态置false
				Vy -= 0.3;
				mPlayer.y -= Vy;
				//在跳高的过程中，需要不断判断头顶是否会碰到东西，碰到则需要把Vy置0，isJump置false
				if (Bg)
				{
					var num1:int = Bg.numChildren;
					
					for (var j1:int = 0; j1 < num1; j1++)
					{
						if (Bg.getChildAt(j1) == null)
						{
							continue;
						}
						if (mPlayer.hitTestObject(Bg.getChildAt(j1)))
						{
							isjump = false;
							hit = false;
							if (!isMute)
							{
								sc = hitground.play(0, 1);
								
								st.volume = 0.3;
								sc.soundTransform = st;
							}
							mPlayer.y -= Vy;
							Vy = 0;
						}
					}
				}
				
				if ((Vy <= 0))
				{
					isjump = false;
				}
			}
			
			//左边缘检测
			if (mPlayer.x < 200 && keyObj[65])
			{
				if (bg.x <= -490)
				{
					Bg.x += 3;
					bg.x += 2;
				}else{
					mPlayer.x -= 3;
					if(mPlayer.x <= 0){
						mPlayer.x = 0;
					}
				}
			}
			else if (keyObj[65])
			{
				mPlayer.x -= 3;
			}
			
			//右边缘检测
			if (mPlayer.x > stage.stageWidth / 2 + 50 && keyObj[68])
			{
				if(bg.x>=-2150){
					Bg.x -= 3;
					bg.x -= 2;
				}else{
					mPlayer.x += 3;
					if(mPlayer.x >= stage.stageWidth){
						mPlayer.x = stage.stageWidth;
					}
				}
			}
			else if (keyObj[68])
			{
				mPlayer.x += 3;
				
			}
			
			//加速跑
			if (keyObj[16] && keyObj[68])
			{
				mPlayer.x += 6;
				if (mPlayer.x > stage.stageWidth - 50)
				{
					mPlayer.x = stage.stageWidth - 50;
				}
				
			}
			
			//加速跑
			if (keyObj[16] && keyObj[65])
			{
				mPlayer.x -= 6;
				
				if (mPlayer.x < 50)
				{
					mPlayer.x = 50;
				}
			}
			
			if (keyObj[32])
			{//判断是否着地，不着地之前，不能再跳
				if (isOnLand)
				{
					if (!isjump)
					{//判断是否在跳高的上升过程中
						Vy = 9;
						isOnLand = false;
						isjump = true;
					}
				}
			}
			
			if (!keyObj[65] && !keyObj[68])
			{//两个键都没有按
				
				isWalking = false;
				mPlayer.gotoAndPlay("stand");
			}
			else
			{
				if (!isWalking)
				{
					mPlayer.gotoAndPlay("walk");
				}
				
				isWalking = true;
			}
		}
		
		public function setKeyObj(keyObj:Object)
		{
			this.keyObj = keyObj;
		}
		
		public function PlayerHurt()
		{
			if (isGod)
			{
				//godTime.reset();
			}
			else
			{
				if (hp != 0)
				{
					hp--;
					isGod = true;
					var godTime:Timer = new Timer(100, 10);
					godTime.addEventListener(TimerEvent.TIMER, flashPlayer); //闪烁
					godTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishGod);//取消无敌
					godTime.start();
				}
			}
		}
		
		//令角色闪烁
		private function flashPlayer(e:TimerEvent)
		{
			if (mPlayer.visible)
			{
				mPlayer.visible = false;
			}
			else
			{
				mPlayer.visible = true;
			}
		}
		
		private function finishGod(e:TimerEvent)
		{
			mPlayer.visible = true;
			isGod = false;
		}
		
		public function GetPlayerHp():int
		{
			return hp;
		}
		
		public function SetPlayerHp(Hp:int)
		{
			hp = Hp;
		}
	
	}

}