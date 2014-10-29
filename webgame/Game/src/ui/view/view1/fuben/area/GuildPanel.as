package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	
	import common.utils.clock.GameClock;
	
	import ui.view.view6.GameAlertNotTiShi;
	import ui.view.view6.GameAlert;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.fuben.FuBenEvent;
	import model.fuben.FuBenModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCGetGuildFightInfoUpdate2;
	
	import engine.support.IPacket;
	import nets.packets.PacketSCGetGuildFightInfoUpdate;
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.MissionMain;
	import ui.view.view1.shezhi.SysConfig;
	
	import world.FileManager;
	import common.managers.Lang;
	import world.WorldEvent;
	
	public class GuildPanel
	{
		private var time:int;
		
		public function get mc():MovieClip
		{
			return null;
			//return UI_index.indexMC_zhengba;
		}
		
		private static var _instance : GuildPanel = null;
		
		public static function get instance() : GuildPanel 
		{
			if (null == _instance)
			{
				_instance=new GuildPanel();			
			}
			return _instance;
		}
		
		public function GuildPanel()
		{
			
		}
		
		public function init():void
		{
			//掌教至尊活动信息刷新
			DataKey.instance.register(PacketSCGetGuildFightInfoUpdate.id,guildUpdate);
			
			
			//for(var j:int=0;j<4;j++)
			//{
			//	mc["txt_flag_" + j.toString()].htmlText = "";
			//	mc["mc_flag_" + j.toString()].visible = false;
			// mc["mc_flag_" + j.toString()].gotoAndStop(1);
				
			//}
			
			//
			//if(null == UI_index.indexMC_zhengba.parent)
			//{
			//	UI_index.indexMC.addChild(UI_index.indexMC_zhengba);
			//	UI_index.indexMC.stage.dispatchEvent(new Event(Event.RESIZE));
			//}
			
			//
			this.setSmallMapVisible(false);
			
			
			
		}
		
		
		public function guildUpdate(p:PacketSCGetGuildFightInfoUpdate2):void
		{
			MissionMain.instance.m_fubenModel.callbackData_GuildFightUpd = p;
						
			var _e:FuBenEvent = new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
			_e.sort = FuBenEvent.FU_BEN_EVENT_UPDATA;
			FuBenModel.getInstance().dispatchEvent(_e);
			
			//
			
			
			
		
		}
		
		public function getskillcolltime(value:int):String
		{
			value = value / 1000;
			var m:int = int(value/60);
			var s:int = int(value%60);
			
			var m2:String = m.toString();
			
			if(m2.length == 1)
			{
				m2 = "0" + m2;
			}
			
			var s2:String = s.toString();
			
			if(s2.length == 1)
			{
				s2 = "0"+ s2;
			}
			
			
			return m2 +":"+s2;
		}		
		
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible = value;
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			
//			if(value)
//			{
//				if(null == UI_index.indexMC_mrt_smallmap.parent)
//				{
//					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
//				}
//				
//				if(null == UI_index.indexMC_mrt_buttonArr.parent)
//				{
//					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
//				}			
//				
//				return;
//			}
//			
//			if(!value)
//			{
//				if(null != UI_index.indexMC_mrt_smallmap.parent)
//				{
//					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
//				}
//				
//				if(null != UI_index.indexMC_mrt_buttonArr.parent)
//				{
//					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
//				}				
//				
//			}
			
		}
		
		//private function TimerCLOCK(e:WorldEvent) : void 
		//{
			
		
		//}
		
		
		public function leave():void
		{
			//
			//GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			
			if(null != mc)
			{
				mc.gotoAndStop(1);
			}
			
			time = 0;
			
			//			
			//if(null != UI_index.indexMC_zhengba.parent)
			//{
			//	UI_index.indexMC_zhengba.parent.removeChild(UI_index.indexMC_zhengba);
			
			//	UI_index.indexMC_zhengba["mc_flag_0"].gotoAndStop(1);			
			//	UI_index.indexMC_zhengba["mc_flag_1"].gotoAndStop(1);				
			//	UI_index.indexMC_zhengba["mc_flag_2"].gotoAndStop(1);				
			//	UI_index.indexMC_zhengba["mc_flag_3"].gotoAndStop(1);
				
			//}			
			
			//
			if(true == GuildJiangLi.hasAndGetInstance()[0])
			{
				if(GuildJiangLi.hasAndGetInstance()[1].isOpen)
				{
					GuildJiangLi.hasAndGetInstance()[1].winClose();
				}			
			}
			
			//
			//this.setSmallMapVisible(true);
			
			
		}
		
		
		
		
	}
}