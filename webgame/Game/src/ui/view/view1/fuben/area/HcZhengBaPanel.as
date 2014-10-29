package ui.view.view1.fuben.area
{
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_NpcResModel;
	
	import common.utils.clock.GameClock;
	
	import ui.view.view6.GameAlertNotTiShi;
	import ui.view.view6.GameAlert;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import netc.Data;
	import netc.DataKey;
	
	import engine.support.IPacket;
	
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view4.pkmatch.PKMatchPlayerInfo;
	
	import world.FileManager;
	import common.managers.Lang;
	import world.WorldEvent;
	
	public class HcZhengBaPanel
	{
		private var time:int;
		
		private var mc:MovieClip;
		
		private static var _instance : HcZhengBaPanel = null;
		
		public function HcZhengBaPanel()
		{
		}
		
		public static function get instance() : HcZhengBaPanel {
			if (null == _instance)
			{
				_instance=new HcZhengBaPanel();
				_instance.mc = UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		
		
		public function init():void{
			
			//
			this.setSmallMapVisible(false);		
	
		}	
		
		
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible = value;
			
			/*if(value)
			{
				if(null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(null == UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
				}			
				
				return;
			}
			
			if(!value)
			{
				if(null != UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(null != UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
				}				
				
			}*/
			
		}
		
		//private function TimerCLOCK(e:WorldEvent) : void 
		//{
			
			
		//}
		
		private function getskillcolltime(value:int):String
		{
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
			if(true == HcZhengBaJiangLi.hasAndGetInstance()[0])
			{
				if(HcZhengBaJiangLi.hasAndGetInstance()[1].isOpen)
				{
					HcZhengBaJiangLi.hasAndGetInstance()[1].winClose();
				}			
			}
			
			//
			this.setSmallMapVisible(true);
			
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}
