package ui.view.view8
{
	import ui.base.login.Login;

	public class CheatChecker
	{

		private static const CHECK_ROUND:Number=0.95;
		public static const CHECK_DELAY:Number=3000;

		private static var _last:Number=0;
		//连续三次就被踢
		private static var error:int=0;

		public static function init():void
		{
			var _now:Number=new Date().time;
		}

		public static function check():void
		{
			var _now:Number=new Date().time;
			 
			if ((_now - _last) < (CHECK_DELAY * CHECK_ROUND))
			{

				trace("我用变速！我有罪！为了维护游戏公平性，请大家远离变速齿轮O(∩_∩)O");
//				Debug.log("我有罪！",true);
				error++;

				if (error >= 1)
				{
//					ServiceProxy.getInstance().ban()
					Login.instance.disConnect();
					error=0;
						//断开玩家的连接
				}else{
//					NetEventTrigger.getInstance().dispatchEvent(new NoticeNetEvent(NoticeNetEvent.NOTIFY_NOTICE,["0","3","休息，休息一下",""]));
				};
			}
			else
			{
				trace("我从良"+_last+":"+_now+":"+(_now - _last));
				error=0;
			}
			_last=_now;
		}

	}
}