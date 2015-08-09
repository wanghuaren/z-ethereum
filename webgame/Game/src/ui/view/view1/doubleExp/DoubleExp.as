package ui.view.view1.doubleExp
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import model.fuben.FuBenModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.manager.SceneManager;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.other.QuickInfo;
	import ui.view.zhenbaoge.ZhenBaoGeWin;
	
	import world.WorldEvent;
	
	public class DoubleExp extends UIWindow
	{
//		public static var  zengsong:int;
//		public static var  yuanbaohuode:int;
		private var buyTimes:int;
		public var time:int;		
		public var curTime:int = 0;
		public function DoubleExp()
		{
			super(getLink(WindowName.win_shuangbei));
			DataKey.instance.register(PacketSCDoubleExpInfo.id,SCDoubleExpInfo);
//			UI_index.indexMC_mrt["shuangbeiTIP"].visible = false;
//			Lang.addTip(UI_index.indexMC_mrt["shuangbeiTIP"], "shuangbeixuanfu");
		}
		
		private static var _instance : DoubleExp = null;
		
		public static function get instance() : DoubleExp {
			if (null == _instance)
			{
				_instance=new DoubleExp();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			if(openFubenTishi){
				//DoubleExp._instance.winClose();
			}
			uiRegister(PacketSCDoubleExpInfoGetRet.id,SCDoubleExpInfoGetRet);
			
			uiRegister(PacketSCDoubleExpStartRet.id,SCDoubleExpStartRet);
			
			uiRegister(PacketSCDoubleExpAddTimeRet.id,SCDoubleExpAddTime);
			
			var vo:PacketCSDoubleExpInfoGet = new PacketCSDoubleExpInfoGet();
			uiSend(vo);
			
			
		}
		
		private function SCDoubleExpInfoGetRet(p:PacketSCDoubleExpInfoGetRet) : void {
			showInfo(p.data);
		}
		private var rmbTime:int = 0;
		private var sysTime:int = 0;
		private function SCDoubleExpInfo(p:PacketSCDoubleExpInfo2) : void {
			if(isOpen)showInfo(p.data);
			if(p.data.state==1){

				UI_index.indexMC_mrb["btnShuangBei"].gotoAndStop(2);
				curTime = time = p.data.rmbtime+p.data.systime;
					this.rmbTime = p.data.rmbtime;
					this.sysTime = p.data.systime;
				isTime = true;
								
				
				
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
			
			}else{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
				
				time = 0;
				
				isTime = false;
				
				
				UI_index.indexMC_mrb["btnShuangBei"].gotoAndStop(1);
				
				//
				var bufDEL:PacketSCBuffDelete2 = new PacketSCBuffDelete2();
				bufDEL.buffsn = DoubleExp.BUF;
				bufDEL.objid = Data.myKing.objid;
				DataKey.instance.receive(bufDEL);
			}
		}
		
		private function messageTimer(e:WorldEvent):void
		{
			time--;
			if(time>0){
				if(this.sysTime>0){
					this.sysTime--;
				}else{
					this.rmbTime--;
					
				}
				if(sysTime<=0){
					sysTime =0;
				}
				if(rmbTime<=0){
					rmbTime =0;
				}
				
				
				//
				var bufNEW:PacketSCBuffNew2 = new PacketSCBuffNew2();
				bufNEW.buff.buffid = DoubleExp.BUF;
				curTime = bufNEW.buff.needtime = time;
				bufNEW.objid = Data.myKing.king.objid; 
				DataKey.instance.receive(bufNEW);
				mc["zongshijian"].text = getTime(time);
				mc["yuanbaohuode"].text = getTime(rmbTime);
				mc["zengsong"].text = getTime(sysTime);				
			}else{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, messageTimer);
				curTime = 0;
				//UI_index.indexMC_mrb['mrb_mc_task_do'].visible = false;
				
				//
				var bufDEL:PacketSCBuffDelete2 = new PacketSCBuffDelete2();
				bufDEL.buffsn = DoubleExp.BUF;
				bufDEL.objid = Data.myKing.king.objid;
				DataKey.instance.receive(bufDEL);
				
			}
			
			
		}
		public var openFubenTishi:Boolean = true;
		private function showInfo(sdei:StructDoubleExpInfo2):void{
			buyTimes = sdei.buytimes;
			mc["yuanbaohuode"].text = getTime(sdei.rmbtime);
			mc["zengsong"].text = getTime(sdei.systime);
			mc["zongshijian"].text = getTime(sdei.systime+sdei.rmbtime);
			curTime = sdei.systime+sdei.rmbtime;
			//当有效双倍时间为0时，做一次气泡提示
			//您的双倍时间用尽，影响到您的升级速度，购买双倍经验时间助您飞速升级
			if(FuBenModel.getInstance().m_currentIndex==9&&FuBenModel.getInstance().m_isAting&&openFubenTishi){
				
				
				openFubenTishi=  false;
				//DoubleExp._instance.winClose();
			}
			if(0 == (sdei.systime+sdei.rmbtime))
			{
				
				QuickInfo.getInstance().runDoubleExpZero();
			}
			
			if(sdei.state==1){
				mc["startDouble"].label = Lang.getLabel("20077_DoubleExp");
				Lang.addTip(mc["startDouble"], "kaiqishuangbei");
				mc["time_on_off"].gotoAndStop(2);
			}else{
				mc["startDouble"].label = Lang.getLabel("20076_DoubleExp");
				Lang.addTip(mc["startDouble"], "guanbishuangbei");
				mc["time_on_off"].gotoAndStop(1);
			}
		}
		
		private function getTime(second:int):String{
			var value:String="";
			var temp:int = int(second/3600);
			if(temp>0){
				value = temp+Lang.getLabel("pub_xiaoshi");
			}
			temp = int((second%3600)/60);
			value += temp+Lang.getLabel("pub_fenzhong");
			return value;
		}
		
//		private function getTime2(second:int):String{
//			var value:String="";
//			var shi:int = int(second/3600);
//			var fen:int = int((second%3600)/60);
//			var miao:int = int((second%3600)%60);
//			if(shi>0){
//				value = shi+Lang.getLabel("pub_shi")+fen+Lang.getLabel("pub_fen");
//			}else if(fen){
//				value = fen+Lang.getLabel("pub_fen")+miao+Lang.getLabel("pub_miao");
//			}else{
//				value = miao+Lang.getLabel("pub_miao");
//			}
//			return value;
//		}
		
		private function SCDoubleExpStartRet(p:PacketSCDoubleExpStartRet) : void {
			showResult(p);
			
			
		}
		
		public static var isTime:Boolean = false;
		public static const BUF:int = 13470;
		
		private function SCDoubleExpAddTime(p:PacketSCDoubleExpAddTimeRet) : void {
			showResult(p);
		}
		public function setMrbShuangbei():void
		{
			var vo:PacketCSDoubleExpInfoGet = new PacketCSDoubleExpInfoGet();
			uiSend(vo);
		}
		public var isStartDouble :int = 0;
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "buyDouble":
//					if(buyTimes<100){
						ZhenBaoGeWin.getInstance().setType(2);

//					}
					break;
				case "startDouble":
					if(target.label==Lang.getLabel("20077_DoubleExp")){
						var vo:PacketCSDoubleExpStart = new PacketCSDoubleExpStart();
						vo.tag=0;
						isStartDouble=0;
						uiSend(vo);
					}else{
						var vo2:PacketCSDoubleExpStart = new PacketCSDoubleExpStart();
						vo2.tag=1;
						isStartDouble = 1;
						uiSend(vo2);
						
						
					}
					break;
			}
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}
	}
}