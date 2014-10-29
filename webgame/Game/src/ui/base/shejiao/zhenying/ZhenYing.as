package ui.base.shejiao.zhenying
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import nets.packets.PacketCSCampList;
	import nets.packets.PacketCSCampSet;
	import nets.packets.PacketCWGetPkCamp;
	import nets.packets.PacketSCCampList;
	import nets.packets.PacketSCCampSet;
	import nets.packets.PacketWCGetPkCamp;
	
	import ui.frame.UIWindow;
	import ui.base.npc.mission.MissionNPC;
	import ui.base.renwu.MissionMain;
	import ui.view.view4.pkmatch.PKMatchWindow;
	
	
	/**
	 *	阵营
	 * andy 2011-12-13 
	 * fux 2012-4-13
	 */
	public class ZhenYing extends UIWindow
	{
		//private var zhenYingType:int=0;
		public var camp:int=0;
		
		
		private static var _instance:ZhenYing;		
		
		public function ZhenYing()
		{
			super(this.getLink("win_zhen_ying"));
		}
		
		public static function instance():ZhenYing
		{
			if(_instance==null){
				_instance=new ZhenYing();
			}
			return _instance;
		}
		
		//面板初始化
		override protected function init():void 
		{
			return;
			this.uiRegister(PacketSCCampSet.id,	CampSet);
			this.uiRegister(PacketSCCampList.id, CCampList);
			mc["zheng_effect"].mouseEnabled = false;
			mc["xie_effect"].mouseEnabled = false;
			//
//			mc["tip_Tai_Yi"].visible = false;
//			mc["tip_Tai_Yi"].mouseEnabled = mc["tip_Tai_Yi"].mouseChildren = false;
//			
//			mc["tip_Tong_Tian"].visible = false;
//			mc["tip_Tong_Tian"].mouseEnabled = mc["tip_Tong_Tian"].mouseChildren = false;
			//
			//mc["btnZhenYing2"].addEventListener(MouseEvent.MOUSE_OVER,btnXuanZe2_mouse_over);
			//mc["btnZhenYing2"].addEventListener(MouseEvent.MOUSE_OUT,btnXuanZe2_mouse_out);
			
			//不需要按钮进行侦听
			//(mc["btnXuanZe2"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER,btnXuanZe2_mouse_over);
			//(mc["btnXuanZe2"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT,btnXuanZe2_mouse_out);
			
			//
			//mc["btnZhenYing3"].addEventListener(MouseEvent.MOUSE_OVER,btnXuanZe3_mouse_over);
		//	mc["btnZhenYing3"].addEventListener(MouseEvent.MOUSE_OUT,btnXuanZe3_mouse_out);
			
			//不需要按钮进行侦听
			//(mc["btnXuanZe3"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER,btnXuanZe3_mouse_over);
			//(mc["btnXuanZe3"] as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT,btnXuanZe3_mouse_out);
			super.sysAddEvent(mc,MouseEvent.MOUSE_OVER,mouseOver);
			super.sysAddEvent(mc,MouseEvent.MOUSE_OUT,mouseOver);
		}
		private function mouseOver(me:MouseEvent):void{
			var name:String=me.target.name;
			switch(me.type){
				case MouseEvent.MOUSE_OVER:
					trace(name)
					if(name=="tip_Tai_Yi"){
						mc["zheng_effect"].gotoAndStop(2);
					}
					if(name=="tip_Tong_Tian"){
						mc["xie_effect"].gotoAndStop(2);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(name.indexOf("")==0&&type==1){
						//this.strongCompare(mc["mc_result"].data,false);
					}
					if(name=="tip_Tai_Yi"){
						mc["zheng_effect"].gotoAndStop(1);
					}
					 if(name=="tip_Tong_Tian"){
						mc["xie_effect"].gotoAndStop(1);
					}
					break;
			}
		}
		public function btnXuanZe2_mouse_over(e:MouseEvent):void
		{
			mc["tip_Tai_Yi"].visible = true;
		}
		
		public function btnXuanZe2_mouse_out(e:MouseEvent):void
		{
			mc["tip_Tai_Yi"].visible = false;
		}		
		
		public function btnXuanZe3_mouse_over(e:MouseEvent):void
		{			
			mc["tip_Tong_Tian"].visible = true;
		}
		
		public function btnXuanZe3_mouse_out(e:MouseEvent):void
		{
			mc["tip_Tong_Tian"].visible = false;			
		}
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{			
			super.mcHandler(target);
			
			switch (target.name)
			{
				case "btnZhenYing1":
					
					//随机1
					var client1:PacketCSCampSet = new PacketCSCampSet();
					client1.campid = 1;
					this.uiSend(client1);	
					
					//新手引导
					
					break;
				
				case "btnZhenYing2":
					
					//太乙2
					var client2:PacketCSCampSet = new PacketCSCampSet();
					client2.campid = 2;
					this.uiSend(client2);	
					
					break;
				
				case "btnZhenYing3":
					
					//通天3
					var client3:PacketCSCampSet = new PacketCSCampSet();
					client3.campid = 3;
					this.uiSend(client3);	
					
					break;
				
			}
			
			
			
		}
		
		
		public function CampSet(p:PacketSCCampSet):void
		{
			if (super.showResult(p))
			{	
				//成功选择阵营后自动关闭界面
				winClose();
			}
			else
			{
				//选择阵营后失败自动关闭界面
				winClose();
			}
			
		}
		
		
		
		
		public function CCampList(p:PacketSCCampList):void
		{
			if (super.showResult(p))
			{	
				
			}
			else
			{
				
			}
			
		}
		
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must,type);
		}
		
		override public function winClose():void
		{
			super.winClose();
			//2012-11-14 andy 关闭阵营，自动寻路
			MissionMain.instance.findPahtByTaskID(30100090);
			MissionNPC._instance.open();
		}
		
		override public function getID():int
		{
			return 1013;
		}
		
		
	}
}








