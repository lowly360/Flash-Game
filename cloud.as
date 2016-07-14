package 
{

	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	
	/**
	用于处理背景，云的添加，逻辑等
	**/
	public class cloud extends MovieClip
	{

		private var myTimer:Timer = new Timer(4000,30);

		public function cloud()
		{
			myTimer.addEventListener(TimerEvent.TIMER,addCloud);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,resetTimer);
			myTimer.start();
		}

		private function resetTimer(e:TimerEvent):void
		{

			myTimer.stop();
			myTimer = new Timer(4000,30);
			myTimer.addEventListener(TimerEvent.TIMER,addCloud);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,resetTimer);
			myTimer.start();
		}

		private function addCloud(e:TimerEvent):void
		{
			//添加云到舞蹈上
			var kind:int = Math.random() * 4;
			var cloudY:int =Math.random()*(100)+10;
			switch (kind)
			{
				case 1 :
					var mc1:cloud1 = new cloud1();
					mc1.x = 900;
					mc1.y = cloudY;
					mc1.addEventListener(Event.ENTER_FRAME,flycloud);
					addChild(mc1);
					break;
				case 2 :
					var mc2:cloud2 = new cloud2();
					mc2.x = 900;
					mc2.y = cloudY;
					mc2.addEventListener(Event.ENTER_FRAME,flycloud);
					addChild(mc2);
					break;
				case 3 :
					var mc3:cloud3 = new cloud3();
					mc3.x = 900;
					mc3.y = cloudY;
					mc3.addEventListener(Event.ENTER_FRAME,flycloud);
					addChild(mc3);
					break;
				case 4 :
					var mc4:cloud4= new cloud4();
					mc4.x = 900;
					mc4.y = cloudY;
					mc4.addEventListener(Event.ENTER_FRAME,flycloud);
					addChild(mc4);
					break;
			}

		}

		private function flycloud(e:Event):void
		{//var vx:int = Math.random()*3;
			var mc:MovieClip = e.target as MovieClip;
			mc.x -=  1.5;
			if (mc.x < -100)
			{
				if (this.contains(mc))
				{
					mc.removeEventListener(Event.ENTER_FRAME,flycloud);
					this.removeChild(mc);
				}
			}

		}

	}

}