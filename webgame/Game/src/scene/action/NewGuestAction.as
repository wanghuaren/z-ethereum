package scene.action
{
	import common.utils.clock.GameClock;
	
	import netc.Data;
	
	import ui.base.renwu.MissionMain;
	
	import world.WorldEvent;

	public class NewGuestAction
	{
		
		public static const ON_IDLE_TIME:int  = 15;//
		
		public function NewGuestAction()
		{
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,idleSecAdd1);
		}
		
		
		public function idleSecAdd1(e:WorldEvent):void
		{
			if(null == Data.myKing.king)
			{
				return;
			}
		
			Data.idleTime.IdleByNewGuestAdd();
				
		}
		
		public function AutoOn(ms:int):void
		{
			if(null == Data.myKing.king)
			{
				return;
			}
			//自动任务是否开启
//						return;
			var idleSec:int = Data.idleTime.idleSecByNewGuest;
			
			if(idleSec >=  ON_IDLE_TIME)
			{
				Data.idleTime.syncByClearIdleNewGuest();
				MissionMain.instance.showMissionTip();

			}
		
		}
		
	}
}

