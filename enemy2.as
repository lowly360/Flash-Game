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
	public class enemy2 extends MovieClip
	{
		private var en:enemy_2 = new enemy_2();
		private var isJump:Boolean = false;
		private var isLeft = true;
		private var v:int;

		private var hp:int = 2;

		private var isAngry:Boolean = false; //是否愤怒

		public function enemy2()
		{	v = Math.random() * 3 + 1;
			en.x = Math.random() * 850 + 50;
			en.y = -50;
			addChild(en);
		}

		public function enemy2Move(px:int,py:int)
		{
			if (px!=en.x && py!=en.y)
			{
				if (px>en.x)
				{
					en.x +=  v;
					en.scaleX = -1;
				}

				if (px<en.x)
				{
					en.x -=  v;
					en.scaleX = 1;
				}
				if (py<en.y)
				{
					en.y -=  v;
				}

				if (py>en.y)
				{
					en.y +=  v;
				}
			}
		}

		public function enemy2Hp()
		{
			hp--;
		}

		public function GetHp():int
		{
			return hp;
		}
		
	}
}