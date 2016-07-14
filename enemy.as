package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	   用于存储敌人的影片剪辑类
	 **/
	public class enemy extends MovieClip
	{
		private var en:enemy1 = new enemy1();
		private var isJump:Boolean = false;
		private var isLeft = true;
		
		private var keyObj:Object = {};
		
		private var isAngry:Boolean = false;
		private var myTimer:Timer;
		
		private var hp:int = 3;
		
		public function enemy()
		{
			
			myTimer = new Timer((Math.random() * 2000 + 2000), int.MAX_VALUE);
			en.x = Math.random() * 500 + 200;
			en.y = 465;
			en.addEventListener(Event.ENTER_FRAME, enjump);
			myTimer.addEventListener(TimerEvent.TIMER, enemyMove);
			addChild(en);
			en.gotoAndStop("stand");
			myTimer.start();
		
		}
		
		public function isEnemyAngry(px:int, py:int):void
		{
			if (Math.abs(px - en.x) < 300 && py > 400)
			{
				if ((px - en.x) > 0)
				{
					isLeft = false;
					en.scaleX = -1;
				}
				else
				{
					isLeft = true;
					en.scaleX = 1;
				}
				
				isAngry = true;
			}
			else
			{
				isAngry = false;
			}
		}
		
		private function enjump(e:Event):void
		{
			
			if (isJump)
			{
				if (isLeft)
				{
					if (isAngry)
					{
						en.x -= 4;
					}
					else
					{
						en.x--;
					}
					
				}
				else
				{
					
					if (isAngry)
					{
						en.x += 4;
					}
					else
					{
						en.x++;
					}
				}
			}
		
		/**
		   if (en.x <= 10)
		   {
		   isLeft = false;
		   en.x = 15;
		   en.scaleX = -1;
		   }
		
		   if (en.x >= stage.stageWidth - 10)
		   {
		   isLeft = true;
		   en.x = stage.stageWidth - 10;
		   en.scaleX = 1;
		   }**/
		}
		
		public function setKeyObj(keyObj:Object)
		{
			this.keyObj = keyObj;
		}
		
		//舞台动，也跟着动
		public function isBgMove(px:int, py:int, bgx:int):void
		{
			
			//左边缘检测
			if (bgx <= -490)
			{
				if (px < 100 && keyObj[65])
				{
					en.x += 2;
				}
			}
			
			
			
			//右边缘检测
			if (bgx >= -2150)
			{
				if (px > stage.stageWidth / 2 + 50 && keyObj[68])
				{
					en.x -= 2;
				}
			}
		
		}
		
		private function enemyMove(e:TimerEvent):void
		{
			//var v:int = Math.random() * 2;
			if (!isJump)
			{
				en.gotoAndPlay("jump");
			}
			else
			{
				en.gotoAndStop("stand");
			}
			isJump = !isJump;
		}
		
		public function enemy2Hp()
		{
			hp--;
		
		}
		
		public function GetHp():int
		{
			return hp;
		}
		
		public function removeListener():void
		{
			en.removeEventListener(Event.ENTER_FRAME, enjump);
			myTimer.stop();
			myTimer.removeEventListener(TimerEvent.TIMER, enemyMove)
		}
	}
}