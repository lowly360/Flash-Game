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
	public class enemy3 extends MovieClip
	{
		private var en:enemy_3 = new enemy_3();
		
		private var v:int=10;

		private var hp:int = 1;
		
		private var isRuning:Boolean = false;


		public function enemy3()
		{
			
			en.x = 950;
			en.y = 0;
			addChild(en);
		}

		public function enemy3Move(py:int)
		{
			if(!isRuning)
			en.y=py;
			if(en.y!=0)
			{
					isRuning = true;
				}
			en.x-=v;
			
			
		}

		public function enemy3Hp()
		{
			hp--;
		}

		public function GetHp():int
		{
			return hp;
		}
		
	}
}
