package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	   用于存储子弹的影片剪辑类，处理子弹逻辑
	 **/
	public class myBullet extends MovieClip
	{
		private var gun:MovieClip;
		private var Bg:MovieClip;
		private var Mc:Array;
		private var shoot:MovieClip;
		private var isMute:Boolean;
		
		private var bulletSound:Sound = new gun_vol;
		private var noBulletSound:Sound = new nobullet;
		private var reLoadSound:Sound = new reload;
		
		private var sc:SoundChannel = new SoundChannel();
		private var st:SoundTransform = new SoundTransform();
		
		private var bulletNum:int = 90;
		
		private var loadNum:int = 30;//弹夹
		
		public var isReload:Boolean = false;//是否正在装弹
		
		public function myBullet(gun:MovieClip, shoot:MovieClip, Mc:Array, Bg:MovieClip, isMute:Boolean)
		{
			//addEventListener(MouseEvent.CLICK, fire);
			this.gun = gun;
			this.shoot = shoot;
			this.Mc = Mc;
			this.Bg = Bg;
			this.isMute = isMute;
		
		}
		
		public function setIsMute(isMute){
			this.isMute = isMute;
		}
		
		public function getIsReloading():Boolean
		{
			return isReload;
		}
		
		//获取子弹数量
		public function getBulletNum():int
		{
			return bulletNum;
		}
		
		//获取弹夹数量
		public function getLoadNum():int
		{
			return loadNum;
		}
		
		//子弹装填
		public function bulletReload():void
		{
			if (!isReload)
			{
				isReload = true;//正在装填
				var reloadTimer:Timer = new Timer(500, 1);
				reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, addLoadNum);
				reloadTimer.start();
				
				if (!isMute)
				{
					sc = reLoadSound.play(0, 1);
					//修改音量为一半
					st.volume = 0.5;
					sc.soundTransform = st;
				}
			}
		}
		
		//倒计时完成后，装填完成
		private function addLoadNum(e:TimerEvent)
		{
			
			bulletNum -= 30;
			bulletNum += loadNum;
			loadNum = 30;
			isReload = false;
		}
		
		public function fire(e:MouseEvent):void
		{
			if (bulletNum > 0)
			{
				
				if (!isReload && loadNum > 0)
				{
					if (!isMute)
					{
						sc = bulletSound.play(0, 1);
						//修改音量为一半
						st.volume = 0.1;
						sc.soundTransform = st;
					}
					
					//弹夹内子弹数
					loadNum--;
					//如果弹夹子弹数为0，则需要装弹
					
					var flyx:Number;
					var flyy:Number;
					
					var bull:bullet = new bullet;
					
					if (e.stageX > gun.x)
					{
						bull.x = gun.x;
					}
					else
					{
						bull.x = gun.x;
					}
					bull.y = gun.y;
					//计算鼠标坐标与player坐标X，Y距离
					flyx = e.stageX - bull.x + shoot.width / 2;
					
					flyy = e.stageY - bull.y + shoot.height / 2;
					//根据计算出的距离，添加帧事件，计算角度，，确定方向，速度等
					bull.addEventListener(Event.ENTER_FRAME, function(m:Event)
					{
						bulletMove(m, flyx, flyy)
					});
					
					addChild(bull);
				}
				else
				{
					if (!isMute)
					{
						sc = noBulletSound.play(0, 1);
						//修改音量为一半
						st.volume = 0.3;
						sc.soundTransform = st;
						
					}
				}
			}
			else
			{
				if (!isMute)
				{
					sc = noBulletSound.play(0, 1);
					//修改音量为一半
					st.volume = 0.3;
					sc.soundTransform = st;
				}
			}
		}
		//添加子弹
		public function AddbulletNum(addNum:int){
			bulletNum += addNum;
		}
		
		//子弹移动逻辑
		private function bulletMove(m:Event, tx:Number, ty:Number):void
		{
			//计算角度
			var angle:Number = Math.atan2(Math.abs(ty), Math.abs(tx));
			var mc:MovieClip = m.target as MovieClip;
			
			//计算子弹水平速度,垂直速度
			var vy:Number = Math.abs(Math.sin(angle) * 20);
			var vx:Number = Math.abs(Math.cos(angle) * 20);
			
			//根据不同的位置,确定速度的方向
			if ((tx > 0))
			{
				mc.x += vx;
				mc.scaleX = 1;
				if (ty>0)
				{
					mc.rotation = angle*180/Math.PI + 90;
				}
				else
				{
					mc.rotation = (90 - angle*180/Math.PI);
				}
			}
			else
			{
				mc.x -= vx;
				mc.scaleX = -1;
				if (ty>0)
				{
					mc.rotation =  -  (angle*180/Math.PI + 90);
				}
				else
				{
					mc.rotation =  -  (90 - angle*180/Math.PI);
				}
			}
			
			if ((ty > 0))
			{
				mc.y += vy;
				
			}
			else
			{
				mc.y -= vy;
			}
			//判定子弹是否或场景碰撞
			for (var i:int = 0; i < 1; i++)
			{
				if (mc.hitTestObject(Mc[i]))
				{
					mc.removeEventListener(Event.ENTER_FRAME, bulletMove);
					
					if (this.contains(mc))
					{
						this.removeChild(mc);
					}
				}
				
			}
			//判断子弹是否和场景碰撞
			if (Bg)
			{
				var num:int = Bg.numChildren;
				for (var j:int = 0; j < num; j++)
				{
					if (mc.hitTestObject(Bg.getChildAt(j)))
					{
						if (this.contains(mc))
						{
							this.removeChild(mc);
						}
					}
				}
			}
			//判断子弹是否飞出屏幕,如果是则删除子弹
			if (mc.x > stage.stageWidth || mc.x < 0)
			{
				mc.removeEventListener(Event.ENTER_FRAME, bulletMove);
				if (this.contains(mc))
				{
					this.removeChild(mc);
				}
			}
			//判断子弹是否飞出屏幕,如果是则删除子弹
			if (mc.y > stage.stageHeight || mc.y < 0)
			{
				mc.removeEventListener(Event.ENTER_FRAME, bulletMove);
				
				if (this.contains(mc))
				{
					this.removeChild(mc);
				}
			}
		}
	}
}