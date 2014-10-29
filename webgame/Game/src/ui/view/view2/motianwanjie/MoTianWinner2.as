package ui.view.view2.motianwanjie
{
	import common.utils.clock.GameClock;
	import netc.Data;
	import nets.packets.PacketCSEntryTower;
	import nets.packets.PacketCSPlayerLeaveInstance;
	import ui.frame.UIWindow;
	import world.WorldEvent;

	public class MoTianWinner2 extends UIWindow
	{
		public static const DAOJISHI:int=30;
		private var _currDaoJiShi:int;
		private static var _instance:MoTianWinner2;
		public var curStar:int;
		public var curStep:int;

		/**
		 * 	@param must 是否必须
		 */
		public static function instance():MoTianWinner2
		{
			if (null == _instance)
			{
				_instance=new MoTianWinner2();
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

		public function MoTianWinner2(d:Object=null)
		{
			//blmBtn=3;
			super(getLink("pop_motian_winner2"), d);
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
				case "btnNext":
					//
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var nextBossId:int=MoTianWanJie2.getNextBossId("Npc" + Data.moTian.npcId.toString());
					var cs1:PacketCSEntryTower=MoTianWanJie2.mcDClick("Npc" + nextBossId.toString());
					if (null != cs1)
					{
						this.uiSend(cs1);
					}
					this.winClose();
					break;
				case "btnOther":
					MoTianWanJie.instance().open(true);
					break;
				case "btnExit":
					//
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
					var vo3:PacketCSPlayerLeaveInstance=new PacketCSPlayerLeaveInstance();
					vo3.flag=1;
					uiSend(vo3);
					this.winClose();
					break;
			}
		}

		public function TimerCLOCK(e:WorldEvent):void
		{
			_currDaoJiShi--;
			mc["txtDaoJiShi"].text=_currDaoJiShi.toString();
			if (0 == _currDaoJiShi)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
				this.mcHandler(mc["btnExit"]);
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
