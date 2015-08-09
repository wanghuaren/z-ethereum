package ui.view.view2.motianwanjie
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import flash.display.MovieClip;
	import netc.Data;
	import netc.DataKey;
	import nets.packets.PacketCSEntryTower;
	import nets.packets.PacketSCMoTianWanJieUpdate;
	import ui.base.mainStage.UI_index;
	import world.WorldEvent;
	public class MoTianPanel
	{
		private var time:int;
		private var mc:MovieClip;
		private static var _instance:MoTianPanel=null;
		public static function get instance():MoTianPanel
		{
			if (null == _instance)
			{
				_instance=new MoTianPanel();
				_instance.mc=UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		public function MoTianPanel()
		{
			time=0;
		}
		public function init():void
		{
			DataKey.instance.register(PacketSCMoTianWanJieUpdate.id, CMoTianWanJieUpdate);
			mc.gotoAndStop(4);
			//UI_index.indexMC["mrt"]["smallmap"].visible = false;
			this.setSmallMapVisible(false);
		}
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible=value;
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			if (value)
			{
				if (null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				if (UI_index.indexMC_mrt_buttonArr != null && null == UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
				}
				return;
			}
			if (!value)
			{
				if (null != UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
				}
				if (UI_index.indexMC_mrt_buttonArr != null && null != UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
				}
			}
		}
		public function CMoTianWanJieUpdate(p:PacketSCMoTianWanJieUpdate):void
		{
			if (time == 0)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
				time=int(p.lefttime / 1000);
			}
			var npcId:int=Data.moTian.npcId;
			if (0 == npcId)
			{
				npcId=p.npcid;
			}
			if (0 == npcId)
			{
				return;
			}
			var m:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(npcId) as Pub_NpcResModel;
			mc["mo_king_name"].text=m.npc_name;
			var x:PacketCSEntryTower=MoTianWanJie2.mcDClick("Npc" + npcId.toString());
			var lv:int=x.level + 1;
			var step:int=x.step + 1;
			CtrlFactory.getUIShow().fillBar([mc["hp"]["zhedang"]], [p.curhp, p.maxhp]);
		}
		private function TimerCLOCK(e:WorldEvent):void
		{
			time--;
			if (mc != null)
				mc["txt_sheng_shi"].text=getskillcolltime(time);
		}
		private function getskillcolltime(value:int):String
		{
			return int(value / 60) + Lang.getLabel("pub_fen") + int(value % 60) + Lang.getLabel("pub_miao");
		}
		public function leave():void
		{
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, TimerCLOCK);
			if (null != mc)
			{
				mc.gotoAndStop(1);
			}
			time=0;
			//
			if (MoTianFailed.hasInstance())
			{
				if (MoTianFailed.instance().isOpen)
				{
					MoTianFailed.instance().winClose();
				}
			}
			if (MoTianWinner.hasInstance())
			{
				if (MoTianWinner.instance().isOpen)
				{
					MoTianWinner.instance().winClose();
				}
			}
			if (MoTianWinner2.hasInstance())
			{
				if (MoTianWinner2.instance().isOpen)
				{
					MoTianWinner2.instance().winClose();
				}
			}
			//
			this.setSmallMapVisible(true);
		}
	}
}
