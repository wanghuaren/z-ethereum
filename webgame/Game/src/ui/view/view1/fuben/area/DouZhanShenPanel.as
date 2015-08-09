package ui.view.view1.fuben.area
{
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import flash.display.MovieClip;
	
	import netc.DataKey;
	
	import nets.packets.PacketSCMoTianWanJieUpdate;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	
	import world.FileManager;
	import world.WorldEvent;
	
	public class DouZhanShenPanel
	{
		private var time:int;
		private var mc:MovieClip;
		
		public var instance_type:int;
		
		private static var _instance : DouZhanShenPanel = null;
		
		public static function get instance() : DouZhanShenPanel {
			if (null == _instance)
			{
				_instance=new DouZhanShenPanel();
				_instance.mc = UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		
		public function DouZhanShenPanel()
		{
			time = 0;
		}
		
		
		public function init(instance_type_:int):void{
			instance_type = instance_type_;
			DataKey.instance.register(PacketSCMoTianWanJieUpdate.id,CMoTianWanJieUpdate);
			mc.gotoAndStop(6);
			//UI_index.indexMC["mrt"]["smallmap"].visible = false;
			this.setSmallMapVisible(false);
		}
		
		public function setSmallMapVisible(value:Boolean):void
		{
			return;
			if(400 == instance_type && 
				401 == instance_type &&
				402 == instance_type &&
				403 == instance_type &&
				404 == instance_type &&
				405 == instance_type &&
				406 == instance_type &&
				407 == instance_type &&
				408 == instance_type)
			{				
				UI_index.indexMC_mrt["missionMain"].visible = true;
			}else
			{
				//UI_index.indexMC_mrt["missionMain"].visible = value;
			}
			
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			
			if(value)
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
				
			}
		
		}
		
		public function CMoTianWanJieUpdate(p:PacketSCMoTianWanJieUpdate):void
		{
			
			if(time==0){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				time = int(p.lefttime/1000);	
			}
			
						
			var m:Pub_NpcResModel = XmlManager.localres.getNpcXml.getResPath(p.npcid) as Pub_NpcResModel;
			mc["king_name"].text = m.npc_name;
//			mc["uil"].source = FileManager.instance.getHeadIconXById(m.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(m.res_id));	
			CtrlFactory.getUIShow().fillBar([mc["hp"]["zhedang"]],
				[p.curhp,p.maxhp]);
			
		
		}
		
		
		
		
		
		
		
		
		
		private function TimerCLOCK(e:WorldEvent) : void {
			time--;
			mc["txt_sheng_shi"].text = getskillcolltime(time);
		}
		
		private function getskillcolltime(value:int):String{
			return int(value/60)+Lang.getLabel("pub_fen")+int(value%60)+Lang.getLabel("pub_miao");
		}
		
		public function leave():void
		{
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			
			//
			DataKey.instance.remove(PacketSCMoTianWanJieUpdate.id,CMoTianWanJieUpdate);
			
			if(null != mc)
			{
				mc.gotoAndStop(1);
			}
		
			time = 0;
			
			
			
			//
			this.setSmallMapVisible(true);
			
		}
		
		
		
		
	}
}