//package ui.base
//{
//	import common.config.GameIni;
//	
//	import flash.display.MovieClip;
//	import flash.display.SimpleButton;
//	import flash.events.Event;
//	import flash.events.MouseEvent;
//	import flash.utils.setTimeout;
//	
//	
//	import nets.packets.PacketCSCampList;
//	import nets.packets.PacketCSCampSet;
//	import nets.packets.PacketCWGetPkCamp;
//	import nets.packets.PacketCWSelectPkCamp;
//	import nets.packets.PacketSCCampList;
//	import nets.packets.PacketSCCampSet;
//	import nets.packets.PacketWCGetPkCamp;
//	import nets.packets.PacketWCSelectPkCamp;
//	
//	import ui.frame.UIWindow;
//	import ui.base.mainStage.UI_index;
//	import ui.frame.WindowName;
//	import ui.base.renwu.MissionMain;
//	import ui.view.view4.pkmatch.PKMatchWindow;
//
//	/**
//	 *	阵营
//	 * andy 2011-12-13 
//	 * fux 2012-4-13
//	 * andy 2013-08-01 临时阵营【华山论剑】
//	 */
//	public class ZhenYing extends UIWindow
//	{
//		//阵营ID

//		
//		private static var _instance:ZhenYing;		
//		
//		public function ZhenYing()
//		{
//			super(this.getLink(WindowName.win_zhen_ying));
//		}
//
//		public static function instance():ZhenYing
//		{
//			if(_instance==null){
//				_instance=new ZhenYing();
//			}
//			return _instance;
//		}
//		
//		//面板初始化
//		override protected function init():void 
//		{
//
//			
//		}
//		
//		
//		// 面板点击事件
//		override public function mcHandler(target:Object):void
//		{			
//			super.mcHandler(target);
//			
//			switch (target.name)
//			{
//				case "btnXuanZe1":					
//					//随机1
//					setCamp(0);
//					break;
//				case "btnXuanZe2":					
//					//太乙2
//					setCamp(2);	
//					break;		
//				case "btnXuanZe3":
//					//通天3
//					setCamp(3);	
//					break;
//				default:
//					
//					break;
//				
//			}
//			
//		
//		}
//	
//		
//				
//		
//		/**
//		 * 选择阵营
//		 */
//		public function setCamp(v:int):void{
//
//			super.uiRegister(PacketWCSelectPkCamp.id,setCampReturn);
//			var client:PacketCWSelectPkCamp = new PacketCWSelectPkCamp();
//			client.camp=v;
//			this.uiSend(client);	
//		}
//		public function setCampReturn(p:PacketWCSelectPkCamp):void
//		{
//			if (super.showResult(p))
//			{	
//				super.winClose();
//				//阵营选好 进入华山论剑界面
//				flash.utils.setTimeout(PKMatchWindow.getInstance().open,300);
//			}
//			else
//			{
//				
//			}
//			
//		}
//		
//	
//		
//		override public function getID():int
//		{
//			return 1013;
//		}
//		
//		
//	}
//}
//
//
//
//
