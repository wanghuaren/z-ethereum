package ui.view.view2.motianwanjie
{
	import common.utils.clock.GameClock;
	import netc.Data;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import nets.packets.PacketCSRelive;
	import ui.frame.UIWindow;
	import world.WorldEvent;

	public class MoTianFailed extends UIWindow
	{
		public static const DAOJISHI:int=30;
		private var _currDaoJiShi:int;
		private static var _instance:MoTianFailed;
		public var historyBlood:int;
		public var currBlood:int;

		/**
		 * 	@param must 是否必须
		 */
		public static function instance():MoTianFailed
		{
			if (null == _instance)
			{
				_instance=new MoTianFailed();
			}
			return _instance;
		}

		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false;
			}
			return true;
		}

		public function MoTianFailed(d:Object=null)
		{
			//blmBtn=3;
			super(getLink("pop_motian_failed"), d);
		}

		//面板初始化
		override protected function init():void
		{
			//super.sysAddEvent(mc_content,MouseEvent.MOUSE_OVER,overHandle);
			reset();
			setBlood(this.historyBlood, this.currBlood);
			//
		}

		public function reset():void
		{
			_currDaoJiShi=DAOJISHI;
			mc["txtDaoJiShi"].text="";
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			switch (target_name)
			{
				/*	case "btnRetry":
						//
						GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
						var cs1:PacketCSEntryTower = MoTianWanJie.mcDClick("Npc" + DataCenter.moTian.npcId.toString());
						if(null != cs1)
						{
							this.uiSend(cs1);
						}
						break;*/
				case "btnFuHuo":
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var cs1:PacketCSRelive=new PacketCSRelive();
					cs1.mode=2;
					uiSend(cs1);
					windowClose();
					winClose();
					break;
				case "btnExit":
					//
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
					windowClose();
					winClose();
					break;
			}
		}

		private function setBlood(historyBlood:int, currBlood:int):void
		{
			if (null != mc)
			{
				//失败
				var curStar:int=0;
				for (var k:int=1; k <= 5; k++)
				{
					if (curStar >= k)
					{
						mc["remarkStar" + k.toString()].gotoAndStop(1);
					}
					else
					{
						mc["remarkStar" + k.toString()].gotoAndStop(2);
					}
				}
				mc["historyBlood"].text=historyBlood.toString() + "%";
				mc["currBlood"].text=currBlood.toString() + "%";
				var zhanlizhi:int=Data.myKing.FightValue;
//				var ccz:PacketSCPetData2=Data.huoBan.getCurrentChuZhan();
//				if (ccz)
//				{
//					zhanlizhi+=ccz.FightValue;
//				}
				//mc["wo_zhanLi"].text = DataCenter.myKing.zhanLi.toString();
				mc["wo_zhanLi"].text=zhanlizhi.toString();
			}
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
		}

		public function TimerCLOCK(e:WorldEvent):void
		{
			_currDaoJiShi--;
			if (null != mc)
			{
				mc["txtDaoJiShi"].text=_currDaoJiShi.toString();
			}
			if (0 == _currDaoJiShi)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
				if (null != mc)
				{
					this.mcHandler({name: "btnExit"});
				}
				else
				{
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
				}
			}
		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
		}

		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}
