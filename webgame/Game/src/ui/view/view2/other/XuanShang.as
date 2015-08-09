package ui.view.view2.other
{
	
	import common.config.GameIni;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ExploitResModel;
	import common.config.xmlres.server.Pub_TaskResModel;
	import common.config.xmlres.server.Pub_Task_StepResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.hangup.GamePlugIns;
	
	import ui.base.renwu.MissionMain;
	import ui.base.renwu.Renwu;
	import ui.base.renwu.renwuEvent;
	import ui.base.vip.NoMoney;
	import ui.base.vip.Vip;
	import ui.frame.UIAction;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	/**
	 *	悬赏任务
	 *  andy 2013-04-03
	 *  andy 2013-12-30  3000万
	 */
	public class XuanShang extends UIWindow
	{
		/**
		 *	当前任务
		 */
		private var curTask:StructAwardTaskList2=null;
		/**
		 *	当前皇榜数据
		 */
		private var taskAward:PacketSCTaskAwardList2=null;
		/**
		 *	星级对应奖励 
		 */
		public const arrRate:Array=[0,1,1.1,1.2,1.3,1.4,1.6,1.8,2.1,2.4,2.7];
		//
		public static const 	XUAN_SHANG_LIMIT_ID:int=88000003;
		//
		private var first:Boolean=false;
		/**
		 *	悬赏任务开放等级 
		 */
		public static const XUAN_SHANG_LEVEL:int=30;
		
		private static var _instance:XuanShang;
		
		public static function getInstance():XuanShang
		{
			if (_instance == null)
			{
				_instance=new XuanShang();
			}
			return _instance;
		}
		
		//是否还能免费刷新
		private var isFreeRefresh:Boolean=true;
		
		public function XuanShang()
		{
			super(this.getLink(WindowName.win_xuanshang));
		}
		
		override protected function init():void
		{
			super.init();
			first=true;
			super.uiRegister(PacketSCTaskAwardList.id, SCTaskAwardListReturn);
			super.uiRegister(PacketSCTaskAwardFresh.id, SCTaskAwardFreshReturn);
			super.uiRegister(PacketSCTaskAwardAccept.id,SCTaskAwardAcceptReturn);
			super.uiRegister(PacketSCTaskAwardComplete.id,SCTaskAwardCompleteReturn);
			super.uiRegister(PacketSCTaskAwardTimeBuy.id,SCTaskAwardTimeBuyReturn);
			
			super.sysAddEvent(this,TextEvent.LINK,Renwu.textLinkListener_);
			super.sysAddEvent(renwuEvent.instance,renwuEvent.TASKCANSUBMIT, getTaskList);
			
			this.x=GameIni.MAP_SIZE_W/ 2+140;
			clear();
			
			getTaskList();
			
		}
		
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			//领取奖励
			if(name.indexOf("btnLQ")==0){
				var lq:int=int(name.replace("btnLQ",""));
				quickFinish(curTask.taskid,lq);
				return;
			}
			switch (name)
			{
				case "btnBuyTimes":
					//购买次数
					alert.ShowMsg(Lang.getLabel("10004_xuanshang",[taskAward.cantimes]),4,null,buyTimes);
					break;
				case "btnRefresh":
					//刷新
					//GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("10187_xuanshang"), GameAlertNotTiShi.XUAN_SHANG, null, refresh);
					refresh();
					break;
				case "btnTakeTask":
					//接取任务
					if(curTask==null)return;
					takeTask(curTask.taskid);
					break;
				case "btnGold":
					//银两来源
					NoMoney.getInstance().setType(2);
					break;
				case "btnDuiHuan":
					//兑换军阶
					super.winClose();
					XuanShangDuiHuan.getInstance().open();
					break;
				case "btnContinueTask":
					//继续任务
					super.winClose();
					MissionMain.instance.findPahtByTaskID(curTask.taskid);
					break;
				case "btnYiJian":
					//一键10星刷新
					autoRefresh();
					break;
				case "btnYiJianStop":
					//一键10星刷新 停止
					autoRefreshStop();
					break;
				default :
					break;
				
			}
		}
		
		/**
		 *	悬赏任务列表信息
		 */
		public function show():void
		{
			//刷新列表
			taskAward=Data.npc.getTaskAwardList();
			var vec:Vector.<StructAwardTaskList2>=taskAward.arrItemtasklist;
			var len:int=vec.length;
			if(len==0)return;
			curTask=vec[0];
			//剩余次数
			mc["txt_remain_times"].htmlText=taskAward.maxAcceptTimes-taskAward.curAcceptTimes;
			var taskModel:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(curTask.taskid) as Pub_TaskResModel;
			
			mc["txt_task_desc"].htmlText=taskModel.task_desc;
			mc["txt_exp"].text=int(taskModel.prize_exp*(arrRate[curTask.star]*100)/100);
			mc["txt_rep"].text=int(taskModel.prize_rep*(arrRate[curTask.star]*100)/100);
			
			//奖励 未接取刷新，已完成
			if(curTask.state==1||curTask.state==0){
				mc["mc_jiangli"].gotoAndStop(1);
				mc["mc_jiangli"]["txt_task_level"].text=XmlRes.getChinaNumber(curTask.star);
				mc["mc_jiangli"]["mc_row"].visible=curTask.star<7;
				
				// 指引箭头特殊处理
				mc["mc_jiangli"]["mc_row"].stop();
				
				CtrlFactory.getUIShow().setBtnEnabled(mc["mc_jiangli"]["btnRefresh"],true);
				if(first){
					first=false;
					autoRefreshStop();
				}	
			}else if(curTask.state==2){
				mc["mc_jiangli"].gotoAndStop(3);
				var task:StructTaskList2=MissionMain.instance.checkTaskIsHave(curTask.taskid);
				if(task!=null)
				mc["mc_jiangli"]["txt_desc"].htmlText=Renwu.getTaskResult(curTask.taskid,task.arrItemstate);
			}else if(curTask.state==3){
				mc["mc_jiangli"].gotoAndStop(2);
			}else{
				mc["mc_jiangli"].gotoAndStop(4);
			}
			
			
			var curLevel:int=Data.myKing.ploitLv;
			var ploitModel:Pub_ExploitResModel=XmlManager.localres.exploitXml.getResPath(curLevel) as Pub_ExploitResModel;
			if(ploitModel!=null){
				mc["txt_jun_jie"].htmlText=ploitModel.exploit_name;
			}else{
				mc["txt_jun_jie"].htmlText="暂时无军阶";
			}
		}
		/**
		 * 2014－07－21 一键10星 
		 * 
		 */		
		private function autoRefresh():void{
			mc["mc_jiangli"]["btnYiJianStop"].visible=true;
			mc["mc_jiangli"]["btnYiJian"].visible=false;
			//mc["mc_jiangli"]["btnRefresh"].visible=false;
			
			refresh();
		}
		private function autoRefreshStop():void{
			mc["mc_jiangli"]["btnYiJianStop"].visible=false;
			mc["mc_jiangli"]["btnYiJian"].visible=true;
			//mc["mc_jiangli"]["btnRefresh"].visible=true;
		}

		/********通讯*************/
		/**
		 *	获得列表数据 
		 */
		public function getTaskList(e:DispatchEvent=null):void
		{
			var client:PacketCSTaskAwardList=new PacketCSTaskAwardList();
			super.uiSend(client);
		}
		private function SCTaskAwardListReturn(p:PacketSCTaskAwardList):void
		{
			show();
			if(mc["mc_jiangli"]["btnYiJian"]!=null&&mc["mc_jiangli"]["btnYiJian"].visible==false){
				if(p.arrItemtasklist[0].star<10){
					refresh();
				}else{
					autoRefreshStop();
				}
			}
		}
		/**
		 *	购买次数 
		 *  2013-12-24
		 */
		private function buyTimes():void
		{
			var client:PacketCSTaskAwardTimeBuy=new PacketCSTaskAwardTimeBuy();
			super.uiSend(client);
		}
		
		private function SCTaskAwardTimeBuyReturn(p:PacketSCTaskAwardTimeBuy):void
		{
			if(super.showResult(p)){
				getTaskList();
			}else{
				
			}
		}
		/**
		 *	刷新【手动刷新】
		 */
		private function refresh():void
		{
			var client:PacketCSTaskAwardFresh=new PacketCSTaskAwardFresh();
			super.uiSend(client);
			CtrlFactory.getUIShow().setBtnEnabled(mc["mc_jiangli"]["btnRefresh"],false);
		}
		
		private function SCTaskAwardFreshReturn(p:PacketSCTaskAwardFresh):void
		{
			if(super.showResult(p)){
				getTaskList();
			}else{
				autoRefreshStop();
			}
			CtrlFactory.getUIShow().setBtnEnabled(mc["mc_jiangli"]["btnRefresh"],true);
		}
		/**
		 *	接取任务
		 */
		private function takeTask(taskId:int):void
		{
			var client:PacketCSTaskAwardAccept=new PacketCSTaskAwardAccept();
			client.taskid=taskId;
			super.uiSend(client);
		}
		private function SCTaskAwardAcceptReturn(p:PacketSCTaskAwardAccept):void
		{
			if(super.showResult(p)){
				GamePlugIns.change_map_auto=true;
				super.winClose();
			}else{
				
			}
		}
		/**
		 *	领取奖励
		 */
		private function quickFinish(taskId:int,idNeedCoin:int=1):void
		{
			if(taskId==0)return;
			var client:PacketCSTaskAwardComplete=new PacketCSTaskAwardComplete();
			client.taskid=taskId;
			client.flag=idNeedCoin;
			super.uiSend(client);
		}
		private function SCTaskAwardCompleteReturn(p:PacketSCTaskAwardComplete):void
		{
			if(super.showResult(p)){
				getTaskList();
				
			}else{
				
			}
		}
		

		
		
		/************内部方法*************/

		/**
		 *	 
		 */
		private function clear():void{
			for(i=0;i<8;i++){
				child=mc["item"+(i+1)];
				if(child==null)continue;
				child.visible=false;
			}
			mc["mc_jiangli"].gotoAndStop(4);
		}


		
		override public function getID():int
		{
			return 0;
		}
		
	}
}


