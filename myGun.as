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
	用于处理枪逻辑
	**/
	public class myGun extends MovieClip
	{
		private var mGun:Gun;
		public function myGun(playerX:Number,playerY:Number)
		{
			// constructor code
			mGun = new Gun();
			mGun.x = playerX;
			mGun.y = playerY;
			addChild(mGun);

		}

		public function setGunXY(X:Number,Y:Number):void
		{
			mGun.x = X;
			mGun.y = Y;
		}
		
		public function getGun():Gun{
			return mGun;
		}

		public function setGunRotate(e:MouseEvent,playerX:Number,playerY:Number,angle:Number):void
		{
			if (e.stageX > playerX)
			{
				mGun.scaleX = 1;

				//player.scaleX = 1;

				if (e.stageY > playerY)
				{
					mGun.rotation = angle + 90;
				}
				else
				{
					mGun.rotation = (90 - angle);

				}
			}
			else
			{
				mGun.scaleX = -1;
				//player.scaleX = -1;
				if (e.stageY > playerY)
				{
					mGun.rotation =  -  (angle + 90);
				}
				else
				{
					mGun.rotation =  -  (90 - angle);
				}
			}

		}

	}

}