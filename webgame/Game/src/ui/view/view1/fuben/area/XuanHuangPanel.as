package ui.view.view1.fuben.area
{
	import common.utils.clock.GameClock;
	
	import flash.display.MovieClip;
	
	import netc.DataKey;
	
	import engine.support.IPacket;
	import nets.packets.PacketSCXuanHuangUpdate;
	
	import common.utils.CtrlFactory;
	
	import ui.base.mainStage.UI_index;
	
	import common.managers.Lang;
	import world.WorldEvent;

	public class XuanHuangPanel
	{
		private var time:int;
		private var mc:MovieClip;
		
		private static var _instance : XuanHuangPanel = null;
		
		public static function get instance() : XuanHuangPanel {
			if (null == _instance)
			{
				_instance=new XuanHuangPanel();
				_instance.mc = UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		
		public function XuanHuangPanel()
		{
			
		}
		
		public function init():void{
			DataKey.instance.register(PacketSCXuanHuangUpdate.id,SCXuanHuangUpdate);
			
			//mc.gotoAndStop(2);
			mc.gotoAndStop(1);
			
			this.setSmallMapVisible(true);
			//this.setSmallMapVisible(false);
			
		}
		
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible = value;
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			if(value)
			{
				if(null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(UI_index.indexMC_mrt_buttonArr!=null&&null == UI_index.indexMC_mrt_buttonArr.parent)
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
		
		
		
		private function SCXuanHuangUpdate(p:IPacket) : void {
			var value:PacketSCXuanHuangUpdate = p as PacketSCXuanHuangUpdate;
			if(time==0){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				time = int(value.lefttime/1000);	
			}
		//	mc["txt_bo_ci"].text = value.curwave+"/"+value.maxwave;
		//	mc["txt_sha_guai"].text = value.curmonsternum+"/"+value.maxmonsternum;
		//	CtrlFactory.getUIShow().fillBar([mc["hp"]["zhedang"]],
		//		[value.curhp,value.maxhp]);
		}
		
		private function TimerCLOCK(e:WorldEvent) : void {
			time--;
			//mc["txt_sheng_shi"].text = getskillcolltime(time);
		}
		
		private function getskillcolltime(value:int):String{
			return int(value/60)+Lang.getLabel("pub_fen")+int(value%60)+Lang.getLabel("pub_miao");
		}
		
		public function leave():void
		{
			
			//
			if(null != mc)
			{
				mc.gotoAndStop(1);
			}
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			time = 0;
			
			//
			if(true == XuanHuangJiangLi.hasAndGetInstance()[0])
			{
				if(XuanHuangJiangLi.hasAndGetInstance()[1].isOpen)
				{
					XuanHuangJiangLi.hasAndGetInstance()[1].winClose();
				}			
			}
			
			//
			this.setSmallMapVisible(true);
			
			
			
		}
	}
}