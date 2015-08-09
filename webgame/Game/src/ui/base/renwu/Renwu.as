package ui.base.renwu
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructNextList2;
	import netc.packets2.StructSeekData2;
	import netc.packets2.StructTaskList2;
	import netc.packets2.StructTaskState2;
	
	import nets.packets.PacketCSAutoSeek;
	import nets.packets.PacketCSAutoSend;
	import nets.packets.PacketCSTaskCancel;
	
	import scene.action.hangup.GamePlugIns;
	import scene.body.Body;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.NpcInfo;
	import scene.king.TalkSource;
	import scene.manager.SceneManager;
	
	import ui.base.bangpai.BangPaiMain;
	import ui.base.fuben.FuBenController;
	import ui.base.huodong.HuoDongTuiJian;
	import ui.base.npc.mission.MissionNPC;
	import ui.base.vip.ShouChong;
	import ui.component.XHTree;
	import ui.component.XHTreeEvent;
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIAction;
	import ui.frame.UIWindow;
	import ui.view.pay.WinFirstPay;
	import ui.view.view2.NewMap.GameAutoPath;

	/**
	 * @author  suhang
	 * @version 2011-11
	 */
	public final class Renwu extends UIWindow
	{
		// -----------模拟数据-----
		// private var testData:Array=[{id:1,l1:"模拟数据A1层",l2:"模拟数据A2层",l3:"模拟数据A3层"},{id:2,l1:"模拟数据A1层",l2:"模拟数据B2层",l3:"模拟数据A3层"},{id:3,l1:"模拟数据B1层",l2:"模拟数据A2层",l3:"模拟数据A3层"},{id:4,l1:"模拟数据C1层",l2:"模拟数据A2层",l3:"模拟数据A3层"}];
		// ----------
		//当前选择的任务
		private var currMission:Object;
		public var missionListNum:String=null;
//		private var currNO:int=1;
//		private var shoseArray:Array=[];

//		private var cls : int = 1;
		// 1 已接任务 2 未接任务 3 活动


		private var m_currentTabIndex:int=1;

		public function Renwu(listNum:String="0", layer:int=1)
		{
			missionListNum=listNum;
			blmBtn=2;

			super(getLink("pop_ren_wu"), layer);
		}

		private static var _instance:Renwu=null;

		public static function instance(listNum:String="0"):Renwu
		{
			if (null == _instance)
			{
				_instance=new Renwu(listNum);
			}
			else
			{
				_instance.missionListNum=listNum;
			}
			return _instance;
		}

		// 初始化执行方法
		override protected function init():void
		{
			super.init();
			panelInit();
			setPos(-1, -1);
			total=-1;
			mc["mcDesc"].visible=false;
//			Lang.addTip(mc["mcDesc"]["shose"], CtrlFactory.getTipMC().shose);
			if (missionListNum != "9")
			{
				if (MissionMain.taskList.length > 0)
				{
					mcHandler({name: "cbtn1", parent: mc["cbtn1"]});
				}
				else
				{
					mcHandler({name: "cbtn2", parent: mc["cbtn2"]});
				}
			}
			mc["cbtn1"].selected=true;
			//已接任务有变化
			renwuEvent.instance.addEventListener(renwuEvent.USERTASKCHANGE, userTaskChange);
			//可接任务有变化
			renwuEvent.instance.addEventListener(renwuEvent.NEXTTASKCHANGE, nextTaskChange);
		}


		private function userTaskChange(e:Event=null):void
		{
			renwuTaskUserList(MissionMain.taskList);
		}

		private function nextTaskChange(e:Event=null):void
		{
			CTaskNextlist(MissionMain.nextList);
		}

		public function renwuTaskUserList(arr:Vector.<StructTaskList2>):void
		{
			if (arr.length > 0)
			{
				getMissionInfo(arr[0]);

				showMissionList2(arr);
				StringUtils.setEnable(mc["btnDrop"]);
			}
			else
			{
				panelInit();
				StringUtils.setUnEnable(mc["btnDrop"]);
			}

			if (2 == m_currentTabIndex)
			{
				CTaskNextlist(MissionMain.nextList);
			}
		}

		//选择任务后显示任务详细信息
		public function CTaskDesc(data:Object):void
		{

			var ptx:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(data.taskid) as Pub_TaskResModel;
			//已接任务
			if (mc["mcDesc"].visible == true && (data.status == 2 || data.status == 3))
			{
				mc["mcDesc"]["desc2"].htmlText=setTextColor(ptx.task_desc);
				sysAddEvent(mc["mcDesc"]["desc2"], TextEvent.LINK, textLinkListener_);
				
				var jiang:String="";
				//2013-11-15 增加悬赏任务倍数
				var rate:Number=1.0;//XuanShang.getInstance().getTaskAwardRate(data.taskid);
				jiang+=ptx.prize_exp*rate + " " + Lang.getLabel("pub_jing_yan") + "  " + ptx.prize_coin*rate + " " + Lang.getLabel("pub_yin_liang") + "  " + ptx.prize_rep*rate + " " + Lang.getLabel("pub_sheng_wang");
				if(ptx.FightPoint>0){
					jiang+=" "+ ptx.FightPoint+ " " +Lang.getLabel("pub_tu_long_dian") ;
				}
				mc["mcDesc"].pt1.text=jiang;

				var mcPic:MovieClip;
				var i:int;
				var num:int=0;
				var prizeArr:Array=XmlManager.localres.getPubTaskPrizeXml.getResPath2(ptx.task_id) as Array;

				var len:int=prizeArr.length;
				for (i=0; i < len; i++)
				{
					if (prizeArr[i].sort == 1 && (prizeArr[i].need_metier == 0 || prizeArr[i].need_metier == Data.myKing.metier))
					{
						var sbc:StructBagCell2=new StructBagCell2;
						sbc.itemid=prizeArr[i].item_id;
						sbc.num=prizeArr[i].item_num;
						Data.beiBao.fillCahceData(sbc);
						mcPic=mc["mcDesc"]["pic" + (1 + num)];
						if(mcPic==null)continue;
//						mcPic["uil"].source=sbc.icon;
						ImageUtils.replaceImage(mcPic,mcPic["uil"],sbc.icon);
						mcPic["r_num"].text=sbc.num + "";
						mcPic["mc_color"].gotoAndStop(sbc.toolColor == 0 ? 1 : sbc.toolColor);
						mcPic.visible=true;
					
						ItemManager.instance().setToolTipByData(mcPic,sbc);
						num++;
					}
				}
				for (var j:int=num + 1; j < 6; j++)
				{
					mc["mcDesc"]["pic" + j].visible=false;
				}

				mc["mcDesc"].visible=true;
				var text:String;
				if (data.status == 3)
				{
					var npc:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(ptx.submit_npc) as Pub_NpcResModel;
					text=" " + Lang.getLabel("20049_RenWu") + " " + getChuanSongText(npc.npc_id);
				}
				else
				{
					text=Renwu.getTaskResult(data.taskid, data.arrItemstate, false);
				}
				mc["mcDesc"]["zhuizong"].htmlText=text;
				sysAddEvent(mc["mcDesc"]["zhuizong"], TextEvent.LINK, textLinkListener_);
			}
			//可接任务
			else if (mc["mcDesc"].visible == false && (data.status == 1 || !data.hasOwnProperty("status")))
			{
				mc["mcDesc2"]["fabudi"].text=ptx.send_map == 0 ? "" : XmlManager.localres.getPubMapXml.getResPath(ptx.send_map)["map_title"];
				mc["mcDesc2"]["faburen"].htmlText=getChuanSongText(ptx.send_npc);
				sysAddEvent(mc["mcDesc2"]["faburen"], TextEvent.LINK, textLinkListener_);
			}
		}
		
		private static function textLinkListener_Core(e:TextEvent,isNeedFeiXie:Boolean=true):void
		{
			
			var arr:Array=e.text.split("@");
			if (arr[0] == "1" && arr[1].length > 1)
			{
				//2012-08-13 andy 修炼中不能寻路
				var zt:String=Data.myKing.king.roleZT;
				if (KingActionEnum.XL == zt)
				{
					return;
				}
				
				//
				if (Data.myKing.king.isBooth)
				{
					return;
				}
				
				
				//自动寻路 seek_type=1  虚拟npc
				var xml:Pub_SeekResModel=XmlManager.localres.getPubSeekXml.getResPath(arr[1]) as Pub_SeekResModel;
				if (xml == null)
					return;
				if (xml.seek_type == 1)
				{
					MissionNPC.instance().setNpcId(int(arr[1]), false);
				}else if(xml.seek_type==2){
					//2013-04-09 andy 悬赏面板
					//XuanShang.getInstance().open(true);
				}else{
					//取消挂机
					if (GamePlugIns.getInstance().running)
					{
						GamePlugIns.getInstance().stop();
					}
					
					var vo:PacketCSAutoSeek=new PacketCSAutoSeek();
					vo.seekid=arr[1];
					DataKey.instance.send(vo);
					
				}
				
			}
			else if (arr[0] == "2")
			{
				//取消挂机
				if (GamePlugIns.getInstance().running)
				{
					GamePlugIns.getInstance().stop();
				}
				//点击{传} 
				//至尊vip对应的免费传送次数
				//2013-11-19 andy 只要是vip都可以 
				var vipvip:int=Data.myKing.VipVip;
				if (vipvip>0||Data.myKing.TestVIP>0)
				{
					//2012-10-18 andy 客户端(先)不判断：如果处于战斗中不能传送
					//					if (Data.myKing.InCombat == 1)
					//					{
					//						Lang.showMsg(Lang.getClientMsg("10029_renwu"));
					//						return;
					//					}
					
					
					GamePlugIns.change_map_auto=true;
					UIAction.walkArr=new Vector.<StructSeekData2>;
					var vo2:PacketCSAutoSend=new PacketCSAutoSend();
					vo2.seekid=arr[1];
					UIAction.transId=0;
					DataKey.instance.send(vo2);
					
				}
//				else if (isNeedFeiXie && Data.beiBao.getBeiBaoCountById(11800182) < 1)
//				{
//					Lang.showMsg({type: 4, msg: Lang.getLabel("20088_chuansong"),t:12});
//				}
				else
				{
//					GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("20087_chuansong"), GameAlertNotTiShi.CHUANSONG, null, 
//						function():void
//					{
//						UIAction.walkArr=new Vector.<StructSeekData2>;
//						var vo2:PacketCSAutoSend=new PacketCSAutoSend();
//						vo2.seekid=arr[1];
//						UIAction.transId=0;
//						DataKey.instance.send(vo2);
//					});
					
					UIAction.walkArr=new Vector.<StructSeekData2>;
					var vo2:PacketCSAutoSend=new PacketCSAutoSend();
					vo2.seekid=arr[1];
					UIAction.transId=0;
					DataKey.instance.send(vo2);
				}
				
				
				//2012-06-15 andy 点击传送，如果npc对话面板未关闭，则关闭
				if (MissionNPC._instance != null && MissionNPC._instance.isOpen)
				{
					MissionNPC._instance.winClose();
				}
			}
			else if (arr[0] == "9958")
			{
				//2012-11-20 19:28  andy 我还能做什么
				HuoDongTuiJian.instance().setType(2);
			}else if(arr[0] == "5188"){
				//2013-04-09 15:14  andy 悬赏任务
				//XuanShang.getInstance().open(true);
			}else if (arr[0] == "9999")
			{
				//2012-11-20 19:28  andy 60级极品神武、酷炫坐骑
				WinFirstPay.instance.open();
			}else if(arr[0] == "50003"){
				//2013-04-09 15:14  andy 悬赏任务
//				XuanShang.getInstance().open(true);
				//NpcShop.instance().setshopId(NpcShop.DUI_HUAN_SHOP_ID);
			}else if(arr[0] == "50005"){
				//2013年11月15日 10:41:43 hpt
				//				bangpai
				if(Data.myKing.Guild.isGuildPeople){
					BangPaiMain.instance.setType(2);
					
				}else{
					Lang.showMsg({type: 4, msg: Lang.getLabel("50015_chuancheng")});
				}
			}
			else
			{
				
			}

		
		}
		

		//文字点击事件 
		public static function textLinkListener_(e:TextEvent,isNeedFeiXie:Boolean=true):void
		{
			MissionMain.instance.closeMissionTip();
			
			
			//
			Body.instance.sceneKing.DelMeTalkInfo(TalkSource.ChangeTalkByChuangSong,0);
			


			UIAction.taskAuto=true;
			
			//
			var arr:Array=e.text.split("@");
			
			var isAutoPath:Boolean = false;
			var isChuanCheng:Boolean = false;
			
			if("1" == arr[0]){
				isAutoPath = true;
			}
			
			if("50003" == arr[0]){
				isChuanCheng = true;
			}
			
			//
			if(SceneManager.instance.isAtGameTranscript() && 				
			   !isAutoPath && 
			   !isChuanCheng)
			{
				FuBenController.Leave(false,function():void{
				
					textLinkListener_Core(e,isNeedFeiXie)
				
				});
			
			}else{
			
			textLinkListener_Core(e,isNeedFeiXie);
			}
		}




		override public function mcHandler(target:Object):void
		{
			// 面板点击事件
			super.mcHandler(target);

			total=1;
			// suhang-指引1
			/*if (PubData.step == 3)
			{
				CtrlFactory.getUIShow().removeDirect(mc);
			}*/

			switch (target.name)
			{
				case "cbtn1":
					m_currentTabIndex=1;

					mc["mcDesc"].visible=true;
					mc["mcDesc2"].visible=false;
					mc["spList"].source=null;
					mc["spList2"].source=null;
					mc["btnDrop"].visible=true;
					mc["btnAuto"].visible=false;
					mc["spList"].position=0;
					userTaskChange();
					break;
				case "cbtn2":

					m_currentTabIndex=2;

					mc["mcDesc"].visible=false;
					mc["mcDesc2"].visible=true;
					mc["spList"].source=null;
					mc["spList2"].source=null;
					//PubData.socket.send("STaskNextlist", "CTaskNextlist", CTaskNextlist, {userid:PubData.roleID});
					mc["btnDrop"].visible=false;
					mc["btnAuto"].visible=true;

					mc["mcDesc2"]["fabudi"].text="";
					mc["mcDesc2"]["faburen"].text="";
					mc["spList"].position=0;
					nextTaskChange();
					break;
				case "btnACT":
					btnACTClick();
					break;
				case "btnDrop":
					if (currMission == null)
					{
						alert.ShowMsg(Lang.getLabel("20050_RenWu"));
					}
					else if (mc["btnDrop"].label == Lang.getLabel("20051_RenWu"))
					{
						//PubData.socket.send("STaskTake", "CTaskTake", CTaskTake, {userid:PubData.roleID, task_id:currMissionId});
					}
					else
					{
						alert.ShowMsg(Lang.getLabel("20052_RenWu"), 4, null, function():void
						{
							var vo_:PacketCSTaskCancel=new PacketCSTaskCancel();
							vo_.userid=int(PubData.roleID);
							vo_.taskid=int(currMission.taskid);
							uiSend(vo_);
						});
							// //PubData.socket.send("STaskCancel","CTaskCancel",CTaskCancel,{userid:PubData.roleID,task_id:currMissionId});

					}
					break;
				case "btnAuto":
					if (currMission == null)
					{
						alert.ShowMsg(Lang.getLabel("20053_RenWu"));
					}
					else
					{
						var ptx:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(currMission.taskid) as Pub_TaskResModel;
						GameAutoPath.seek(ptx.send_npc);
						winClose();
					}
					break;
			}
		}

		private function btnACTClick():void
		{
			mc["btnDrop"].visible=true;
			mc["btnDrop"].label=Lang.getLabel("20051_RenWu");
			mc["btnAuto"].visible=false;
			//PubData.socket.send("STaskDay", "CTaskDay", CTaskDay);
		}

		public function CTaskTake(e:DispatchEvent):void
		{
			if (showAlert(e))
			{
				currMission=null;
				btnACTClick();
			}
		}

		public function CTaskNextlist(arr:Vector.<StructNextList2>):void
		{
			if (arr.length > 0)
			{
				showMissionList(arr);
				getMissionInfo(arr[0]);
				StringUtils.setEnable(mc["btnAuto"]);
			}
			else
			{
				StringUtils.setUnEnable(mc["btnAuto"]);
			}
		}

		override protected function showAlert(e:DispatchEvent):Boolean
		{
			// 返回警告
			if (super.showAlert(e))
			{
				userTaskChange();
				return true;
			}
			return false;
		}

		private function getMissionInfo(task:Object):void
		{
			if (task.taskid == null)
			{
				return;
			}
			currMission=task;
//			uiRegister(PacketSCTaskDesc.id, CTaskDesc);
//			var vo:PacketCSTaskDesc=new PacketCSTaskDesc();
//			vo.taskid=int(task.taskid);
//			uiSend(vo);
			CTaskDesc(currMission);
		}

		//显示可接任务列表
		private function showMissionList(missionData:Vector.<StructNextList2>):void
		{
			//StructTaskList2    taskid   status   arrItemstate(num)
			var temp:int=0;
			var arr:Array=new Array;
			var treeObj:Object;
			for each (var itemNext:StructNextList2 in missionData)
			{
				treeObj=new Object;
				if (itemNext.taskSort != temp)
				{
					temp=itemNext.taskSort;
					var parent_node:Object=new Object;
					parent_node.parentNode=true;
					parent_node.mission_txt="<font color='#ff6724'>" + getTaskSort(itemNext.taskSort) + "</font>";
					arr.push(parent_node);
				}
				treeObj.taskid=itemNext.taskid;
				treeObj.parentNode=false;
				var status:int=itemNext.status;
				var wancheng:String=status == 3 ? " <font color='#12ff0c'>(" + Lang.getLabel("20054_RenWu") + ")</font>" : "";
				treeObj.mission_txt="<font color='" + getColor(status) + "'>[" + itemNext.minLevel + Lang.getLabel("pub_ji") + "] " + itemNext.taskTitle + "</font>" + wancheng;
				arr.push(treeObj);
			}
			if (mc["mcDesc"].visible == true)
				mc["mcDesc"]["task_num"].text=missionData.length;

			var tres:XHTree=new XHTree(getLink("ItemRender_xuanzekuang"));
			tres.dataProvider(arr, "ItemRender_TaskTreeNode", "mission_txt");
			tres.addEventListener(XHTreeEvent.ITEM_CLICK, handleClick);
			mc["spList"].source=tres;
			mc["spList"].visible = true;
			mc["spList2"].visible = false;

		}

		//显示已接任务列表
		private function showMissionList2(missionData:Vector.<StructTaskList2>):void
		{
			//StructTaskList2    taskid   status   arrItemstate(num)
			var temp:int=0;
			var arr:Array=new Array;
			var treeObj:Object;
			for each (var itemTask:StructTaskList2 in missionData)
			{
				treeObj=new Object;
				if (itemTask.taskSort != temp)
				{
					temp=itemTask.taskSort;
					var parent_node:Object=new Object;
					parent_node.parentNode=true;
					parent_node.mission_txt="<font color='#ff6724'>" + getTaskSort(itemTask.taskSort) + "</font>";
					arr.push(parent_node);
				}

				treeObj.parentNode=false;
				treeObj.arrItemstate=itemTask.arrItemstate;
				treeObj.status=itemTask.status;
				treeObj.taskid=itemTask.taskid;

				var wancheng:String=itemTask.status == 3 ? " <font color='#12ff0c'>(" + Lang.getLabel("20054_RenWu") + ")</font>" : "";
				treeObj.mission_txt="<font color='" + getColor(itemTask.status) + "'>[" + itemTask.minLevel + Lang.getLabel("pub_ji") + "] " + itemTask.taskTitle + "</font>" + wancheng;
				arr.push(treeObj);
			}
			if (mc["mcDesc"].visible == true)
				mc["mcDesc"]["task_num"].text=missionData.length;

			var tres:XHTree=new XHTree(getLink("ItemRender_xuanzekuang"));
			tres.dataProvider(arr, "ItemRender_TaskTreeNode", "mission_txt");
			tres.addEventListener(XHTreeEvent.ITEM_CLICK, handleClick);
			mc["spList2"].source=tres;
			mc["spList2"].visible = true;
			mc["spList"].visible = false;

		}

		private function handleClick(ev:XHTreeEvent):void
		{
			itemSelected(ev.getInfo);
			getMissionInfo(ev.getInfo.data);
//			mc["spList"].source=ev.target as XHTree;
		}

		//获取任务完成结果
		public static function getTaskResult(id:int, arr:Vector.<StructTaskState2>, add:Boolean=true):String
		{
			var steps:Array=XmlManager.localres.getPubTaskStepXml.getResPath2(id) as Array;
			var value:String="";

			var len:int=steps.length;
			for (var i:int=0; i < len; i++)
			{
				if (arr.length > i)
				{
					if (arr.length < (i + 1) || arr[i].state == 0)
					{
						value=value + (add == true ? "  -" : " ") + setTextColor(setTextValue(steps[i].task_target, [arr[i].num])) + "\n";
					}
					else
					{
						value=value + "<font color='#19ff01'>" + (add == true ? "  -" : " ") + deleteTextColor(setTextValue(steps[i].task_target, [arr[i].num])) + "</font>\n";
					}
				}
			}
			return value;
		}

		//根据格式获取文字的值
		public static function setTextValue(str:String, arr:Array):String
		{
			var result:String=str;
			var from:int=-1;
			var j:int=0;
			var temp:String;
			for (var i:int=0; i < str.length; i++)
			{
				if (from == -1)
				{
					if (str.charAt(i) == "@")
					{
						from=i;
					}
				}
				else
				{
					if (str.charAt(i) == "@")
					{
						temp=str.substring(from, i + 1);
						result=result.replace(temp, arr == null ? "0" : arr[j]);
						from=-1;
						j++;
					}
				}
			}
			return result;
		}

		//
		public static function setTextColorByGamePrintTask(str:String, ud_color:String="", needChuanFast:Boolean=true):String
		{
			if (str == null)
				return "";
			var result:String=str;
			var from:int=-1;
			var temp:String;
			var arr:Array;
			for (var i:int=0; i < str.length; i++)
			{
				if (from == -1)
				{
					if (str.charAt(i) == "{")
					{
						from=i + 1;
					}
				}
				else
				{
					if (str.charAt(i) == "}")
					{
						temp=str.substring(from, i);
						arr=temp.split(":");
						if (arr[1] == "")
						{
							//							if("" == ud_color)
							//							{
							ud_color=arr[2].substring(2);
							//							}

							//result=result.replace("{" + temp + "}", "<font color='#" + arr[2].substring(2) + "'>" + arr[0] + "</font>");

							result=result.replace("{" + temp + "}", "<font color='#" + ud_color + "'>" + arr[0] + "</font>");

						}
						else
						{
							var chuansong:String="";

							if ("" == ud_color)
							{
								ud_color=arr[2].substring(2);
							}

							if (arr.length > 3 && int(arr[3]) == 1)
							{

								chuansong=getNoChuanSongText(arr[1]);

								result=result.replace("{" + temp + "}", chuansong);

							}
							else
							{
								chuansong=getNoChuanSongText(arr[1]);

								result=result.replace("{" + temp + "}", chuansong);
							}

						}
						from=-1;
					}
				}
			}
			return result;
		}

		//设置文字颜色
		//ud = user defined
		public static function setTextColor(str:String, ud_color:String="", needChuanFast:Boolean=true):String
		{
			if (str == null)
				return "";
			var result:String=str;
			var from:int=-1;
			var temp:String;
			var arr:Array;
			for (var i:int=0; i < str.length; i++)
			{
				if (from == -1)
				{
					if (str.charAt(i) == "{")
					{
						from=i + 1;
					}
				}
				else
				{
					if (str.charAt(i) == "}")
					{
						temp=str.substring(from, i);
						arr=temp.split(":");
						if (arr[1] == "")
						{
//							if("" == ud_color)
//							{
							ud_color=arr[2].substring(2);
//							}

							//result=result.replace("{" + temp + "}", "<font color='#" + arr[2].substring(2) + "'>" + arr[0] + "</font>");

							result=result.replace("{" + temp + "}", "<font color='#" + ud_color + "'>" + arr[0] + "</font>");

						}
						else
						{
							var chuansong:String="";

							if ("" == ud_color)
							{
								ud_color=arr[2].substring(2);
							}

							if (arr.length > 3 && int(arr[3]) == 1)
							{

								chuansong=getChuanSongText(arr[1], arr[0], ud_color, needChuanFast);

								result=result.replace("{" + temp + "}", chuansong);

							}
							else
							{
								chuansong=getChuanSongText(arr[1], arr[0], ud_color, false);

								result=result.replace("{" + temp + "}", chuansong);
							}

						}
						from=-1;
					}
				}
			}
			return result;
		}

		/**
		 * 获取传送文字
		 * @param seek_id  传送id
		 * @param npcName  可以自定义连接内容
		 * @param npcColor 连接颜色
		 *
		 */
		public static function getChuanSongText(seek_id:int, npcName:String="", npcColor:String="", isChuan:Boolean=true):String
		{
			if(npcColor=="")npcColor=FontColor.COLOR_NPC;
			var seek:Pub_SeekResModel=XmlManager.localres.getPubSeekXml.getResPath(seek_id) as Pub_SeekResModel;
			if(seek==null||seek.seek_type==1||seek.seek_type==2)
			{
				var npc:Pub_NpcResModel=XmlManager.localres.getNpcXml.getResPath(seek_id) as Pub_NpcResModel;
				if (npc != null)
				{
					if (npcName.length == 0)
						npcName=npc.npc_name;
					return "<a href='event:1@" + seek_id + "'><u><font color='#" + npcColor + "'>" + npcName + "</font></u></a>";
				}
				return "";
			}

			if (npcName.length == 0)
				npcName=seek.seek_name;
			var str:String="<a href='event:1@" + seek.seek_id + "'><u><font color='#" + npcColor + "'>" + npcName + "</font></u></a>";
			if (isChuan){
				str+=" ";
				str+="<a href='event:2@" + seek_id + "'><u><font color='#"+FontColor.COLOR_CHUAN+"'>{" + Lang.getLabel("20086_ZhanLiZhi") + "}</font></u></a>";
			}	
			return str;

		}

		public static function getNoChuanSongText(seek_id:int):String
		{
			var seek:Pub_SeekResModel=XmlManager.localres.getPubSeekXml.getResPath(seek_id) as Pub_SeekResModel;
			if (seek == null || seek.seek_type == 1)
			{
				return "";
			}

			//var str:String = "<a href='event:1@"+seek.seek_id+"'><u><font color='#"+npcColor+"'>"+seek.seek_name+"</font></u></a>";

			var str:String="<a href='event:1@" + seek.seek_id + "'>" + seek.seek_name + "</a>";


			return str;

		}

		//删除文字颜色
		public static function deleteTextColor(str:String):String
		{
			var result:String=str;
			var from:int=-1;
			var temp:String;
			var arr:Array;
			for (var i:int=0; i < str.length; i++)
			{
				if (from == -1)
				{
					if (str.charAt(i) == "{")
					{
						from=i + 1;
					}
				}
				else
				{
					if (str.charAt(i) == "}")
					{
						temp=str.substring(from, i);
						arr=temp.split(":");
						result=result.replace("{" + temp + "}", arr[0]);
						from=-1;
					}
				}
			}
			return result;
		}

		//获取任务类型
		public static function getTaskSort(value:int):String
		{
			switch (value)
			{
				case 1:
					return Lang.getLabel("20055_RenWu");
					break;
				case 2:
					return Lang.getLabel("20056_RenWu");
					break;
				case 3:
					return Lang.getLabel("20057_RenWu");
					break;
				case 4:
					return Lang.getLabel("20058_RenWu");
					break;
				case 5:
					return Lang.getLabel("20059_RenWu");
					break;
				case 6:
					return Lang.getLabel("20060_RenWu");
					break;
				case 7:
					return Lang.getLabel("20092_RenWu");
					break;
				case 8:
					return Lang.getLabel("20103_RenWu");
					break;
				case 9:
					return Lang.getLabel("20104_RenWu");
					break;
				case 10:
					return Lang.getLabel("20105_RenWu");
					break;
				case 11:
					return Lang.getLabel("20106_RenWu");
					break;
				case 12:
					return Lang.getLabel("20107_RenWu");
					break;
				case 13:
					return Lang.getLabel("20108_RenWu");
					break;
				case 14:
					return Lang.getLabel("20109_RenWu");
					break;
				case 15:
					return Lang.getLabel("20110_RenWu");
					break;
				case 16:
					//2012-12-20 圣诞
					return Lang.getLabel("10146_renwu");
					break;
				case 17:
					//2012-12-25 取经
					return Lang.getLabel("10152_renwu");
					break;
				case 18:
					//2013-01-21 春节
					return Lang.getLabel("10167_renwu");
				case 19:
					//2013-04-03 悬赏任务
					return Lang.getLabel("10186_renwu");
					break;
				default:
					break;
			}
			return Lang.getLabel("20056_RenWu");
		}

		//根据类型获取颜色
		public static function getColor(value:int):String
		{
			return "#fff5d2";
			switch (value)
			{
				case 1:
					return "#ffaa15";
					break;
				case 2:
					return "#d1d1d1";
					break;
				case 3:
					return "#04ec03";
					break;
				case 4:
					return "#d1d1d1";
					break;
				case 5:
					return "#04ec03";
				case 8:
				case 9:
				case 10:
				case 11:
				case 12:
				case 13:
				case 14:
				case 15:
				case 16:
				case 17:
				case 18:
					return "#ff6724";
					break;
			}
			return "null";
		}

		/**
		 * 1：主线
		* 2：支线
		* 3：日常任务
		* 4：伙伴任务
		* 5：炼骨任务
		* 6：环线任务
		 */
		public static function getColorBySort(value:int):String
		{
			switch (value)
			{
				case 1:
					return "#"+FontColor.COLOR_ZHU_XIAN;
					break;
				case 2:
					return "#"+FontColor.COLOR_ZHI_XIAN;
					break;
				case 3:
					return "#"+FontColor.COLOR_RI_CHANG;
					break;
				case 4:
					return "#"+FontColor.COLOR_HUO_BAN;
					break;
				case 5:
					return "#"+FontColor.COLOR_LIAN_GU;
					break;
				case 6:
					return "#"+FontColor.COLOR_HUAN;
					break;
				case 8:
					return "#"+FontColor.COLOR_HUANG;
					break;

			}
			return "#"+FontColor.COLOR_TASK_DEFAULT;
		}

		//获取任务状态
		public static function getTaskStatus(value:int):String
		{
			switch (value)
			{
				case 0:
					return Lang.getLabel("20063_RenWu");
					break;
				case 1:
					return Lang.getLabel("20061_RenWu"); //可接
					break;
				case 2:
					return Lang.getLabel("20062_RenWu"); //进行中
					break;
				case 3:
					return Lang.getLabel("20054_RenWu"); //完成
					break;
				case 4:
					return Lang.getLabel("20063_RenWu");
					break;
				case 5:
					return Lang.getLabel("20064_RenWu");
					break;
			}
			return "";
		}

		override protected function itemEvent(sprite:Sprite, itemData:Object=null, mouseChild:Boolean=false):void
		{
			// 条目事件
			super.itemEvent(sprite, itemData);
//			CtrlFactory.getUIShow().setColor(sprite, 1);
			sprite["mStatus"].text=getTaskStatus(itemData.task_status);

			sprite["mType"].text=getTaskSort(itemData.task_sort);

			// sprite["task_title"].text="("+itemData.king_level+"级)"+sprite["task_title"].text;
			sprite["king_level"].text=sprite["king_level"].text + Lang.getLabel("pub_ji");
			sprite["id"]=itemData.taskid;
			sprite.mouseEnabled=true;
			// suhang
			if (itemData.task_sort == 4)
			{
				sprite["task_title"].text=sprite["task_title"].text + " " + itemData.ring + "/" + itemData.cycle;
			}
		}

		private function panelInit():void
		{
			if (mc["mcDesc"].visible == true)
			{
				mc["mcDesc"]["desc2"].htmlText="";
				mc["mcDesc"].pt1.text == "";

				for (var j:int=1; j < 6; j++)
				{
					mc["mcDesc"]["pic" + j].visible=false;
				}

				mc["mcDesc"]["zhuizong"].htmlText="";
				mc["mcDesc"]["pt1"].htmlText="";
				mc["mcDesc"]["task_num"].text="0";
			}
			else
			{
				mc["mcDesc2"]["fabudi"].text="";
				mc["mcDesc2"]["faburen"].text="";
			}
			mc["spList"].source=null;
			mc["spList2"].source=null;
		}

		//刷新所有任务的状态  更新npc头上的各种状态标识
		public static function allTaskStatus():void
		{
			renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.TASKCHANGE));
			var vec:Vector.<NpcInfo>=Body.instance.sceneKing.npcList;
			var vecLen:int=vec.length;
			var lastIgk:IGameKing;
			var igk:IGameKing;
			for (var j:int=0; j < vecLen; j++)
			{
				igk = SceneManager.instance.GetKing_Core(vec[j].objid);
				npcTaskStatus(igk);
//				if (lastIgk!=null)
//				{
//					if (lastIgk.mapx == igk.mapx && lastIgk.mapy == igk.mapy)
//					{
//						throw new Error("allTaskStatus:1:Error--mapx>>mapy");
//					}
//					else if (Math.abs(lastIgk.x - igk.x) < 30 && Math.abs(lastIgk.y - igk.y) < 30)
//					{
//						throw new Error("allTaskStatus:2:Error--x>>y");
//					}
//				}
				lastIgk = igk;
			}
		}

		public static function npcTaskStatus(igk:IGameKing):void
		{
			if (igk == null || igk.dbID == 0)
				return;
			igk.getSkin().getHeadName().GongNengHeadState.gotoAndStop(XmlManager.localres.getNpcXml.getResPath(igk.dbID)["func_icon"] % 1000 + 1);
			if (MissionMain.taskList != null && MissionMain.taskList.length != 0)
			{

				var len:int=MissionMain.taskList.length;
				for (var i:int=0; i < len; i++)
				{
					if (MissionMain.taskList[i].submitNpc == igk.dbID)
					{
						if (MissionMain.taskList[i].status == 3)
						{
							igk.getSkin().getHeadName().GongNengHeadState.gotoAndStop(8);
							return;
						}
						else if (MissionMain.taskList[i].status == 2)
						{
							igk.getSkin().getHeadName().GongNengHeadState.gotoAndStop(7);
						}
					}
				}
			}
			if (MissionMain.nextList != null && MissionMain.nextList.length != 0)
			{

				var len2:int=MissionMain.nextList.length;
				for (var j:int=0; j < len2; j++)
				{
					if (MissionMain.nextList[j].sendNpc == igk.dbID && MissionMain.nextList[j].status == 1)
					{
						igk.getSkin().getHeadName().GongNengHeadState.gotoAndStop(6);
						return;
					}
				}
			}
		}


		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
		}


		override public function getID():int
		{
			return 1007;
		}
		
		override public function get height():Number{
			return 485;
		}


	}
}



