package ui.view.view1.fuben.area
{
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import netc.DataKey;
	
	import nets.packets.PacketSCPkPlayerInfo;
	import nets.packets.PacketSCPlayerPkStateInfo;
	
	import scene.action.hangup.GamePlugIns;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.view.view4.pkmatch.PKMatchPlayerInfo;
	
	import world.FileManager;
	import world.WorldEvent;
	
	public class PkPanel
	{
		private var time:int;
		
		private var mc:MovieClip;
		
		private static var _instance : PkPanel = null;
		
		public function PkPanel()
		{
		}
		
		public static function get instance() : PkPanel {
			if (null == _instance)
			{
				_instance=new PkPanel();
				_instance.mc = UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		
		
		public function init():void{
			
			DataKey.instance.register(PacketSCPlayerPkStateInfo.id,pkStateInfoHandler);
			DataKey.instance.register(PacketSCPkPlayerInfo.id,pkBloodBarHandler);
			
			//
			mc.gotoAndStop(5);
			
			//
			this.setSmallMapVisible(false);		
			
			//
			PKMatchPlayerInfo.getInstance().open(true,false);
			
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			
			//
			//mc.addEventListener(MouseEvent.CLICK,clcikHander);
		}
		
		/*private function clcikHander(e:MouseEvent):void
		{
			
			switch(e.target.name)
			{
				case "yuanbao":					
					
					break;				
			}
		}*/
		
		public function setSmallMapVisible(value:Boolean):void
		{
			if(null != UI_index.indexMC_mrt && null != UI_index.indexMC_mrt["missionMain"]){
			UI_index.indexMC_mrt["missionMain"].visible = value;
			}
			
			if(value)
			{
				if(null != UI_index.indexMC_mrt_smallmap && null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(null != UI_index.indexMC_mrt_buttonArr && null == UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
				}			
				
				return;
			}
			
			if(!value)
			{
				if(null != UI_index.indexMC_mrt_smallmap && null != UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(null != UI_index.indexMC_mrt_buttonArr && null != UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
				}				
				
			}
			
		}
		
		private function TimerCLOCK(e:WorldEvent) : void 
		{
			if(time > 0)
			{
				time--;
				PKMatchPlayerInfo.getInstanceMc()["txtDaoJiShi"].text = getskillcolltime(time);
			}
			
			if(time == 0)
			{
				PKMatchPlayerInfo.getInstanceMc()["txtDaoJiShi"].text = getskillcolltime(time);
			}
			
			//
			if(GamePlugIns.getInstance().running)
			{
				//挂机中...
				if(mc.currentFrame == 5)
				{
					mc["btnPkGuaJi"].label = Lang.getLabel("50013_PanelJiangLi");//"取消挂机";
				}
				
			}
			else
			{
				//没有挂机
				if(mc.currentFrame == 5)
				{
					mc["btnPkGuaJi"].label = Lang.getLabel("50014_PanelJiangLi");//"开启挂机";
				}
			}
			
		}
		
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
		
		public function pkBloodBarHandler(p:PacketSCPkPlayerInfo):void
		{
			this.time = p.last_time;
			
			var p1:int = p.player1;
			var pet1:int = p.playerpet1;
			
			var p2:int = p.player2;
			var pet2:int = p.playerpet2;

			//check
			if(p1 <= 0)
			{
				p1 = 1;
			}			
			
			if(p1 >= 100)
			{
				p1 = 100;
			}
			
			//p1:太已 ->蓝 ->right
			PKMatchPlayerInfo.getInstanceMc()["hp_right_0"].gotoAndStop(p1);
			
				
			//
			if(pet1 <= 0)
			{
				pet1 = 1;
			}			
			
			if(pet1 >= 100)
			{
				pet1 = 100;
			}
			
			PKMatchPlayerInfo.getInstanceMc()["hp_right_1"].gotoAndStop(pet1);
			
			//
			if(p2 <= 0)
			{
				p2 = 1;
			}			
			
			if(p2 >= 100)
			{
				p2 = 100;
			}
			
			PKMatchPlayerInfo.getInstanceMc()["hp_left_0"].gotoAndStop(p2);
			
			
			//
			if(pet2 <= 0)
			{
				pet2 = 1;
			}			
			
			if(pet2 >= 100)
			{
				pet2 = 100;
			}
			
			PKMatchPlayerInfo.getInstanceMc()["hp_left_1"].gotoAndStop(pet2);
		}
		
		public function pkStateInfoHandler(p:PacketSCPlayerPkStateInfo):void
		{
			
			refreshNameAndHeadPhoto(p.p1name,
															p.p1icon,
															p.pet1name,
															p.pet1id,
															
															p.p2name,
															p.p2icon,
															p.pet2name,
															p.pet2id);
			
		}
		
		private function refreshNameAndHeadPhoto(p1name:String,
																					   p1icon:int,
																					   pet1name:String,
		                                                                               pet1id:int,
																					   
		                                                                               p2name:String,
		                                                                               p2icon:int,
		                                                                               pet2name:String,
		                                                                               pet2id:int):void
		{
		
			//p1:太已 ->蓝 ->right
			PKMatchPlayerInfo.getInstanceMc()["txtPlayerNameRight"].text = p1name;
//			PKMatchPlayerInfo.getInstanceMc()["playerHeadRight"].source = FileManager.instance.getHeadIconPById(p1icon);
			ImageUtils.replaceImage(PKMatchPlayerInfo.getInstanceMc() as DisplayObjectContainer,PKMatchPlayerInfo.getInstanceMc()["playerHeadRight"],FileManager.instance.getHeadIconPById(p1icon));
			
			PKMatchPlayerInfo.getInstanceMc()["txtPetNameRight"].text = pet1name;
//			PKMatchPlayerInfo.getInstanceMc()["petHeadRight"].source = FileManager.instance.getHeadIconById(pet1id);
			ImageUtils.replaceImage(PKMatchPlayerInfo.getInstanceMc() as DisplayObjectContainer,PKMatchPlayerInfo.getInstanceMc()["petHeadRight"],FileManager.instance.getHeadIconPById(pet1id));
			
			//
			PKMatchPlayerInfo.getInstanceMc()["txtPlayerNameLeft"].text = p2name;
//			PKMatchPlayerInfo.getInstanceMc()["playerHeadLeft"].source = FileManager.instance.getHeadIconPById(p2icon);
			ImageUtils.replaceImage(PKMatchPlayerInfo.getInstanceMc() as DisplayObjectContainer,PKMatchPlayerInfo.getInstanceMc()["playerHeadLeft"],FileManager.instance.getHeadIconPById(p2icon));
			
			PKMatchPlayerInfo.getInstanceMc()["txtPetNameLeft"].text = pet2name;
//			PKMatchPlayerInfo.getInstanceMc()["petHeadLeft"].source = FileManager.instance.getHeadIconById(pet2id);
			ImageUtils.replaceImage(PKMatchPlayerInfo.getInstanceMc() as DisplayObjectContainer,PKMatchPlayerInfo.getInstanceMc()["petHeadLeft"],FileManager.instance.getHeadIconPById(pet2id));			
			
		}
		
		
		
		
		
		
		public function leave():void
		{	
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			
			if(null != mc)
			{
				mc.gotoAndStop(1);
			}
			
			time = 0;
			
			//
			if(true == PkJiangLi.hasAndGetInstance()[0])
			{
				if(PkJiangLi.hasAndGetInstance()[1].isOpen)
				{
					PkJiangLi.hasAndGetInstance()[1].winClose();
				}			
			}
			
			//
			this.setSmallMapVisible(true);
			
			PKMatchPlayerInfo.getInstance().winClose();
		}
		
		
		
		
		
		
		
		
		
	}
}