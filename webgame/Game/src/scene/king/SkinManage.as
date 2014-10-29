package scene.king
{
	import common.utils.clock.GameClock;
	import common.utils.clock.GameMainTimer;

	import flash.events.TimerEvent;

	import engine.load.GamelibS;
	import engine.load.Loadres;

	import scene.manager.SceneManager;

	import world.WorldEvent;


	/**
	 * @author shuiyue
	 * @create 2010-9-15
	 */
	public class SkinManage
	{
		private static var RES:Object={};
		public static var FuncList:Array=[];

		//public static function timerStop():void
		//{
		//现改为enterFrame
		//}

		public static function get run():Boolean
		{
			if (FuncList.length > 0)
			{
				return true;
			}

			return false;
		}
	
		//private static function TIMER_HAND(e : TimerEvent) : void {
		public static function TIMER_HAND(e:WorldEvent=null):void
		{

			if (FuncList.length > 0)
			{
				for (var s:* in FuncList)
				{
					var names0:String=FuncList[s]["names_0"];
					var names1:String=FuncList[s]["names_1"];

					var RecvFunc:Function=FuncList[s]["RecvFunc"];

					if (GamelibS.hasOwnSWF(names0) && GamelibS.getXMLWithAppplicationDomain(names1))
					{
						if (null != RecvFunc)
						{
							RecvFunc();
						}
						else{
							trace("RecvFunc null");
						}

						//
						FuncList.splice(s, 1);

						//优化，如果生成skin,即movie，造成游戏低于正常帧频
						//为避免卡得太历害，等待下一次时钟到来
//						if (SceneManager.instance.isSlowFrameRateHyperDeep)
//						{
//							break;
//						}
					}

				} //end for

			}
			//else 
			//{
			//timer.stop();
			//	timerStop();
			//}

		}

		public static function addload(names0:String, names1:String):void
		{
			RES[names0]=true;
			RES[names1]=true;
		}

		/**
		 * 与addload对应
		 */
		public static function delload(names:String):void
		{
			if (GamelibS.hasOwnSWF(names))
			{
				return;
			}

			delete RES[names];
		}

		public static function isLoad(names0:String, names1:String):Boolean
		{

			return RES.hasOwnProperty(names0) || RES.hasOwnProperty(names1);
		}

		public static function addRecvComplete(names0:String, names1:String, RecvFunc:Function):void
		{
			FuncList.push({names_0: names0, names_1: names1, RecvFunc: RecvFunc});

		}

		public static function RemoveAll():void
		{

			//以免初次进场景时，又马上切换地图出现问题
			if (-1 != SceneManager.instance.oldMapId2)
			{
				RES={};
				FuncList=[];
					//timer.stop();
					//timerStop();
			}
		}

		public static function getFileName(skinurl:String):String
		{

//			return Loadres.getFileName(skinurl).toLowerCase();
			return Loadres.getFileName(skinurl);
		}
	}
}
