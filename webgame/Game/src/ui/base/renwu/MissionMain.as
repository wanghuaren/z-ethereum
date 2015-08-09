package ui.base.renwu
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CountDownTool;
	import common.utils.CtrlFactory;
	import common.utils.GamePrintByTask;
	import common.utils.StringUtils;
	import common.utils.component.ButtonGroup;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import model.fuben.*;
	import model.guest.NewGuestTask;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.action.hangup.GamePlugIns;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.beibao.BeiBao;
	import ui.base.huodong.HuSong;
	import ui.base.huodong.HuoDongCountDownWindow;
	import ui.base.mainStage.UI_index;
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.base.npc.mission.MissionNPC;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIActMap;
	import ui.frame.UIAction;
	import ui.view.UIMessage;
	import ui.view.fubenui.TianMenZhenControlBar;
	import ui.view.view1.fuben.area.GuildPanel;
	import ui.view.view1.fuben.area.PKKingFuHuo;
	import ui.view.view1.xiaoGongNeng.Welcome;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view4.huodong.WuZiLianZhu_LianJi;
	import ui.view.view6.GameAlert;
	
	import world.FileManager;

	/**
	 *@author suhang
	 *@version 2012-5-2
	 * 任务主逻辑控制类  以及任务追踪
	 */
	public class MissionMain
	{
		//private var mc:Sprite;
		//主线自动任务，在lang里边设置，由策划配置
		public var autotask_main_level:int=0;
		//5秒自动任务，在lang里边设置，由策划配置
		public var autotask_5miao_level:int=0;

		private var m_mcTip:MovieClip=null;

		public function get mc():MovieClip
		{

			return UI_index.indexMC["mrt"]["missionMain"];
		}

		private static var _instance:MissionMain;

		//倒计时工具对象
		private var m_countDownTool:CountDownTool=null;

		private var m_countDownTool_Ren:CountDownTool=null;
		private var m_countDownTool_Gui:CountDownTool=null;

		public static function get instance():MissionMain
		{
			if (null == _instance)
			{
				_instance=new MissionMain();
			}

			return _instance;
		}

		private var bg:ButtonGroup;
		//最新已接任务
		private var newTaskId2:int=0;
		//最新完成任务
		private var newTaskId3:int=0;

		//副本的模块
		public var m_fubenModel:FuBenModel=null;


		/**
		 *	已接任务
		 */
		public static var taskList:Vector.<StructTaskList2>;

		/**
		 * 已接任务中需要的杀怪列表
		 */
		public static var taskMonsterList:Array=null;

		/**
		 *	可接任务
		 */
		public static var nextList:Vector.<StructNextList2>;
		/**
		 *	历史任务
		 *  2013-06-18
		 */
		public static var historyList:Vector.<int>=new Vector.<int>;

		//------------------
		//--new defines
		//------------------
		private var mc_normal_task:MovieClip;
		private var mc_special_task:MovieClip;
		private var special_task_event:TextEvent;

		private var hspace:int=2; //特殊任务下组件纵向间距
		private var taskShowType:int; //任务显示标记，0-普通板式，1-特殊板式
		private var inCopy:Boolean=false; //是否在副本中

		public function MissionMain()
		{
			autotask_main_level=int(Lang.getLabel("autotask_main_level"));
			autotask_5miao_level=int(Lang.getLabel("autotask_5miao_level"));
		}

		/**
		 *	移除 请点击继续
		 */
		public function removeTip():void
		{
			if (m_mcTip == null)
				m_mcTip=UI_index.indexMC["mrt"]["missionMain"]['mc_task_do'];
			if (m_mcTip && m_mcTip.parent)
			{
//				m_mcTip.parent.removeChild(m_mcTip);
				m_mcTip.visible=false;
			}
		}

		public function addTip():void
		{
			if (Welcome.instance().isOpen || Data.myKing.level > 10)
				return;
			if (m_mcTip == null)
				m_mcTip=UI_index.indexMC["mrt"]["missionMain"]['mc_task_do'];
			if (mc && m_mcTip)
			{
//				mc.addChild(m_mcTip);
				m_mcTip.visible=true;
			}

		}


		private function _hide_show(b:Boolean):void
		{
			if (b)
			{
				TweenLite.to(mc["mc_normalTask_bg"], 2, {alpha: 0.7});
				TweenLite.to(mc['specialTask']['task_bg'], 2, {alpha: 0.7});
				TweenLite.to(mc_normal_task['spMission']['scroll'], 2, {alpha: 0.7});

			}
			else
			{
				TweenLite.to(mc["mc_normalTask_bg"], 2, {alpha: 0.5});
				TweenLite.to(mc['specialTask']['task_bg'], 2, {alpha: 0.5});
				TweenLite.to(mc_normal_task['spMission']['scroll'], 2, {alpha: 0});
			}
		}

		private function _mc_onMouseEvent_Out(e:MouseEvent=null):void
		{
			_hide_show(false);

		}

		private function _mc_onMouseEvent_Over(e:MouseEvent=null):void
		{
			_hide_show(true);
		}

		public function init():void
		{


			mc.addEventListener(MouseEvent.ROLL_OUT, _mc_onMouseEvent_Out);
			mc.addEventListener(MouseEvent.ROLL_OVER, _mc_onMouseEvent_Over);

			mc_normal_task=mc["normalTask"];
			mc_normal_task.tabChildren=false;
			m_mcTip=mc['mc_task_do'];
			mc_special_task=mc["specialTask"];

			//指引箭头特殊处理
			UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].stop();
			
			if (null != mc_special_task["mc_effect"])
			{
				mc_special_task["mc_effect"].mouseEnabled=false;
			}
			mc_special_task.tabChildren=false;
			mc_special_task.visible=false;
			special_task_event=new TextEvent(TextEvent.LINK);

			removeTip();


//			bg=new ButtonGroup([mc_normal_task["btnMissionHas"], mc_normal_task["btnMissionCanRecv"], mc_normal_task["btnFuBenInfo"], mc_normal_task["btnFuBenInfo_sex_girl"]], 1);
			bg=new ButtonGroup([mc_normal_task["btnMissionHas"], mc_normal_task["btnMissionCanRecv"]], 1);
			bg.addEventListener(DispatchEvent.EVENT_DOWN_HANDER, downHander);
//			mc_normal_task["btnTask"].addEventListener(MouseEvent.CLICK, mcHandler);
			mc_special_task["btnAccept"].addEventListener(MouseEvent.CLICK, mcHandler);
			mc_special_task["btnContinue"].addEventListener(MouseEvent.CLICK, mcHandler);
			mc_special_task["btnSubmit"].addEventListener(MouseEvent.CLICK, mcHandler);
			mc_special_task["task_desc"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
			//玩家已接任务列表
			DataKey.instance.register(PacketSCTaskList.id, CTaskUserList);
			var vo:PacketCSTaskList=new PacketCSTaskList();
			vo.userid=int(PubData.roleID);
			DataKey.instance.send(vo);
			//玩家可接任务列表
			DataKey.instance.register(PacketSCTaskNextList.id, CTaskNextlist);
			var vo2:PacketCSTaskNextList=new PacketCSTaskNextList();
			vo2.userid=int(PubData.roleID);
			DataKey.instance.send(vo2);
			//完成任务返回   删除完成的任务
			DataKey.instance.register(PacketSCTaskComplete.id, SCTaskComplete);
			//任务领取
			DataKey.instance.register(PacketSCTaskTake.id, SCTaskTake);
			//删除已接任务
			DataKey.instance.register(PacketSCTaskCancel.id, CTaskCancel);
			//任务刷新
			DataKey.instance.register(PacketSCTaskDesc.id, CTaskDesc);
			//活动追踪
			DataKey.instance.register(PacketSCGetActionTrack.id, _SCGetActionTrack);
			_requestCSGetActionTrack();

			//新已接任务
			renwuEvent.instance.addEventListener(renwuEvent.NEWUSERTASK, newUserTask);
			//任务完成可提交
			renwuEvent.instance.addEventListener(renwuEvent.TASKCANSUBMIT, taskCanSubmit);
			//2013-06-19 andy 历史任务
			DataKey.instance.register(PacketSCHistoryTaskList.id, SCHistoryTaskListReturn);
			DataKey.instance.send(new PacketCSHistoryTaskList());
			//2013-06-19 andy 历史任务 更新
			DataKey.instance.register(PacketSCHistoryTaskUpdate.id, SCHistoryTaskUpdateReturn);
			DataKey.instance.register(PacketSCPkOneExchangeGrade.id, onPKScoreExchangeCallback);
			DataKey.instance.register(PacketSCCallBack.id, onSCCallback);
			DataKey.instance.register(PacketSCGuildMazeInfo.id, onGuildMazeInfoUpdate);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_UPDATE, bagUpdate);
			mc_normal_task['mc_fuben_panel'].visible=false;
			mc_normal_task['spMission'].visible=true;


			//mc_normal_task["btnFuBenInfo"].visible=false;
			//mc_normal_task["btnTask"].visible=true;


			m_fubenModel=FuBenModel.getInstance();
			m_fubenModel.addEventListener(FuBenEvent.FU_BEN_EVENT, _onFuBenListener);

			_hide_show(false);

		}

		private function onSCCallback(p:PacketSCCallBack):void
		{
			if (p.callbacktype == 100013001)
			{
				var tag:int=p.arrItemintparam[1].intparam;
				p.arrItemintparam[0].intparam=tag;
				Lang.showResult(p);
			}
		}

		private var _currentGuildMazeScore:int=0;

		private function onGuildMazeInfoUpdate(p:PacketSCGuildMazeInfo):void
		{
			//根据当前副本的索引值跳帧
			var _currentIndex:int=m_fubenModel.getCurrentIndex();
			if (_currentIndex == 1000130)
			{
				var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
				_currentGuildMazeScore=p.point;
				//更新帮派迷宫信息
				//当前积分
				_mc["tf_1"].text=_currentGuildMazeScore + "/1500";
				//最大积分1500
				if (p.point >= 1500)
				{
					_mc["score_desc"].gotoAndStop(2);
				}
				else
				{
					_mc["score_desc"].gotoAndStop(1);
				}
				//排名
				var top:int=p.index;
				if (top == 0)
				{
					//榜上无名
					_mc["tf_2"].text=Lang.getLabel("10045_pai_hang");
				}
				else
				{
					_mc["tf_2"].text=top.toString();
				}
				//更新排行榜
				var list:Vector.<StructGuildMazePlayerInfo2>=p.arrItemranks;
				var len:int=0;
				var info:StructGuildMazePlayerInfo2;
				var tf1:TextField;
				var tf2:TextField;
				var tf3:TextField;
				for (var i:int=1; i <= 5; i++)
				{
					tf1=_mc["a" + i];
					tf2=_mc["b" + i];
					tf3=_mc["c" + i];
					tf1.mouseEnabled=tf2.mouseEnabled=tf3.mouseEnabled=false;
					if (list.length < i)
					{
						tf1.visible=tf2.visible=tf3.visible=false;
						continue;
					}
					info=list[i - 1];
					if (info != null)
					{
						tf1.visible=tf2.visible=tf3.visible=true;
						tf2.text=info.name;
						tf3.text=info.point.toString();
					}
					else
					{
						tf1.visible=tf2.visible=tf3.visible=false;
					}
				}
				if (_mc["score_desc"].hasEventListener(MouseEvent.CLICK) == false)
				{
					MovieClip(_mc["score_desc"]).addEventListener(MouseEvent.CLICK, onGetMiGongAward5);
					_mc["reward_desc"].addEventListener(MouseEvent.CLICK, onShowBangPaiMiGongCondition);
					Lang.addTip(_mc["act_desc"], "bangPaiMiGong_activity_desc");
					Lang.addTip(_mc["score_desc"], "bangPaiMiGong_score_desc");
				}
			}
		}

		private function mcHandler(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "btnTask":
					Renwu.instance().open();
					break;
				case "btnAccept":
				case "btnContinue":
				case "btnSubmit":
					if (Welcome.instance().isOpen)
						Welcome.instance().winClose();

					if (MissionNPC.instance().isOpen)
					{
						MissionNPC.instance().mcHandler({name: "btnExcute"});
						return;
					}
					Renwu.textLinkListener_(special_task_event);
					break;
				default:
					break;
			}
		}

		/************通讯******************/
		/**
		 *	已接任务【刷新】
		 */
		private function CTaskUserList(p:IPacket):void
		{
			taskList=(p as PacketSCTaskList2).arrItemtasklist;
			if (taskList == null)
			{
				return;
			}

			var len:uint=taskList.length;
			for (var i:int=0; i < len; i++)
			{
				fillTask(taskList[i]);
			}
			userTaskChange();
			//检测伙伴任务【左上角伙伴头像】
			//UI_index.UIAct.updPetTask(true);
		}

		private function _taskMonsterList(taskList:Vector.<StructTaskList2>):void
		{
			if(taskList==null) return;
			taskMonsterList=[];
			var _taskStep:Pub_Task_StepResModel=null;
			var _len:uint=taskList.length;
			for (var i:int=0; i < _len; ++i)
			{
				_taskStep=XmlManager.localres.getPubTaskStepXml.getResPath(taskList[i].taskid) as Pub_Task_StepResModel;

				//如果是杀怪任务，找到要杀的怪物
				if (1 == _taskStep.step_sort)
				{
					taskMonsterList.push(_taskStep.req_id);
				}
			}
		}

		public function setmc_rowVisible(_isShow:Boolean):void
		{
			var rowMc:MovieClip = UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"];
			rowMc.visible = _isShow;
			if (_isShow)
			{
				rowMc.play();
			}
			else
			{
				rowMc.stop();
			}
		}

		/**
		 *	可接任务 【刷新】
		 */
		private function CTaskNextlist(p:IPacket):void
		{
			if (inCopy)
			{ //在副本中
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=false;
				setmc_rowVisible(false);
				MissionMain.nextList=(p as PacketSCTaskNextList2).arrItemtasklist;
			}
			else
			{
				MissionMain.nextList=(p as PacketSCTaskNextList2).arrItemtasklist;
				var len:int=MissionMain.nextList.length;
				//引导隐藏
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=false;
				setmc_rowVisible(false);
				for (var i:int=0; i < len; i++)
				{
					fillNext(nextList[i]);
					if (nextList[i].access_guide == 1)
					{
						//x显示引导
//						UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=true;
						setmc_rowVisible(true);
					}
				}

				nextTaskChange();
			}
		}

		/**
		 *	历史任务 【仅请求一次】
		 *  2013-06-19
		 */
		private function SCHistoryTaskListReturn(p:PacketSCHistoryTaskList):void
		{
			MissionMain.historyList=p.arrItemtasklist;
			//
		}

		/**
		 *	历史任务更新
		 *   2013-06-19
		 */
		private function SCHistoryTaskUpdateReturn(p:PacketSCHistoryTaskUpdate):void
		{
			MissionMain.historyList.push(p.taskid);
		}

		private function onPKScoreExchangeCallback(p:PacketSCPkOneExchangeGrade):void
		{
			//TODO 更新玩家自己的总分数
			if (Lang.showResult(p))
			{
				var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
				_mc["tf_3"].text=p.mygrade;
				var myScore:int=p.mygrade;
				this.updatePkQuest(myScore);
			}
		}

		private function updatePkQuest(myScore:int=-1):void
		{
			var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
			if (myScore == -1)
			{
				myScore=int(_mc["tf_3"].text);
			}
			else
			{
				_mc["tf_3"].text=myScore;
			}
			var stat:int=0;
			var hasFinished:Boolean=false;
			if (myScore >= 20)
			{
				//stat = this.getTaskStatusById(50500001);
				if (stat == 2)
				{
					hasFinished=true;
				}
			}
			if (myScore >= 50)
			{
				//stat = this.getTaskStatusById(50500002);
				if (stat == 2)
				{
					hasFinished=true;
				}
			}
			if (myScore >= 100)
			{
				//stat = this.getTaskStatusById(50500003);
				if (stat == 2)
				{
					hasFinished=true;
				}
			}
			MovieClip(_mc["btnQuest"]).gotoAndStop(hasFinished ? 2 : 1);
		}

		/**
		 *	背包牌子有变化,同步更新PK副本信息
		 */
		private function bagUpdate(e:DispatchEvent):void
		{
			//11800320
			var itemNum:int=Data.beiBao.getBeiBaoCountById(11800320);
			if (m_fubenModel != null && m_fubenModel.getCurrentIndex() == 100013100)
			{ //pk之王
				var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
				_mc["tf_2"].text=itemNum.toString();
			}
		}


		private function _requestCSGetActionTrack():void
		{
			var cs:PacketCSGetActionTrack=new PacketCSGetActionTrack();
			DataKey.instance.send(cs);
		}

		private var m_arrItemstate:Vector.<int>=null;

		private function _SCGetActionTrack(p:IPacket):void
		{
			var _p:PacketSCGetActionTrack=p as PacketSCGetActionTrack;
			if (_p.tag != 0)
			{
				Lang.showResult(_p);
				return;
			}

			m_arrItemstate=_p.arrItemstate;

			CTaskUserListRef();

		}


		/**
		 * 单个任务更新【被动接受】
		 * 接受npc任务，杀怪
		 */
		private function CTaskDesc(p:IPacket):void
		{
			var data:PacketSCTaskDesc=p as PacketSCTaskDesc;
			//如果可接任务列表有，则为点击接受任务
			var isNextTask:Boolean=false;
			if (MissionMain.nextList == null)
				return;
			for (var i:int=0; i < MissionMain.nextList.length; i++)
			{
				if (MissionMain.nextList[i].taskid == data.taskid)
				{
					isNextTask=true;
					//删除可接任务
					MissionMain.nextList.splice(i, 1);
					if (this.newTaskId2 == data.taskid)
						newTaskId2=0;
					if (this.newTaskId3 == data.taskid)
						newTaskId3=0;
					nextTaskChange();
					break;
				}
			}
			if (isNextTask)
			{
				//添加已接任务
				var structTaskList:StructTaskList2=new StructTaskList2();
				structTaskList.taskid=data.taskid;
				structTaskList.status=data.status;
				structTaskList.arrItemstate=data.arrItemstep;
				fillTask(structTaskList);
				taskList.push(structTaskList);
				//2012-06-26 andy 为了将最新已接任务排序在前边，特此标记
				newTaskId2=data.taskid;
				NewGuestTask.getInstance().onNextTask(data.taskid);

				renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.NEWUSERTASK, structTaskList));
				GameMusic.playWave(WaveURL.ui_receive_task);
				userTaskChange();
			}
			else
			{
				//更新已接任务
				for each (var stl:StructTaskList2 in MissionMain.taskList)
				{
					if (stl.taskid == data.taskid)
					{
						stl.arrItemstate=data.arrItemstep;
						stl.status=data.status;
						//任务状态(1可接受2未完成3未提交4不可接5失败)
						//打印面板 任务
						//2 正在进行中
						//3 任务完成
						
						if (0 == stl.status ||
							//1 == stl.status ||
							2 == stl.status || 3 == stl.status)
						{
							var taskid:int=data.taskid;
							var taskMode:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(taskid) as Pub_TaskResModel;
							//var taskStep:Pub_Task_StepResModel = XmlManager.localres.getPubTaskStepXml.getResPath(taskid);					
							var taskStepArr:Array=XmlManager.localres.getPubTaskStepXml.getResPath2(taskid) as Array;
							taskStepArr=taskStepArr.sortOn("task_step");

							for (var j:int=0; j < data.arrItemstep.length; j++)
							{
								var num:int=data.arrItemstep[j].num;
								var state:int=data.arrItemstep[j].state;

								var result:String=""; //Renwu.getTaskResult(data.taskid, data.arrItemstep);

								//有次数
								//0 和 2 一样
								//result= taskStep.task_target;

								//4是无次数的任务，不需要显示
								
								//if(4 != taskStep.step_sort &&
								if (4 != taskStepArr[j].step_sort && num > 0)
								{

									//result = Renwu.setTextValue(taskStep.task_target, [num]);
									result=Renwu.setTextValue(taskStepArr[j].task_target, [num]);
									result=Renwu.setTextColorByGamePrintTask(result, "00FF00", false);

									GamePrintByTask.Print(result);

									if (3 == data.status)
									{
										//var result_complete:String = taskMode.task_title + "(" + Lang.getLabel("20054_RenWu") +")";

										var result_complete:String=taskMode.task_title + "(" + Lang.getLabel("20054_RenWu") + ")";


										GamePrintByTask.Print(result_complete);
									}

								}
							}
						}

						if (3 == data.status)
						{
							//2012-06-26 andy 为了将最新完成任务排序在前边，特此标记
							newTaskId3=data.taskid;
							renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.TASKCANSUBMIT, stl));
						}
					}
				}
				userTaskChange(false);
			}

		}

		/**
		 *	提交任务【发送】
		 */
		private function CSTaskComplete(taskId:int):void
		{
			var client:PacketCSTaskComplete=new PacketCSTaskComplete();
			client.taskid=taskId;
			DataKey.instance.send(client);
		}

		/**
		 *	提交任务【返回】
		 */
		private function SCTaskComplete(p:IPacket):void
		{
			if (Lang.showResult(p))
			{
				var task:PacketSCTaskComplete=p as PacketSCTaskComplete;
				//	50500001 20
				//	50500002 50
				//	50500003 100
				if (task.taskid == 50500001 || task.taskid == 50500002 || task.taskid == 50500003)
				{
					var _currentIndex:int=m_fubenModel.getCurrentIndex();
					if (_currentIndex == 100013100)
					{
						this.updatePkQuest();
					}
				}
				UIMessage.showState(5);

				for (var i:int=0; i < MissionMain.taskList.length; i++)
				{
					if (MissionMain.taskList[i].taskid == task.taskid)
					{
						MissionMain.taskList.splice(i, 1);
					}
				}
				GameMusic.playWave(WaveURL.ui_finish_task);
				userTaskChange();
				var m:Pub_TaskResModel=GameData.getPubTaskXml().getResPath(task.taskid) as Pub_TaskResModel;
				NewGuestTask.getInstance().SCTaskComplete(task.taskid);
					//2012-08-08 andy 炫耀显示 2014-01-14 策划删除
					//showNiceTaskGift(task.taskid, task.rmb);
					//NewGuestTask.getInstance().SCTaskComplete(task.taskid);
			}
		}

		/**
		 *	领取任务 【返回】
		 */
		private function SCTaskTake(p:IPacket):void
		{
			if (Lang.showResult(p))
			{
				UIMessage.showState(4);
			}
		}

		/**
		 *	取消任务 【返回】
		 */
		private function CTaskCancel(p:IPacket):void
		{
			if (Lang.showResult(p))
			{
				for (var i:int=0; i < MissionMain.taskList.length; i++)
				{
					if (MissionMain.taskList[i].taskid == (p as PacketSCTaskCancel).taskid)
					{
						MissionMain.taskList.splice(i, 1);
					}
				}
				UIActMap.missionM.userTaskChange();
			}
		}

		//已接任务改变
		public function userTaskChange(isSort:Boolean=true):void
		{
			if(taskList==null||renwuEvent==null) return;
			//找到已接任务中的任务怪
			_taskMonsterList(taskList);

			//任务排序
			if (isSort)
			{
				taskList.sort(sortFunction);
			}


			CTaskUserListRef(true);
			//已接任务刷新后操作
			Renwu.allTaskStatus();
			renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.USERTASKCHANGE));
		}

		/**
		 *	根据任务分类排序
		 */
		private function sortFunction(a:Object, b:Object):int
		{
			if (a.taskSort > b.taskSort)
			{
				return 1;
			}
			else if (a.taskSort < b.taskSort)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		//可接任务改变
		private function nextTaskChange():void
		{
			nextList.sort(sortFunction);
			CTaskUserListRef();
			//未接任务刷新后操作
			Renwu.allTaskStatus();
			renwuEvent.instance.dispatchEvent(new DispatchEvent(renwuEvent.NEXTTASKCHANGE));
		}

		/**
		 *	任务追踪【显示列表】
		 */
		private function CTaskUserListRef(taskListChange:Boolean=false):void
		{
			var selectList:Object;
			var value:String="";
			var status:String="";
			var menu:String="";
			var result:String="";
			var arrayLen:int=0;
			selectList=sortTaskList();
			arrayLen=selectList.length;
			var taskMode:Pub_TaskResModel;
			var npc:Pub_NpcResModel;
			
			var shenWu60Index:int=getSheWuIndex(selectList);
			
			var shenWu60:String="<font color='#00fcff'>[福利]</font>极品神武、酷炫坐骑<a href='event:9999'> <u><font color='#49ff00'>领取</font></u></a>\n\n";
			for (var i:int=0; i < arrayLen; i++)
			{
				status="";
				taskMode=XmlManager.localres.getPubTaskXml.getResPath(selectList[i].taskid) as Pub_TaskResModel;
	
				if (taskMode == null)
					continue;
				//2014-09-28 60级极品神武、酷炫坐骑
				if(shenWu60Index==-1&&i==0&&Data.myKing.level>=30&&Data.myKing.Pay==0){
					value+=shenWu60;
				}
				selectList[i].sendNpc=taskMode.send_npc;

				menu="[" + Renwu.getTaskSort(taskMode.left_title) + "]";

				var king_level:String=int(taskMode.min_level) > 9 ? (taskMode.min_level + "") : (taskMode.min_level + "");

				status=status + taskMode.task_title + "<font color='#fd721f'>(" + Renwu.getTaskStatus(selectList[i]['status']) + ")</font>";

				if (selectList[i]['status'] == 3)
				{
					//回复
					npc=XmlManager.localres.getNpcXml.getResPath(taskMode.submit_npc) as Pub_NpcResModel;
					if (npc != null)
						result=" -" + Lang.getLabel("20049_RenWu") + " " + Renwu.getChuanSongText(npc.npc_id) + "\n";
					else
						result="任务：" + selectList[i].taskid + "lost submit_npc:" + taskMode.submit_npc;

				}
				else if (selectList[i]['status'] == 2)
				{
					//击杀
					result=Renwu.getTaskResult(selectList[i].taskid, selectList[i].arrItemstate);
				}
				else if (selectList[i]['status'] == 0)
				{

				}
				else if (selectList[i]['status'] == 4)
				{

				}
				else
				{
					//与XX对话
					npc=XmlManager.localres.getNpcXml.getResPath(taskMode.send_npc) as Pub_NpcResModel;
					//result=" -"+Lang.getLabel("20069_RenWu",[Renwu.getChuanSongText(npc.npc_id)+"\n"]);
					if (npc != null)
						result=" -" + Lang.getLabel("20069_RenWu", [Renwu.getChuanSongText(npc.npc_id)]) + "\n";
					else
						result="任务：" + selectList[i].taskid + " submit_npc:" + taskMode.submit_npc;
				}
				//不可接为红色
				var color:String;
				if (selectList[i]['status'] == 0 || selectList[i]['status'] == 4)
				{
//					color="#ff0000";
				}
				else
				{
					color=Renwu.getColorBySort(taskMode.task_sort);
					value=value + "<font color='" + color + "'>" + menu + "</font>"+status +"\n" + result;
					value+="\n";
				}
				//2014-09-28 60级极品神武、酷炫坐骑
				if(shenWu60Index==i&&Data.myKing.level>=30&&Data.myKing.Pay==0){
					value+=shenWu60;
				}
				
			}

			var _atres:Pub_Action_TargetResModel=null;

			if (arrayLen == 0)
			{
				if (null != m_arrItemstate)
				{
					for each (var targetID:int in m_arrItemstate)
					{
						_atres=XmlManager.localres.getPubActionTargetXml.getResPath(targetID) as Pub_Action_TargetResModel;
						if (null == _atres)
						{
							continue;
						}
						result=Renwu.setTextColor(_atres.action_target);
						value+=(_atres.action_ID + "\n" + result + "\n");
						value+="\n";
					}
				}


				mc_normal_task["txtMission"].htmlText=value;
				if (FuBenModel.getInstance().isAtInstance())
				{
					mc_normal_task["spMission"].visible=false;
				}
				else
				{
					mc_normal_task["spMission"].visible=true;
				}
				return;
			}
			if (null != taskMode)
			{
				taskShowType=taskMode.show_type;
			}
			else
			{
				taskShowType=1;
			}

			if (null != taskMode && taskMode.show_type == 1)
			{ //显示类型 为1则显示特殊任务面板，为2则显示正常任务面板
				//为了测试，暂定为1，考虑在显示特殊任务时，取消普通任务的数据更新
				if (inCopy == false)
				{ //不在副本中，则切换界面状态
					mc_special_task.visible=true;
					mc_normal_task.visible=false;
					UI_index.indexMC_mrt["missionHide"].visible=mc["mc_normalTask_bg"].visible=false;
				}

//				mc_special_task["task_name"].text=status;
				mc_special_task["task_name"].text=taskMode.task_title + "(" + king_level + Lang.getLabel("pub_ji") + ")";
				var ind:int=result.indexOf("1@");
				var ind2:int=result.indexOf("'>");
				var targetData:String=result.substring(ind, ind2);
				special_task_event.text=targetData;
				mc_special_task["task_desc"].htmlText=result;
				mc_special_task["task_reward"].text=Lang.getLabel("pub_jing_yan") + " " + taskMode.prize_exp + "	" + Lang.getLabel("pub_yin_liang") + " " + taskMode.prize_coin + "\n" + Lang.getLabel("pub_sheng_wang") + " " + taskMode.prize_rep;
				var state:int=selectList[0].status;
				mc_special_task["task_state"].gotoAndStop(state);

				mc_special_task["task_desc"].height=mc_special_task["task_desc"].textHeight + 4;
				mc_special_task["lbTaskReward"].y=mc_special_task["task_desc"].y + mc_special_task["task_desc"].height + hspace;
				mc_special_task["task_reward"].y=mc_special_task["lbTaskReward"].y + mc_special_task["lbTaskReward"].height + hspace;
				//更新道具奖励
				this.renderRewards(taskMode.task_id);
				this.renderTaskBtnState(state);
				return;
			}
			mc_special_task.visible=false;
			mc_normal_task.visible=true;
			mc_normal_task["txtMission"].htmlText=value;
			UI_index.indexMC_mrt["missionHide"].visible=mc["mc_normalTask_bg"].visible=true;
			if (inCopy)
			{
				mc["mc_normalTask_bg"].visible=false;
				if (!UI_index.indexMC_mrt["missionHide"].visible)
				{
					UI_index.indexMC_mrt["missionHide2"].visible=true;
				}
					//UI_index.indexMC_mrt["missionHide2"].visible = UI_index.indexMC_mrt["missionHide"].visible = mc["mc_normalTask_bg"].visible = false;
			}

			//增加活动连接,参考了烈焰.


			if (null != m_arrItemstate)
			{
				for each (var targetID:int in m_arrItemstate)
				{
					_atres=XmlManager.localres.getPubActionTargetXml.getResPath(targetID) as Pub_Action_TargetResModel;
					if (null == _atres)
					{
						continue;
					}
					result=Renwu.setTextColor(_atres.action_target);
					value+=(_atres.action_ID + "\n" + result + "\n");
					value+="\n";
				}
			}


			mc_normal_task["txtMission"].htmlText=value;
//			mc_normal_task["txtMission"].visible = true;


			mc_normal_task["txtMission"].height=mc_normal_task["txtMission"].textHeight + 10;
//			var sprite:Sprite=new Sprite();
//			sprite.addChild(mc_normal_task["txtMission"]);

			mc_normal_task["spMission"].source=mc_normal_task["txtMission"];
			if (FuBenModel.getInstance().isAtInstance())
			{
				mc_normal_task["spMission"].visible=false;
			}
			else
			{
				mc_normal_task["spMission"].visible=true;
			}

			mc_normal_task["spMission"].position=0;
			mc_normal_task["txtMission"].x=7;
		}

		private function renderRewards(taskId:int):void
		{
			var mcPic:MovieClip;
			var i:int;
			var num:int=0;
			var prizeArr:Array=XmlManager.localres.getPubTaskPrizeXml.getResPath2(taskId) as Array;

			var len:int=prizeArr.length;
			for (i=0; i < len; i++)
			{
				if (prizeArr[i].sort == 1 && (prizeArr[i].need_metier == 0 || prizeArr[i].need_metier == Data.myKing.metier))
				{
					var sbc:StructBagCell2=new StructBagCell2;
					sbc.itemid=prizeArr[i].item_id;
					sbc.num=prizeArr[i].item_num;
					Data.beiBao.fillCahceData(sbc);
					mcPic=mc_special_task["reward_" + (1 + num)];
					if (mcPic == null)
						continue;
//					mcPic["uil"].source=sbc.icon;
					ImageUtils.replaceImage(mcPic,mcPic["uil"],sbc.icon);
					mcPic["r_num"].text=sbc.num + "";
					mcPic["mc_color"].gotoAndStop(sbc.toolColor == 0 ? 1 : sbc.toolColor);
					mcPic.visible=true;
					mcPic.data=sbc;
					mcPic.y=mc_special_task["task_reward"].y + mc_special_task["task_reward"].height + hspace;
					ItemManager.instance().setToolTipByData(mcPic, sbc);
					//CtrlFactory.getUIShow().addTip(mcPic);
					num++;
				}
			}
			for (var j:int=num + 1; j < 5; j++)
			{
				mc_special_task["reward_" + j].visible=false;
			}
			if (num == 0)
			{
				mc_special_task["btnSubmit"].y=mc_special_task["btnAccept"].y=mc_special_task["btnContinue"].y=mc_special_task["task_reward"].y + mc_special_task["task_reward"].height + hspace;
					//mc_special_task["mc_effect"].y = mc_special_task["btnContinue"].y - 3;
			}
			else
			{
				mc_special_task["btnSubmit"].y=mc_special_task["btnAccept"].y=mc_special_task["btnContinue"].y=mc_special_task["reward_1"].y + mc_special_task["reward_1"].height + hspace;
					//mc_special_task["mc_effect"].y = mc_special_task["btnContinue"].y - 3;
			}

			//mc_special_task["task_bg"].height = mc_special_task["btnContinue"].y + mc_special_task["btnContinue"].height + 10;
			if (this.m_mcTip != null)
			{
				var p:Point=new Point();
					//p.x = mc_special_task["mc_effect"].x;//14;
					//p.y = mc_special_task["mc_effect"].y;
					//p = mc_special_task.localToGlobal(p);
					//p = mc_special_task.parent.globalToLocal(p);



//				this.m_mcTip.x = p.x + ;
					//this.m_mcTip.y = p.y+mc_special_task["mc_effect"].height+15;

			}
//			mc_special_task.visible=true;
		}

		private function renderTaskBtnState(state:int):void
		{
			if (state == 0)
			{

			}
			else if (state == 1)
			{ //可接
				mc_special_task["btnAccept"].visible=true;
				mc_special_task["btnContinue"].visible=false;
				mc_special_task["btnSubmit"].visible=false;
			}
			else if (state == 2)
			{ //已接
				mc_special_task["btnAccept"].visible=false;
				mc_special_task["btnContinue"].visible=true;
				mc_special_task["btnSubmit"].visible=false;
			}
			else if (state == 3)
			{ //已完成
				mc_special_task["btnAccept"].visible=false;
				mc_special_task["btnContinue"].visible=false;
				mc_special_task["btnSubmit"].visible=true;
			}
		}

		/**
		 * 重新定位specialTask组件内部布局
		 *
		 */
		private function repositionSpecialTask():void
		{

		}

		/**
		 *	任务完成，自动寻找npc
		 */
		private function newUserTask(e:DispatchEvent):void
		{
			//自动任务等级限制 25级
			//2012-08-12 取消限制,主线支线可以一直有
			//2012-11-01 andy 伙伴任务也可以自动
			//2012-12-05 andy 策划说家族环也可以
			var stl:StructTaskList2=e.getInfo as StructTaskList2;
			if (stl == null)
				return;

			if (Data.myKing.level <= autotask_main_level && stl.access_auto == 1)
			{

				var steps:Array=XmlManager.localres.getPubTaskStepXml.getResPath2(stl.taskid) as Array;
				var task_target:int=int(steps[0].task_target.split(":")[1]);



				if (stl.sendNpc != task_target)
				{
					GameAutoPath.seek(task_target);
				}
			}
		}

		/**
		 *	任务达成
		 *  @2012-11-21  andy
		 */
		private function taskCanSubmit(e:DispatchEvent):void
		{

			var stl:StructTaskList2=e.getInfo as StructTaskList2;
			if (stl == null)
				return;

			//2012-12-04 andy 自动完成任务
			if (stl.autoSubmit == 1)
			{
				CSTaskComplete(stl.taskid);
				return;
			}
			var m:Pub_TaskResModel=GameData.getPubTaskXml().getResPath(stl.taskid) as Pub_TaskResModel;
			if (stl.submit_guide == 1)
			{
				//显示引导
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=true;
				setmc_rowVisible(true);
			}
			else
			{
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=false;
				setmc_rowVisible(false);
			}
			//NewGuestTask.getInstance().taskCanSubmit(stl.taskid);

			NewGuestTask.getInstance().taskCanSubmit(stl.taskid, m.task_sort);
			if (Data.myKing.level <= autotask_main_level && stl.submit_auto == 1)
			{
				//2012-11-17 andy 策划说副本不用自动寻路
//				if (SceneManager.instance.isAtGameTranscript())
//					return;


//				if(NewGuestHandlers.isOpen_gameAlert1007)
//				{
//					return ;
//				}


				if (GamePlugIns.getInstance().running)
				{
					GamePlugIns.getInstance().stop();
					Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
				}
				if (UIAction.caiJiID)
				{
					UIAction.caiJiID=0;
					Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
				}

				stl=e.getInfo as StructTaskList2;
				//如果是伙伴任务，自动打开对话界面
				if (stl.submitNpc.toString().indexOf("302") == 0)
				{
					GameAutoPath.seek(stl.submitNpc);
					return;
				}

				var steps:Array=XmlManager.localres.getPubTaskStepXml.getResPath2(stl.taskid) as Array;
				if (stl.submitNpc == 0)
				{
					stl.submitNpc=XmlManager.localres.getPubTaskXml.getResPath(stl.taskid)["submit_npc"];
				}
				var task_target:int=int(steps[0].task_target.split(":")[1]);
				//防止npc对话面板，重复打开



				if (task_target != stl.submitNpc)
				{
					GameAutoPath.seek(stl.submitNpc);
				}
			}
			else
			{
				UIAction.stopAutoWalk();
				Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
			}
		}
		/**************************内部调用********************/
		/**
		 *	完成任务，领取奖励【策划要求奖励显示要闪眼一些，主界面中下】
		 *  @2012-08-08 andy
		 */
		private var mc_nice:MovieClip;

		private function showNiceTaskGift(taskId:int, rmb:int=0):void
		{
			if (mc_nice == null)
			{
				mc_nice=GamelibS.getswflink("game_index", "pop_task_gift") as MovieClip;
				if (mc_nice == null)
					return;
				mc_nice.mouseEnabled=mc_nice.mouseChildren=false;
				PubData.AlertUI.addChild(mc_nice);
			}

			mc_nice.gotoAndStop(1);
			var task:StructTaskList2=new StructTaskList2();
			task.taskid=taskId;
			this.fillTask(task);


			mc_nice["mc_content"]["txt_task_name"].text=task.task_name;
			var show:String="";
			if (task.prize_exp > 0)
			{
				show+=Lang.getLabel("pub_jing_yan") + " : <font color='#8afd5c'>" + int(task.prize_exp * rmb / 100) + "</font>    ";
			}
			if (task.prize_coin > 0)
			{
				show+=Lang.getLabel("pub_yin_liang") + " : <font color='#8afd5c'>" + int(task.prize_coin * rmb / 100) + "</font>    ";
			}
			if (task.prize_rep > 0)
			{
				show+=Lang.getLabel("pub_wei_wang") + " : <font color='#8afd5c'>" + int(task.prize_rep * rmb / 100) + "</font>    ";
			}
			mc_nice["mc_content"]["jingyan"].htmlText=show;


			mc_nice.x=(GameIni.MAP_SIZE_W - mc_nice.width) / 2;
			mc_nice.y=GameIni.MAP_SIZE_H - 220;
			mc_nice.play();
			//mc_nice.alpha=0;

			//TweenLite.to(mc_nice,3,{alpha:1,onComplete:showNiceTaskGiftComplete});
		}

//		private function showNiceTaskGiftComplete():void{
//			if(mc_nice!=null&&mc_nice.parent!=null)
//				TweenLite.to(mc_nice,.5,{alpha:0,onComplete:HideNiceTaskGiftComplete});
//		}
//		private function HideNiceTaskGiftComplete():void{
//			if(mc_nice!=null&&mc_nice.parent!=null)	
//				PubData.AlertUI.removeChild(mc_nice);
//		}

		private function downHander(e:DispatchEvent):void
		{
			switch (e.getInfo.name)
			{
				case "btnMissionHas":
					mc_normal_task['mc_fuben_panel'].visible=false;
					mc_normal_task['spMission'].visible=true;
//					mc_normal_task['txtMission'].visible=true;
					CTaskUserListRef();
					break;
				case "btnMissionCanRecv":
					mc_normal_task['mc_fuben_panel'].visible=false;
					mc_normal_task['spMission'].visible=true;
//					mc_normal_task['txtMission'].visible=true;
					CTaskUserListRef();
					break;
//				case "btnFuBenInfo":
//
//					mc_normal_task['spMission'].visible = mc_normal_task['btnMissionHas'].visible=mc_normal_task['btnMissionCanRecv'].visible=mc_normal_task['txtMission'].visible=false;
//					_handleFubenPanel();
//					break;
				case "btnFuBenInfo_sex_girl":
					mc_normal_task['spMission'].visible=false;
//					mc_normal_task['txtMission'].visible=false;
					_handleFubenPanel();
					break;
				default:
					break;
			}
		}

		private function _onFuBenListener(e:FuBenEvent):void
		{
			var _sort:int=e.sort;

			var _currentIndex:int=m_fubenModel.getCurrentIndex();

			switch (_sort)
			{
				case FuBenEvent.FU_BEN_EVENT_ENTRY:
					_instance.inCopy=true;
//					UI_index.indexMC_mrt["missionMain"]["normalTask"]["mc_row"].visible=false;
					setmc_rowVisible(false);
					UI_index.indexMC_mrt["missionMain"]["normalTask"]['mc_fuben_panel']["mc_row"].visible=false;
					UI_index.indexMC_mrt["missionMain"]["normalTask"]['mc_fuben_panel']["mc_row"].stop();
					UI_index.indexMC["mrt"]["missionMain"].visible=true;
					UI_index.indexMC["mrt"]["missionHide"].visible=false;
					UI_index.indexMC["mrt"]["missionHide2"].visible=false;
					//--切换到副本界面
					mc_special_task.visible=false;
					mc["mc_normalTask_bg"].visible=false;
//					UI_index.indexMC_mrt["missionHide"].visible = 
					mc_normal_task.visible=true;
					//--end
					//mc_normal_task['btnTask'].visible=false; //打开任务列表窗口按钮
					bg.selectedIndex=2;
//					bg.outDownHander(mc_normal_task['btnFuBenInfo'],false);
					mc_normal_task['spMission'].visible=false;
					_handleFubenPanel();
					if (null != this.m_countDownTool)
					{
						this.m_countDownTool.stop();
					}
					if(SceneManager.instance.showGuaJiRow()){
						UI_index.indexMC_mrb["mc_row"].visible=true;
						UI_index.indexMC_mrb["mc_row"].play();
					}else{
						UI_index.indexMC_mrb["mc_row"].visible=false;
						UI_index.indexMC_mrb["mc_row"].stop();
					}
					break;
				case FuBenEvent.FU_BEN_EVENT_LEAVE:
					_instance.inCopy=false;
					//--切换到任务界面
					mc_special_task.visible=taskShowType == 1;
					UI_index.indexMC_mrt["missionHide"].visible=mc["mc_normalTask_bg"].visible=mc_normal_task.visible=!mc_special_task.visible;
					//--end
//					mc_normal_task['btnFuBenInfo'].visible=false;
					//mc_normal_task['btnTask'].visible=true;
					bg.selectedIndex=0;
					bg.outDownHander(mc_normal_task['btnMissionHas'], false);
					_handleFubenPanel();
					if (null != this.m_countDownTool)
					{
						this.m_countDownTool.stop();
					}
					CTaskUserListRef();
					break;
				case FuBenEvent.FU_BEN_EVENT_UPDATA:
					if (_currentIndex == 210000200)
					{
						//暴走答题副本
						this.mc.visible=false;
						UI_index.indexMC["mrt"]["missionHide"].visible=false;
						UI_index.indexMC["mrt"]["missionHide2"].visible=false;
						return;
					}
					//--切换到副本界面
					if (mc_special_task.visible)
						mc_special_task.visible=false;
					if (mc_normal_task.visible == false)
					{
						mc_normal_task.visible=true;
//						UI_index.indexMC_mrt["missionHide"].visible = true;
						mc["mc_normalTask_bg"].visible=false;
					}
					//--end
					//bg.selectedIndex = 2;
//					if (2 == bg.selectedIndex)
//					{
//						_handleFubenPanelUpdata();
//					}
					_handleFubenPanelUpdata();
					break;
				case FuBenEvent.CLOSE_FUBEN_INFO:
					mc_normal_task["mc_fuben_panel"].visible=false;

//					if(FuBenModel.getInstance().isAtInstance())
//					{
//						mc_normal_task["spMission"].visible = false;
//						mc_normal_task["txtMission"].visible = false;
//					}
//					else
//					{
//						mc_normal_task["spMission"].visible = true;
//						mc_normal_task["txtMission"].visible = true;
//					}
//					

					break;
				default:
					break;
			}
		}



		/**
		 * 14: //神龙图腾
					15: //云南天  	5: //四神器1(玄剑诛魔) 或 门派捉贼  	6: //四神器2(冰海急斩)
					7: //四神器3(魔域求生)  	8: //四神器4(决战九天) 	9: //福溪村幻境
					10: //鬼狱 	11: //神龙图腾   *21:	//家族掌教 	30: // 王者之剑活动(争夺PK之王的) 霸主圣剑
						120:    130: //温泉    140: //0010562: 新增加PK之王活动  160: //生死劫  	170: //死亡深渊
					200: //玄仙海战  210: // 始皇魔窟
					210000000: // 五子连珠
					100011104: // 躲猫猫
					1001: // 20级装备副本副本界面
					210000300: //领地争夺  	210000400: //要塞争夺  	210000500: //皇城争霸
					1000075:  1000130:
					210000400: //要塞争夺  	210000500: //皇城争霸
					1000075:  1000130:
					100013100: //PK之王  100011000: //天门阵  	100013700: //新增副本
					100006800: //决战战场  100013901: //皇城争霸
					 * 100011200//天书副本
					 * * 2022004000//镇魔窟
					 * 
		 *
		 */
		private function _handleFubenPanelUpdata():void
		{
			var _currentIndex:int=_handleFubenPanel();
			var _callback:PacketSCCallBack=m_fubenModel.getCallbackData();
			var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
			_mc.removeEventListener(MouseEvent.CLICK,fubenPanelClick);
			_mc.addEventListener(MouseEvent.CLICK,fubenPanelClick);
			if (null == _callback && null == m_fubenModel.callbackData_GuildFightUpd && m_fubenModel.bangPaiZhanData == null)
			{
				return;
			}

			//当前发了一个温泉消息，但是当前不在温泉中，因此抛弃该消息。
			if (_callback != null && _callback.callbacktype == 130 && _currentIndex != _callback.callbacktype)
			{
				return;
			}
			var tipArr:Array=null;
			var hostName:String=null;
			var f:String=null;
			var owner:String=null;
			var count:String=null;
			var index:int=0;
			switch (_currentIndex)
			{
				case 2022004000: //
					_mc['txt1'].text=_callback.arrItemintparam[0].intparam;
					_mc['txt2'].text=_callback.arrItemintparam[1].intparam;
					_mc['txt3'].text=_callback.arrItemintparam[2].intparam;
					var _second:Number=_callback.arrItemintparam[3].intparam * 1000;
					if(_second<0)_second=0;
					_mc['txt_time'].text=StringUtils.getStringDayTime(_second); //剩余时间(单位秒)
					
					var bag:StructBagCell2=ItemManager.instance().getBagCell(10016);
					bag.itemid=11800321;
					Data.beiBao.fillCahceData(bag);
					bag.num=Data.beiBao.getBeiBaoCountById(bag.itemid);
					ItemManager.instance().setToolTipByData(_mc["pic1"],bag);
					_mc["pic1"]["txt_num"].visible=true;
					
					
					bag=ItemManager.instance().getBagCell(10017);
					bag.itemid=11800322;
					Data.beiBao.fillCahceData(bag);
					bag.num=Data.beiBao.getBeiBaoCountById(bag.itemid);
					ItemManager.instance().setToolTipByData(_mc["pic2"],bag);
					_mc["pic2"]["txt_num"].visible=true;
					
					
					Lang.addTip(_mc['btnFangZhi1'],"10044_zmg");
					Lang.addTip(_mc['btnFangZhi2'],"10045_zmg");
					Lang.addTip(_mc['btnZMGRefresh'],"10046_zmg");
					Lang.addTip(_mc['btnZMGDesc'],"10047_zmg",350);
					
					break;
				case 100011200: //天书副本
					//{当前关卡、剩余怪物、总怪物、经验、天数碎片、剩余时间}
					_mc['curr_cus'].text=_callback.arrItemintparam[0].intparam;
					_mc['surplus_monster'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
					_mc['experience'].text=_callback.arrItemintparam[3].intparam;
					_mc['book_fragment'].text=_callback.arrItemintparam[4].intparam;
					var _second:Number=_callback.arrItemintparam[5].intparam * 1000;
					_mc['tf_time'].text=StringUtils.getStringDayTime(_second); //剩余时间(单位秒)


					break;
				case 14: //神龙图腾
					_mc["tuichufuben"].x=115;
					_mc["tuichufuben"].y=180;
					var percent:int=_callback.arrItemintparam[0].intparam;
					if (percent == 0)
					{
						percent=1;
					}
					_mc['mcHpBar']["m"].scaleX=percent * 0.01;
					_mc['tf0'].text=_callback.arrItemintparam[6].intparam.toString();
					//_callback.arrItemintparam[1]; //已杀怪物量
					//_callback.arrItemintparam[2]; //总怪物量
					_mc['tf_num_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
					_mc['tf_num_0'].text=_callback.arrItemintparam[3].intparam + "/" + _callback.arrItemintparam[4].intparam; //当前波次/总波茨
					//_callback.arrItemintparam[4]; //总波次
					var _second:Number=_callback.arrItemintparam[5].intparam * 1000;
					_mc['tf_time'].text=StringUtils.getStringDayTime(_second); //剩余时间(单位秒)
					break;
				case 15: //云南天
					_mc['tuichufuben'].x=115;
					if (_callback.arrItemintparam[0].intparam <= 0)
					{
						_mc['mcHpBar'].gotoAndStop(1); //当前血量百分比 [1-100]
					}
					else
					{
						_mc['mcHpBar'].gotoAndStop(_callback.arrItemintparam[0].intparam); //当前血量百分比 [1-100]
					}
					//_callback.arrItemintparam[1]; //已杀怪物量
					//_callback.arrItemintparam[2]; //总怪物量
					_mc['tf_num_0'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
					_mc['tf_num_1'].text=_callback.arrItemintparam[3].intparam; //当前波次
					//_callback.arrItemintparam[4]; //总波次
					_second=_callback.arrItemintparam[5].intparam * 1000;
					_mc['tf_time'].text=StringUtils.getStringDayTime(_second); //剩余时间(单位秒)
					break;
				case 5: //四神器1(玄剑诛魔) 或 门派捉贼
					if (_callback.arrItemintparam.length >= 5)
					{
						_mc['tf_0'].text=_callback.arrItemintparam[0].intparam; //血量
						_mc['tf_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
						//_callback.arrItemintparam[1]; //已杀怪物量
						//_callback.arrItemintparam[2]; //总怪物量
						//_callback.arrItemintparam[3]; //波次
						//_callback.arrItemintparam[4]; //总波次
						_mc['tf_2'].text=_callback.arrItemintparam[3].intparam + "/" + _callback.arrItemintparam[4].intparam;
					}
					break;
				case 6: //四神器2(冰海急斩)

					//_callback.arrItemintparam[0]; //时间(整型，单位秒)
					//_callback.arrItemintparam[1]; //已杀怪物量
					//_callback.arrItemintparam[2]; //总怪物量
					//_callback.arrItemintparam[3]; //波次

					_mc['tf_0'].text=StringUtils.getStringDayTime(_callback.arrItemintparam[0].intparam * 1000);
					_mc['tf_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam
					_mc['tf_2'].text=_callback.arrItemintparam[3].intparam;

					break;
				case 7: //四神器3(魔域求生)

					//_callback.arrItemintparam[0]; //剩余怪物数量
					//_callback.arrItemintparam[1]; //已杀怪物量
					//_callback.arrItemintparam[2]; //总怪物量
					//_callback.arrItemintparam[3]; //波次

					_mc['tf_0'].text=_callback.arrItemintparam[0].intparam;
					_mc['tf_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam
					_mc['tf_2'].text=_callback.arrItemintparam[3].intparam;

					break;
				case 8: //四神器4(决战九天)

					//_callback.arrItemintparam[0]; //当前血量百分比 [1-100]
					//_callback.arrItemintparam[1]; //已杀怪物量
					//_callback.arrItemintparam[2]; //总怪物量
					//_callback.arrItemintparam[3]; //波次

					_mc['mcHpBar'].gotoAndStop(_callback.arrItemintparam[0].intparam); //当前血量百分比 [1-100]
					_mc['tf_0'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam
					_mc['tf_1'].text=_callback.arrItemintparam[3].intparam;


					break;
				case 9: //福溪村幻境

					//_callback.arrItemintparam[0]; //剩余怪物数量
					//_callback.arrItemintparam[1]; //已杀怪物数量
					//_callback.arrItemintparam[2]; //副本怪物数量
					//_callback.arrItemintparam[3]; //副本剩余时间(单位秒)

					//_mc['tf_0'].text = _callback.arrItemintparam[0].intparam;
					//_mc['tf_0'].visible = false;
					if (_mc['tuichufuben'])
					{
						_mc['tuichufuben'].x=115;
					}

					_mc['tf_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam
					_mc['tf_2'].text=StringUtils.getStringDayTime(_callback.arrItemintparam[3].intparam * 1000);
					if (_callback.arrItemintparam.length >= 5)
					{
						var _iShowTip:int=_callback.arrItemintparam[4].intparam;
												}
					break;
				case 10: //鬼狱

					//_callback.arrItemintparam[0]; //剩余怪物数量
					//_callback.arrItemintparam[1]; //所在区域
					//_callback.arrItemintparam[2]; //副本剩余时间(单位秒)

					_mc['tf_0'].text=_callback.arrItemintparam[0].intparam;
					_mc['tf_1'].text=_callback.arrItemintparam[1].intparam;
					_mc['tf_2'].text=StringUtils.getStringDayTime(_callback.arrItemintparam[2].intparam * 1000);

					break;
				case 11: //神龙图腾
//					_frameIndex = 7;
					break;
				case 21:
					//家族掌教
					if (null != m_fubenModel.callbackData_GuildFightUpd)
					{
						var p:PacketSCGetGuildFightInfoUpdate2=m_fubenModel.callbackData_GuildFightUpd;

						for (var j:int=0; j < 4; j++)
						{
							for (var k:int=0; k < p.arrItemFightInfo.length; k++)
							{

								if (j == p.arrItemFightInfo[k].flag_no)
								{

									if ("" != p.arrItemFightInfo[k].guildName)
									{
										_mc["txt_flag_" + j.toString()].htmlText="<font color='#00ccff'>" + p.arrItemFightInfo[k].guildName + "</font>" + "<font color='#fff5d2'>占领</font>";

											//_mc["mc_flag_" + j.toString()].visible = true;

											//if(1 == mc["mc_flag_" + j.toString()].currentFrame)
											//{
											//	mc["mc_flag_" + j.toString()].gotoAndPlay(1);
											//}

									}
									else
									{
										_mc["txt_flag_" + j.toString()].htmlText="";

											//_mc["mc_flag_" + j.toString()].visible = false;

											//_mc["mc_flag_" + j.toString()].gotoAndStop(1);
									}

									break;
								}
							}

						}

						//						
						_mc["txt_time"].text=GuildPanel.instance.getskillcolltime(p.last_time);

						_mc["tf_0"].removeEventListener(MouseEvent.CLICK, guildFightClick);
						_mc["tf_0"].addEventListener(MouseEvent.CLICK, guildFightClick);

						_mc["tf_1"].removeEventListener(MouseEvent.CLICK, guildFightClick);
						_mc["tf_1"].addEventListener(MouseEvent.CLICK, guildFightClick);

						_mc["tf_2"].removeEventListener(MouseEvent.CLICK, guildFightClick);
						_mc["tf_2"].addEventListener(MouseEvent.CLICK, guildFightClick);

						_mc["tf_3"].removeEventListener(MouseEvent.CLICK, guildFightClick);
						_mc["tf_3"].addEventListener(MouseEvent.CLICK, guildFightClick);

					}

					break;
				case 30: // 王者之剑活动(争夺PK之王的) 霸主圣剑

//					1。活动剩余时间
//					2。持有人名字
//					3。轩辕剑当前持有人的血量百分比
//					4。我和我的伙伴对外的伤害输出总量
//					新的协议类型“30”，数组中的变量顺序同上

					_mc['tf_1'].text=_callback.arrItemcharparam[0].charparam; //_callback.arrItemintparam[1].intparam;
					if (_callback.arrItemintparam[1].intparam <= 0)
					{
						_mc['mcHpBar'].gotoAndStop(1); //当前血量百分比 [1-100]
					}
					else
					{
						_mc['mcHpBar'].gotoAndStop(_callback.arrItemintparam[1].intparam); //当前血量百分比 [1-100]
					}
					_mc['tf_3'].text=_callback.arrItemintparam[2].intparam;

					break;
				case 120:
				case 121:
					var _sexGirlID:int=_callback.arrItemintparam[0].intparam + 1;
					if(_currentIndex==121)_sexGirlID=_sexGirlID+10;
					_mc['uil_sexgirl'].source=FileManager.instance.getIconSexGirl(_sexGirlID.toString());
					var _t:int=0;
					if (_callback.arrItemintparam.length > 1)
						_t=_callback.arrItemintparam[1].intparam * 1000;
					var _Pub_ConvoyResModel:Pub_ConvoyResModel=XmlManager.localres.getConvoyXml.getResPath(_sexGirlID) as Pub_ConvoyResModel;
					var _sexGirlName:String=_Pub_ConvoyResModel.name;
					_mc['tf_sex_girl_name'].htmlText=ResCtrl.instance().getFontByColorMonster(_sexGirlName, _sexGirlID);
					//_mc['tf_sex_girl_target'].addEventListener(TextEvent.LINK, _targetPlaceListener);
					//_mc['tf_sex_girl_target'].htmlText=Renwu.getChuanSongText(TARGET_SEX_GIRL_NPC_ID, "", "7bac1b", false);
					//_mc['tf_sex_girl_jiangli'].htmlText =Lang.getLabel("pub_jing_yan")+"："+ HuSong.getInstance().getExp(_Pub_ConvoyResModel) + Lang.getLabel("pub_yin_liang")+"："+ HuSong.getInstance().getCoin(_Pub_ConvoyResModel);

					//2014-01-13 破损镖车 奖励为0.3
					var rate:int=100;
					var realCoin:int=HuSong.getInstance().getCoin(_Pub_ConvoyResModel);
					if (_callback.arrItemintparam.length > 3 && _callback.arrItemintparam[3].intparam == 1)
					{
						rate=30;
						realCoin=realCoin - 500000;
						if (realCoin <= 0)
							realCoin=500000;
					}
					_mc['tf_sex_girl_jiangli'].htmlText=Lang.getLabel("40072_husong_sex_girl_jiangli", [HuSong.getInstance().getExp(_Pub_ConvoyResModel) * rate / 100, realCoin]);

					//======whr 经验和银两写反了====================
					//双倍经验是否开启
//					if (HuSong.getInstance().huSongIsDouble)
//					{
//						_mc['tf_sex_girl_jiangli'].htmlText=Lang.getLabel("40072_husong_sex_girl_jiangli", [HuSong.getInstance().getCoin(_Pub_ConvoyResModel) * 2, HuSong.getInstance().getExp(_Pub_ConvoyResModel) * 2]);
//
//					}
//					else
//					{
//						_mc['tf_sex_girl_jiangli'].htmlText=Lang.getLabel("40072_husong_sex_girl_jiangli", [HuSong.getInstance().getCoin(_Pub_ConvoyResModel), HuSong.getInstance().getExp(_Pub_ConvoyResModel)]);
//					}

					_mc['btnSexGirl_FangQi'].addEventListener(MouseEvent.CLICK, _onbtnSexGirl_FangQi);
					_mc['btnSexGirl_Auto'].addEventListener(MouseEvent.CLICK, _onbtnSexGirl_Auto);
										if (null == this.m_countDownTool)
					{
						this.m_countDownTool=new CountDownTool(_mc['tf_remainderTime']);
					}
					if (!this.m_countDownTool.isRunning())
					{
						this.m_countDownTool.start(_t);
					}
					this.m_countDownTool.updata(_t);
					break;
				case 140: //0010562: 新增加PK之王活动
//					_mc["btnGuaJi_fuben"].x = 30;
//					_mc["btnGuaJi_fuben"].y = 180;
//					_mc["tuichufuben"].x = 115;
//					_mc["tuichufuben"].y = 180;
//					//剩余时间
//					//剩余命的个数
					var _remainderLife:int=_callback.arrItemintparam[1].intparam;
					for (var i:int=1; i <= 3; ++i)
					{
						if (_remainderLife >= i)
						{
							_mc['mcRemainderLife_' + i].gotoAndStop(2);
						}
						else
						{
							_mc['mcRemainderLife_' + i].gotoAndStop(1);
						}

						//暂时隐藏掉，不知道那天策划又要改回来。
						if (i >= 2)
						{
							_mc['mcRemainderLife_' + i].visible=false;
						}
						else
						{
							_mc['mcRemainderLife_' + i].visible=true;
						}
					}
					//伤害值
					if (_callback.arrItemintparam.length >= 3)
						_mc['tf_total'].text=_callback.arrItemintparam[2].intparam;
					if (_callback.arrItemintparam.length >= 4)
						_mc['tf_shengyu_renshu'].text=_callback.arrItemintparam[3].intparam;
					break;
				case 160: //生死劫
					if (_callback.arrItemintparam.length >= 7)
					{
						//血量
						_mc['tf_0'].text=_callback.arrItemintparam[0].intparam + "/" + _callback.arrItemintparam[6].intparam;
						_mc['tf_1'].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
						_mc['tf_2'].text=_callback.arrItemintparam[3].intparam + "/" + _callback.arrItemintparam[4].intparam;
						_mc['tf_3'].text=_callback.arrItemintparam[5].intparam;
					}
					break;
				case 170: //死亡深渊

					var _shaRenShu:int=_callback.arrItemintparam[0].intparam;
					var _xiaYiChengTiaoJian:int=10;
					// 杀人数/10
					_mc['tf_0'].text=_shaRenShu + "/" + _xiaYiChengTiaoJian;

					//倒计时
					_mc['tf_1'].text=StringUtils.getStringDayTime((_callback.arrItemintparam[2].intparam * 1000));

					if (_shaRenShu >= _xiaYiChengTiaoJian && 20200028 != SceneManager.instance.currentMapId)
					{
						StringUtils.setEnable(_mc['btnXiaYi_Ceng']);
					}
					else
					{
						StringUtils.setUnEnable(_mc['btnXiaYi_Ceng']);
					}
					break;
				case 200: //玄仙海战
					//青龙军:#param分
					_mc['tf_0'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_0", [_callback.arrItemintparam[0].intparam]);
					//朱雀军:#param分
					_mc['tf_1'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_1", [_callback.arrItemintparam[1].intparam]);
					//炫舞军:#param分
					_mc['tf_2'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_2", [_callback.arrItemintparam[2].intparam]);
					//青龙主将
					if (_callback.arrItemintparam[3].intparam <= 0)
					{
						_mc['tf_3'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_3", [Lang.getLabel("pub_zhen_wang")]);
					}
					else
					{
						_mc['tf_3'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_3", [(_callback.arrItemintparam[3].intparam + "%" + Lang.getLabel("pub_sheng_ming"))]);
					}
					//朱雀主将
					if (_callback.arrItemintparam[4].intparam <= 0)
					{
						_mc['tf_4'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_4", [Lang.getLabel("pub_zhen_wang")]);
					}
					else
					{
						_mc['tf_4'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_4", [(_callback.arrItemintparam[4].intparam + "%" + Lang.getLabel("pub_sheng_ming"))]);
					}
					//炫舞主将
					if (_callback.arrItemintparam[5].intparam <= 0)
					{
						_mc['tf_5'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_5", [Lang.getLabel("pub_zhen_wang")]);
					}
					else
					{
						_mc['tf_5'].htmlText=Lang.getLabel("40083_Da_Hai_Zhan_5", [(_callback.arrItemintparam[5].intparam + "%" + Lang.getLabel("pub_sheng_ming"))]);
					}
					break;
				case 210: // 始皇魔窟
					_mc["tuichufuben"].x=115;
					_mc["tuichufuben"].y=180;
					_t=_callback.arrItemintparam[0].intparam;
					if (null == this.m_countDownTool)
					{
						this.m_countDownTool=new CountDownTool(_mc['tf_remainderTime']);
					}
					if (!this.m_countDownTool.isRunning())
					{
						this.m_countDownTool.start(_t);
					}
					this.m_countDownTool.updata(_t, false);

					break;
				case 210000000: // 五子连珠
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=224;
					var __s:int=0;
					for (var i:int=1; i <= 36; ++i)
					{
						__s=_callback.arrItemintparam[(i - 1)].intparam;
						if (__s <= 0)
						{
							_mc['mcQiZi']['mc' + i].visible=false;
						}
						else
						{
							_mc['mcQiZi']['mc' + i].visible=true;
							_mc['mcQiZi']['mc' + i].gotoAndStop(__s);
						}
					}
					//累计连击
					_mc['tf_0'].text=_callback.arrItemintparam[37].intparam;
					//最高连击
					_mc['tf_1'].text=_callback.arrItemintparam[38].intparam;
					//历史累计连击
					_mc['tf_2'].text="0";
					//历史最高连击
					_mc['tf_3'].text="0";

					var _wz_lianji:int=_callback.arrItemintparam[36].intparam;
					if (_wz_lianji <= 1)
					{
						//WuZiLianZhu_LianJi.getInstance().winClose();
					}
					else
					{
						if (!WuZiLianZhu_LianJi.getInstance().isOpen)
						{
							WuZiLianZhu_LianJi.getInstance().open(true);
						}
						WuZiLianZhu_LianJi.getInstance().setNumber(_wz_lianji);
					}

					//FuBenModel.getInstance().getPacketSCGetFiveMaxRecord();   

					break;
				case 100011104: // 躲猫猫
					//100011104 躲猫猫副本信息
					//第一个int 表示阶段0为准备阶段1为躲藏阶段2为找人阶段
					//第二个int表示剩余时间
					//第三个int表示玩家当前状态0是初始，1是人，2是鬼，3是鬼但是被找到了
					//第四个int表示玩家当前是鬼形象
					//第五各int表示找到鬼的个数
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=180;

					//初始
					if (0 == _callback.arrItemintparam[2].intparam)
					{
						_mc['mckong'].visible=true;
						_mc['mcRen'].visible=false;
						_mc['mcGui'].visible=false;
					}
					//人
					else if (1 == _callback.arrItemintparam[2].intparam)
					{
						_mc['mckong'].visible=false;
						_mc['mcRen'].visible=true;
						_mc['mcGui'].visible=false;
						if (_callback.arrItemintparam[0].intparam >= 0 && _callback.arrItemintparam[0].intparam <= 2)
						{
							_mc['mcRen']['tf_0'].htmlText=Lang.getLabelArr("arrHuoDong_DuoMaoMao")[_callback.arrItemintparam[0].intparam];
						}
						else
						{
							_mc['mcRen']['tf_0'].htmlText="";
						}

						_t=_callback.arrItemintparam[1].intparam;
						if (null == this.m_countDownTool_Ren)
						{
							this.m_countDownTool_Ren=new CountDownTool(_mc['mcRen']['tf_remainderTime']);
						}
						if (!this.m_countDownTool_Ren.isRunning())
						{
							this.m_countDownTool_Ren.start(_t);
						}
						this.m_countDownTool_Ren.updata(_t, false);

						_mc['mcRen']['tf_Num'].text=_callback.arrItemintparam[4].intparam + Lang.getLabel('pub_ge');
					}
					//鬼
					else if (2 == _callback.arrItemintparam[2].intparam)
					{
						_mc['mckong'].visible=false;
						_mc['mcRen'].visible=false;
						_mc['mcGui'].visible=true;

						if (_callback.arrItemintparam[0].intparam >= 0 && _callback.arrItemintparam[0].intparam <= 2)
						{
							_mc['mcGui']['tf_0'].htmlText=Lang.getLabelArr("arrHuoDong_DuoMaoMao")[_callback.arrItemintparam[0].intparam];
						}
						else
						{
							_mc['mcGui']['tf_0'].htmlText="";
						}


						_t=_callback.arrItemintparam[1].intparam;
						if (null == this.m_countDownTool_Gui)
						{
							this.m_countDownTool_Gui=new CountDownTool(_mc['mcGui']['tf_remainderTime']);
						}
						if (!this.m_countDownTool_Gui.isRunning())
						{
							this.m_countDownTool_Gui.start(_t);
						}
						this.m_countDownTool_Gui.updata(_t, false);
					}
					//3是鬼但是被找到了
					else if (3 == _callback.arrItemintparam[2].intparam)
					{

					}

					break;
				case 1001: // 20级装备副本副本界面
//					_mc["tuichufuben"].x = 64;
//					_mc["tuichufuben"].y = 185;
					var _1001_type:int=_callback.arrItemintparam[1].intparam - 1;
					var _1001_step:int=_callback.arrItemintparam[0].intparam;
					_mc['tf_0'].text=_1001_step + '/' + _callback.arrItemintparam[1].intparam;
					_mc['mcBar'].gotoAndStop(_1001_type);
					if (1 == _1001_type)
					{
						if (1 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=15;
						}
						else if (2 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=175;
						}
					}
					else if (2 == _1001_type)
					{
						if (1 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=15;
						}
						else if (2 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=90;
						}
						else if (3 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=175;
						}
					}
					else if (3 == _1001_type)
					{
						if (1 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=15;
						}
						else if (2 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=66;
						}
						else if (3 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=117;
						}
						else if (4 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=175;
						}
					}
					else if (4 == _1001_type)
					{
						if (1 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=15;
						}
						else if (2 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=55;
						}
						else if (3 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=92;
						}
						else if (4 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=130;
						}
						else if (5 == _1001_step)
						{
							_mc['mcBar']['mcBar_instance']['mcMask'].width=175;
						}
					}

					_mc['tf_1'].text='';

					//目标1类型，
					//目标1已击杀数量，
					//目标1总数量，
					var aim:int=_callback.arrItemintparam[2].intparam;
					if (aim > 0)
					{
						_mc['tf_1'].htmlText+=Lang.getLabelArr('arrHuoDong_20JiFuBen')[aim] + _callback.arrItemintparam[3].intparam + '/' + _callback.arrItemintparam[4].intparam + '<br>';
					}

					//目标2类型，
					//目标2已击杀数量，
					//目标2总数量，
					aim=_callback.arrItemintparam[5].intparam;
					if (aim > 0)
					{
						_mc['tf_1'].htmlText+=Lang.getLabelArr('arrHuoDong_20JiFuBen')[aim] + _callback.arrItemintparam[6].intparam + '/' + _callback.arrItemintparam[7].intparam + '<br>';
					}

					//目标3类型，
					//目标3已击杀数量，
					//目标3总数量
					aim=_callback.arrItemintparam[8].intparam;
					if (aim > 0)
					{
						_mc['tf_1'].htmlText+=Lang.getLabelArr('arrHuoDong_20JiFuBen')[aim] + _callback.arrItemintparam[9].intparam + '/' + _callback.arrItemintparam[10].intparam + '<br>';
					}

					//奖励物品1，奖励物品2，奖励物品3，奖励物品4
					_repaintItemIcon(_callback.arrItemintparam[11].intparam, _mc['reward_1']);
					_repaintItemIcon(_callback.arrItemintparam[12].intparam, _mc['reward_2']);
					_repaintItemIcon(_callback.arrItemintparam[13].intparam, _mc['reward_3']);
					_repaintItemIcon(_callback.arrItemintparam[14].intparam, _mc['reward_4']);

					break;
				case 210000300: //领地争夺
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=187;
					tipArr=Lang.getLabelArr("20410_LongTuBaYe_AreaInfo");
					hostName=_callback.arrItemcharparam[0].charparam;
					count=_callback.arrItemintparam[0].intparam.toString();
					var c:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
					var seekIdArr:Array=c.map_seek_id.split(",");
					for (var fi:int=1; fi < 6; fi++)
					{
						f=_callback.arrItemcharparam[fi].charparam;
						if (f.length > 0)
						{
							owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [f]);
						}
						else
						{
							owner=Lang.getLabel("20408_LongTuBaYe_NoGet");
						}
						_mc["tf_" + fi].htmlText=Lang.replaceParam(tipArr[fi - 1], [seekIdArr[fi - 1], owner]);
						_mc["tf_" + fi].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					}
					_mc["tName"].htmlText=hostName;
					_mc["tCount"].htmlText=count;
					break;
				case 210000400: //要塞争夺

					var c210000400:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
					var seekIdArr210000400:Array=c210000400.map_seek_id.split(",");
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=283;
					for (var i1:int=0; i1 < 3; i1++)
					{
						_mc["tName" + i1].text=_callback.arrItemcharparam[i1].charparam;
						_mc["tTotalRes" + i1].text=_callback.arrItemintparam[i1].intparam.toString();
						_mc["tMyRes" + i1].text=_callback.arrItemintparam[i1 + 3].intparam.toString();
					}
					//TODO 3个要塞寻路ID，添加监听
					index=0;
					for (index; index < 3; index++)
					{
						_mc["mcArea" + index].addEventListener(MouseEvent.CLICK, onAreaSeekHandler);
					}
					_mc["npcSeek"].htmlText=Renwu.getChuanSongText(seekIdArr210000400[3], "", "00FF00", false);
					_mc["npcSeek"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					break;
				case 210000500: //皇城争霸
					_mc["tuichufuben"].x=74;
					_mc["tuichufuben"].y=277;
					Lang.addTip(_mc["act_desc"], "huangChengZhengBa_activity_desc", 200);
					var c210000500:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
					var seekIdArr210000500:Array=c210000500.map_seek_id.split(",");
					tipArr=Lang.getLabelArr("20410_BangPaiZhan_AreaInfo");
					var boss:String=Lang.getLabel("20411_HuangChengZhengBa_Boss");
					var attacker:String=Lang.getLabel("20411_HuangChengZhengBa_Attacker");
					var defenser:String=Lang.getLabel("20411_HuangChengZhengBa_Defenser");
					var palace:String=Lang.getLabel("20411_HuangChengZhengBa_Palace");
					var noMaster:String=Lang.getLabel("20411_HuangChengZhengBa_NoMaster");

					_mc["tBoss"].htmlText=Lang.replaceParam(boss, [seekIdArr210000500[0]]);
					_mc["tPalace"].htmlText=Lang.replaceParam(palace, [seekIdArr210000500[3]]);
					var lbT1:String=tipArr[0];
					var lbT2:String=tipArr[1];
					var isT1Attacked:Boolean=_callback.arrItemintparam[3].intparam == 1;
					var isT2Attacked:Boolean=_callback.arrItemintparam[4].intparam == 1;
					var bossHpP:int=_callback.arrItemintparam[0].intparam;
					var masterHpP:int=_callback.arrItemintparam[1].intparam;
					_mc["mcGuardHpBar"]["mcMask"].scaleX=bossHpP * 0.01;
					_mc["mcGodHpBar"]["mcMask"].scaleX=masterHpP * 0.01;
					_mc["tBossHp"].text=bossHpP + "%";
					_mc["tMasterHp"].text=masterHpP + "%";
					if (isT1Attacked)
					{
						owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [attacker]);
					}
					else
					{
						owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [defenser]);
					}
					_mc["t1"].htmlText=Lang.replaceParam(lbT1, [seekIdArr210000500[1], owner]);
					if (isT2Attacked)
					{
						owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [attacker]);
					}
					else
					{
						owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [defenser]);
					}
					_mc["t2"].htmlText=Lang.replaceParam(lbT2, [seekIdArr210000500[2], owner]);
					_mc["tMaster"].text=_callback.arrItemcharparam[0].charparam.length > 0 ? _callback.arrItemcharparam[0].charparam : noMaster;
					_mc["npcSeek"].htmlText=Renwu.getChuanSongText(seekIdArr210000500[4], "", "00FF00", false);

					_mc["tBoss"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					_mc["t1"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					_mc["t2"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					_mc["tPalace"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					_mc["npcSeek"].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
//					_t=_callback.arrItemintparam[2].intparam*1000;
//					if (null == this.m_countDownTool)
//					{
//						this.m_countDownTool=new CountDownTool(_mc['tf_remainderTime']);
//					}
//					if (!this.m_countDownTool.isRunning())
//					{
//						this.m_countDownTool.start(_t);
//					}
//					this.m_countDownTool.updata(_t,false);
					break;
				case 1000075:
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=208;
					tipArr=Lang.getLabelArr("20410_BangPaiZhan_AreaInfo");
					var bpzData:PacketSCGetGuildMeleeInfoUpdate=m_fubenModel.bangPaiZhanData;
					HuoDongCountDownWindow.getInstance().setTime(int(bpzData.last_time / 1000));
					if (HuoDongCountDownWindow.getInstance().isOpen == false)
					{
						HuoDongCountDownWindow.getInstance().open(true, false);
					}
					hostName=bpzData.firstInfo.guildName;
					count=bpzData.firstInfo.flag_no.toString();
					_mc["tName"].htmlText=hostName;
					_mc["tCount"].htmlText=count;
					var c1000075:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
					var seekIdArr1000075:Array=c1000075.map_seek_id.split(",");
					for (var fj:int=1; fj < 6; fj++)
					{
						f=bpzData.arrItemFightInfo[fj - 1].guildName;
						if (f.length > 0)
						{
							owner=Lang.replaceParam(Lang.getLabel("20409_LongTuBaYe_GetIt"), [f]);
						}
						else
						{
							owner=Lang.getLabel("20408_LongTuBaYe_NoGet");
						}
						_mc["t" + fj].htmlText=Lang.replaceParam(tipArr[fj - 1], [seekIdArr1000075[fj - 1], owner]);
						_mc["t" + fj].addEventListener(TextEvent.LINK, Renwu.textLinkListener_);
					}
					break;
				case 1000130:
					_mc["tuichufuben"].x=110;
					_mc["tuichufuben"].y=248;
					var cdTime1000130:int=_callback.arrItemintparam[0].intparam * 0.001;
					HuoDongCountDownWindow.getInstance().setTime(cdTime1000130);
					if (HuoDongCountDownWindow.getInstance().isOpen == false)
					{
						HuoDongCountDownWindow.getInstance().open(true, false);
					}
//					if (cdTime1000130<=0){
//						BangPaiMiGongJiangLi.instance().open();
//					}
					var cdTime21000130:int=_callback.arrItemintparam[1].intparam * 0.001;
					//BangPaiMiGongTimer.getInstance().setTime(cdTime21000130);
					if (cdTime21000130 <= 0)
					{
						//BangPaiMiGongTimer.getInstance().winClose();
					}
					else
					{
						//if (BangPaiMiGongTimer.getInstance().isOpen==false){
						//	BangPaiMiGongTimer.getInstance().open(true,false);
						//}
					}
					//是否可以领取礼包，如果已经领取，则隐藏
					var awardState:int=_callback.arrItemintparam[2].intparam;
					if (_currentGuildMazeScore >= 1500)
					{
						if ((awardState >> 5) & 1)
						{ //已领取
							MovieClip(_mc["score_desc"]).gotoAndStop(3);
						}
						else
						{
							MovieClip(_mc["score_desc"]).gotoAndStop(2);
						}
					}
					break;
				case 100013100: //PK之王
					_mc["tuichufuben"].x=64;
					_mc["tuichufuben"].y=229;
					if (_callback.arrItemcharparam.length > 0)
						_mc["tf_0"].text=_callback.arrItemcharparam[0].charparam;
					else
						_mc["tf_0"].text="";
					var cdTime100013100:int=_callback.arrItemintparam[0].intparam;
					HuoDongCountDownWindow.getInstance().setTime(cdTime100013100);
					if (HuoDongCountDownWindow.getInstance().isOpen == false)
					{
						HuoDongCountDownWindow.getInstance().open(true, false);
					}
					_mc["tf_1"].text=_callback.arrItemintparam[1].intparam.toString();
					if (_callback.arrItemintparam.length > 2 && _callback.arrItemintparam[2].intparam == 1)
					{
						var myScore:int=_callback.arrItemintparam[3].intparam;
						_mc["tf_3"].text=myScore.toString();
						PKKingFuHuo.LifeCount=_callback.arrItemintparam[4].intparam;
					}
					//	50500001 20
					//	50500002 50
					//	50500003 100
					bagUpdate(null);
					index=1;
					for (index; index <= 3; index++)
					{
						if (_mc["btnUse" + index].hasEventListener(MouseEvent.CLICK) == false)
							_mc["btnUse" + index].addEventListener(MouseEvent.CLICK, onPkScoreExchangeHandler(index));
					}
					break;
				case 100011000: //天门阵
					_mc["tuichufuben"].x=70;
					_mc["tuichufuben"].y=180;
					_mc["tf0"].text="" + _callback.arrItemintparam[0].intparam;
					_mc["tf1"].text=_callback.arrItemintparam[1].intparam + "/" + _callback.arrItemintparam[2].intparam;
					_mc["tf2"].text=_callback.arrItemintparam[3].intparam + "/" + _callback.arrItemintparam[4].intparam;
					var second100011000:Number=_callback.arrItemintparam[7].intparam * 1000;
					_mc['tf_time'].text=StringUtils.getStringDayTime(second100011000); //剩余时间(单位秒)
					TianMenZhenControlBar.getInstance().update(_callback.arrItemintparam[5].intparam, _callback.arrItemintparam[6].intparam);
					break;
				case 100013700: //新增副本
					_mc["tuichufuben"].x=70;
					_mc["tuichufuben"].y=176;
					_mc["tf0"].text=_callback.arrItemintparam[0].intparam + "/" + _callback.arrItemintparam[1].intparam;
					_mc["tf1"].text="×" + _callback.arrItemintparam[2].intparam;
					_mc["tf2"].text="×" + _callback.arrItemintparam[3].intparam;
					_mc["tf3"].text="" + _callback.arrItemintparam[4].intparam;
					break;
				case 100006800: //决战战场

					DataKey.instance.register(PacketSCActRankPoint.id, rankPoint);
					DataKey.instance.register(PacketSCActRank.id, rank);

					var csRankPoint:PacketCSActRankPoint=new PacketCSActRankPoint();
					csRankPoint.actid=ACT_ID;
					DataKey.instance.send(csRankPoint);

					var csActRank:PacketCSActRank=new PacketCSActRank();
					csActRank.actid=ACT_ID;
					DataKey.instance.send(csActRank);

					if (_callback.arrItemintparam.length == 1)
					{

						this.rankPoint2(_callback.arrItemintparam[0].intparam, 0);
					}
					else if (_callback.arrItemintparam.length >= 2)
					{

						this.rankPoint2(_callback.arrItemintparam[0].intparam, _callback.arrItemintparam[1].intparam);
					}

					break;
				case 100013901: //皇城争霸
					/*
					pack.intparam【0】= 怪血量, 是百分比
					pack.intparam【1】= 活动剩余时间
					pack.charparam【0】= 获胜帮派名字
					*/
					if (_callback.arrItemintparam[0].intparam <= 0)
					{
						_mc['mcHpBar'].gotoAndStop(1); //当前血量百分比 [1-100]
					}
					else
					{
						_mc['mcHpBar'].gotoAndStop(_callback.arrItemintparam[0].intparam); //当前血量百分比 [1-100]
					}
					var ___t:int=_callback.arrItemintparam[1].intparam;
					_mc['tf_remainderTime'].text=StringUtils.getStringDayTime(___t, true);

					if (null == this.m_countDownTool)
					{
						this.m_countDownTool=new CountDownTool(_mc['tf_remainderTime']);
					}
					if (!this.m_countDownTool.isRunning())
					{
						this.m_countDownTool.start(___t);
					}
					this.m_countDownTool.updata(___t);

					//btnLeave_100013901

					_mc['tf_0'].text=_callback.arrItemcharparam[0].charparam;

					Lang.addTip(_mc['btnWanFa'], 'huangChengZhengBa_activity_desc', 220);

					break;
				default:
					break;
			}
		}
		
		/**
		 * 副本面板点击事件 
		 * @param me
		 * 
		 */		
		private function fubenPanelClick(me:MouseEvent):void{
			var target:Object=me.target;
			var name:String=target.name;
			var callBack:PacketCSCallBack=null;
			var arr:Array=null;
			switch(name){
				case "btnFangZhi1":
					arr=Data.beiBao.getBeiBaoDataById(11800321,true);
					if(arr!=null&&arr.length>0)
						BeiBao.getInstance().useItem(arr[0].pos);
					else
						Lang.showMsg({type:4,msg:"背包中没有此道具，请点击购买！"});
					showRow(43,-1);
					break;
				case "btnFangZhi2":
					arr=Data.beiBao.getBeiBaoDataById(11800322,true);
					if(arr!=null&&arr.length>0)
						BeiBao.getInstance().useItem(arr[0].pos);
					else
						Lang.showMsg({type:4,msg:"背包中没有此道具，请点击购买！"});
					showRow(43,-1);
					break;
				case "btnBuyFZ1":
					NpcBuy.instance().setType(4,ItemManager.instance().getBagCell(10016),true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				case "btnBuyFZ2":
					NpcBuy.instance().setType(4,ItemManager.instance().getBagCell(10017),true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				case "btnZMGRefresh":
					callBack=new PacketCSCallBack();
					callBack.callbacktype=2022004003;
					DataKey.instance.send(callBack);
					showRow(43,-1);
					break;
				default:
					break;
			}
		
		}
		
		/**
		 * 显示箭头 2014－10－17 
		 * @param frameIndex
		 * @param x
		 * @param y
		 * 
		 */		
		public function showRow(frameIndex:int,x:int=0,y:int=0):void{
			var fuben:MovieClip=UI_index.indexMC_mrt["missionMain"]["normalTask"]['mc_fuben_panel'] as MovieClip;
			if(fuben!=null&&fuben.currentFrame==frameIndex){
				fuben["mc_row"].visible=x==-1?false:true;
				fuben["mc_row"].x=x;
				fuben["mc_row"].y=y;
				
				//指引箭头特殊处理
				if (fuben["mc_row"].visible)
					fuben["mc_row"].play();
				else
					fuben["mc_row"].stop();
			}
		}
		
		
		

		public function rank(p:PacketSCActRank2):void
		{
			refresh100006800();
		}

		public function rankPoint(p:PacketSCActRankPoint2):void
		{
			refresh100006800();
		}

		public function rankPoint2(a:int, b:int):void
		{
			var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;

			_mc["txtJinMaTaiYIFen"].text=a.toString();
			_mc["txtJinMaTongTianFen"].text=b.toString();
		}


		/**
		 *活动标识,1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
		 */
		public static const ACT_ID:int=3;


		private function refresh100006800():void
		{
			//reset
			var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;

			//_mc["txtJinMaTongTianFen"].text = "";
			//_mc["txtJinMaTaiYIFen"].text = "";
			_mc["txtJinMaMyInd"].text="";
			_mc["txtJinMaMyFen"].text="";

			Lang.addTip(_mc["mcShuoMing"], "100006800_JinMaDesc", 280);
			Lang.addTip(_mc["mcShuoMing1"], "100006801_JinMaDesc", 280);

			for (var j:int=1; j <= 6; j++)
			{
				// txt_ind     vip txt_player   txt_camp   txt_fen
				(_mc["jinma_item" + j.toString()]["txt_ind"] as TextField).htmlText=""; //j.toString();

				(_mc["jinma_item" + j.toString()]["vip"] as MovieClip).gotoAndStop(1);
				(_mc["jinma_item" + j.toString()]["vip"] as MovieClip).visible=false;

				(_mc["jinma_item" + j.toString()]["mcQQYellowDiamond"] as MovieClip).gotoAndStop(1);
				(_mc["jinma_item" + j.toString()]["mcQQYellowDiamond"] as MovieClip).visible=false;

				(_mc["jinma_item" + j.toString()]["txt_player"] as TextField).text="";

				//(_mc["jinma_item" + j.toString()]["txt_camp"] as TextField).text = "";

				(_mc["jinma_item" + j.toString()]["txt_fen"] as TextField).text="";
			}

			var list:Vector.<PacketSCActRank2>=Data.huoDong.getActRankList();

			var len:int=list.length;
			var i:int;
			for (i=0; i < len; i++)
			{
				if (list[i].actid == ACT_ID)
				{
					//_mc["txtJinMaTongTianFen"].text = list[i].camp.TongTianFen;
					//_mc["txtJinMaTaiYIFen"].text = list[i].camp.TaiYiFen;

					//  如果玩家在50名以外，您当前的排名显示为  榜上无名
					if (list[i].index != 0 && list[i].index < 50)
					{
						_mc["txtJinMaMyInd"].text=list[i].index.toString();
					}
					else
					{
						//="榜上无名";

						_mc["txtJinMaMyInd"].text=Lang.getLabel("50001_JinMaTop");

					}

					_mc["txtJinMaMyFen"].text=Data.huoDong.myJiFen.getCurPointByActId(ACT_ID);

					//set
					for (var k:int=0; k < list[i].arrItemlist.length; k++)
					{
						var k_x:int=k + 1;

						(_mc["jinma_item" + k_x.toString()]["txt_ind"] as TextField).htmlText=getColor100006800(k_x, k_x.toString());

						var k_vip:int=list[i].arrItemlist[k].vip;

						if (0 == k_vip)
						{
							//(mc["jinma_item" + k_x.toString()]["vip"] as MovieClip).visible = false;
						}
						else
						{
							//(mc["jinma_item" + k_x.toString()]["vip"] as MovieClip).visible = true;
							//(mc["jinma_item" + k_x.toString()]["vip"] as MovieClip).gotoAndStop(k_vip);
						}

						(_mc["jinma_item" + k_x.toString()]["txt_player"] as TextField).htmlText=getColor100006800(k_x, list[i].arrItemlist[k].rolename);

						//(_mc["jinma_item" + k_x.toString()]["txt_camp"] as TextField).htmlText = getColor100006800(k_x,list[i].arrItemlist[k].camp_name());

						(_mc["jinma_item" + k_x.toString()]["txt_fen"] as TextField).htmlText=getColor100006800(k_x, list[i].arrItemlist[k].point.toString());

					}

					break;
				}
			}



		}

		private function getColor100006800(k_x:int, k_content:String):String
		{
			if (1 == k_x)
			{
				return "<b><font color='#FF9B10'>" + k_content + "</font></b>";

			}
			else if (2 == k_x)
			{
				return "<b><font color='#F74AFD'>" + k_content + "</font></b>";

			}
			else if (3 == k_x)
			{
				return "<b><font color='#0AA3D9'>" + k_content + "</font></b>";

			}
			else
			{
				return k_content;
			}

			return "";
		}












		//要塞寻路ID
		private var areaSeekIds:Array=null;

		private function onAreaSeekHandler(e:MouseEvent):void
		{
			var target:Object=e.currentTarget;
			var target_name:String=target.name;
			if (target_name.indexOf("mcArea") == 0)
			{
				var index:int=int(target_name.replace("mcArea", ""));
				if (areaSeekIds == null)
				{
					var currMapId:int=SceneManager.instance.currentMapId;
					var seekConfig:String=XmlManager.localres.getPubMapXml.getResPath(currMapId)["map_seek_id"];
					areaSeekIds=seekConfig.split(",");
				}
				if (areaSeekIds[index] != null)
				{
					var te:TextEvent=new TextEvent(TextEvent.LINK);
					te.text="1@" + areaSeekIds[index];
					Renwu.textLinkListener_(te);
				}
			}
		}

		/**
		 * 特等奖
		 * @param e
		 *
		 */
		private function onGetMiGongAward0(e:MouseEvent):void
		{
			var p:PacketCSCallBack=new PacketCSCallBack();
			p.callbacktype=100013001;
			p.callbackparam1=1;
			DataKey.instance.send(p);
		}

		/**
		 * 一等奖
		 * @param e
		 *
		 */
		private function onGetMiGongAward1(e:MouseEvent):void
		{
			var p:PacketCSCallBack=new PacketCSCallBack();
			p.callbacktype=100013001;
			p.callbackparam1=2;
			DataKey.instance.send(p);
		}

		/**
		 * 二等奖
		 * @param e
		 *
		 */
		private function onGetMiGongAward2(e:MouseEvent):void
		{
			var p:PacketCSCallBack=new PacketCSCallBack();
			p.callbacktype=100013001;
			p.callbackparam1=3;
			DataKey.instance.send(p);
		}

		/**
		 * 三等奖
		 * @param e
		 *
		 */
		private function onGetMiGongAward3(e:MouseEvent):void
		{
			var p:PacketCSCallBack=new PacketCSCallBack();
			p.callbacktype=100013001;
			p.callbackparam1=4;
			DataKey.instance.send(p);
		}

		/**
		 * 四等奖
		 * @param e
		 *
		 */
		private function onGetMiGongAward4(e:MouseEvent):void
		{
			var p:PacketCSCallBack=new PacketCSCallBack();
			p.callbacktype=100013001;
			p.callbackparam1=5;
			DataKey.instance.send(p);
		}

		/**
		 * 几分礼包
		 * @param e
		 *
		 */
		private function onGetMiGongAward5(e:MouseEvent):void
		{
			var _mc:MovieClip=mc_normal_task['mc_fuben_panel'] as MovieClip;
			if (MovieClip(_mc["score_desc"]).currentFrame == 2)
			{
				//领取几分礼包
				var p:PacketCSCallBack=new PacketCSCallBack();
				p.callbacktype=100013001;
				p.callbackparam1=6;
				DataKey.instance.send(p);
			}
		}

		public static const MI_GONG_AWARD_CONDITION:Array=[[50, 16, 30, 10, 3, 1], //特等奖  m,m,r,r,r,m
			[20, 12, 20, 8, 2, 0], //一等奖
			[15, 8, 14, 5, 1, 0], //二等奖
			[12, 5, 10, 2, 0, 0], //三等奖
			[8, 2, 6, 0, 0, 0] //四等奖
			];

		public var a0Ok:Boolean=false; //特等奖是否可以领取
		public var a1Ok:Boolean=false; //一等奖是否可以领取
		public var a2Ok:Boolean=false; //2。。
		public var a3Ok:Boolean=false; //3
		public var a4Ok:Boolean=false; //4

		/**
		 * 显示帮派迷宫奖励领取条件
		 * @param e
		 *
		 */
		private function onShowBangPaiMiGongCondition(e:MouseEvent):void
		{
			//BangPaiMiGongJiangLiDesc.getInstance().open();
		}

		/**
		 * 从四等奖对应的奖励开始比较，如果不满足条件则直接退出
		 * @param values
		 *
		 */
		public function updateAwardState(values:Array):void
		{
			var len:int=5;
			var cdt:Array=null;
			var isOk:Boolean=true;
			for (var i:int=len - 1; i >= 0; i--)
			{
				cdt=MI_GONG_AWARD_CONDITION[i];
				isOk=true;
				for (var j:int=1; j < len; j++)
				{
					if (values[j] < cdt[j])
					{
						isOk=false;
						break;
					}
				}
				this["a" + i + "Ok"]=isOk;
			}
		}

		private function onPkScoreExchangeHandler(index:int):Function
		{
			var func:Function=function(e:MouseEvent):void
			{
				var p:PacketCSPkOneExchangeGrade=new PacketCSPkOneExchangeGrade();
				p.flag=index - 1;
				DataKey.instance.send(p);
			};
			return func;
		}

		private var m_cell_ItemIcon:StructBagCell2=null;

		private function _repaintItemIcon(itemId:int, mcItem:MovieClip):void
		{
			if (itemId > 0 && mcItem != null)
			{
				m_cell_ItemIcon=new StructBagCell2();
				m_cell_ItemIcon.itemid=itemId;
				Data.beiBao.fillCahceData(m_cell_ItemIcon);
				mcItem["data"]=m_cell_ItemIcon;
//				mcItem['uil'].source=m_cell_ItemIcon.icon;
				ImageUtils.replaceImage(mcItem,mcItem["uil"],m_cell_ItemIcon.icon);
				CtrlFactory.getUIShow().addTip(mcItem);
				ItemManager.instance().setEquipFace(mcItem);

//				var _num:int = Data.beiBao.getBeiBaoCountById(itemId);
//				//足够
//				if(_num >= PET_RALENT_NEED_NUM )
//				{
//					mcItem['txt_num'].htmlText = _num + "/" + PET_RALENT_NEED_NUM;
//				}
//					//不够
//				else
//				{
//					mcItem['txt_num'].htmlText = "<font color='#FF0000'>"+ _num +"</font>/" + PET_RALENT_NEED_NUM;
//				} 

					//mcItem.parent['txt_name'].htmlText = m_cell_ItemIcon.itemname;
			}
			else
			{
				mcItem["data"]=null;
				mcItem['uil'].source=null;
				CtrlFactory.getUIShow().removeTip(mcItem);
				ItemManager.instance().setEquipFace(mcItem, false);
				if (mcItem != null && mcItem['txt_num'] != null)
					mcItem['txt_num'].htmlText="";
			}
		}

		private function _spaLinkListener(e:TextEvent):void
		{
			Renwu.textLinkListener_(e);
		}

		private function _onbtnSexGirl_FangQi(e:MouseEvent):void
		{
			var alert:GameAlert=new GameAlert();
			alert.ShowMsg(Lang.getLabel("10020_missionmain"), 4, null, CSFailBeauty);
			//(Lang.getLabel("10020_missionmain",[0,0]),4,null,CSFailBeauty);
		}

		private function CSFailBeauty():void
		{
			var _currentIndex:int=m_fubenModel.getCurrentIndex();
			if(_currentIndex==121){
				var _p1:PacketCSFailNationBeauty=new PacketCSFailNationBeauty();
	
				DataKey.instance.send(_p1);
			}else{
				var _p:PacketCSFailBeauty=new PacketCSFailBeauty();
				
				DataKey.instance.send(_p);
			}
		}

		private function _onbtnSexGirl_Auto(e:MouseEvent):void
		{
			//运送军需 自动跟随 2013-07-26
			var _p:PacketCSStopGuardFollow=new PacketCSStopGuardFollow();
//			
			DataKey.instance.send(_p);
		}


		public static const TARGET_SEX_GIRL_NPC_ID:int=30100150;

		private function _targetPlaceListener(e:TextEvent):void
		{
			GameAutoPath.seek(TARGET_SEX_GIRL_NPC_ID);
		}

		/**
		1、家族掌教争霸赛信息中显示神像的连接，点击后自动寻路至该对应的地方(如附图)
		a)30510118 白虎圣像
		b)30510117 青龙圣像
		c)30510119 朱雀圣像
		d)30510120 玄武圣像
		*/
		private function guildFightClick(e:MouseEvent):void
		{
			//寻路		
			var seekid:int=0;
			if ("tf_0" == e.target.name)
			{
				seekid=30510118;
			}

			if ("tf_1" == e.target.name)
			{
				seekid=30510117;
			}

			if ("tf_2" == e.target.name)
			{
				seekid=30510119;
			}

			if ("tf_3" == e.target.name)
			{
				seekid=30510120;
			}
			GameAutoPath.seek(seekid);
		}

		/**
		 * 操作副本嵌入小面板
		 * @return    当前副本的索引值
		 *
		 */
		private function _handleFubenPanel():int
		{
			//根据当前副本的索引值跳帧
			var _currentIndex:int=m_fubenModel.getCurrentIndex();
			var _frameIndex:int=0;

//			mc_normal_task['btnFuBenInfo_sex_girl'].visible=false;
//			mc_normal_task['btnFuBenInfo'].visible=true;

			mc_normal_task['spMission'].visible=false;

			switch (_currentIndex)
			{
				case 14: //神龙图腾
					_frameIndex=7;
					break;
				case 5: //四神器1(玄剑诛魔)
					_frameIndex=1;
					break;
				case 6: //四神器2(冰海急斩)
					_frameIndex=2;
					break;
				case 7: //四神器3(魔域求生)
					_frameIndex=3;
					break;
				case 8: //四神器4(决战九天)
					_frameIndex=4;
					break;
				case 9: //福溪村幻境
					_frameIndex=5;
					break;
				case 10: //鬼狱
					_frameIndex=6;
					break;
				case 11: //四神器统一用的副本结束界面信息
					//_frameIndex = 7;
					break;
				case 15: //云南天(风雪夜袭)
					_frameIndex=9;
					break;
				case 21: //家族掌教争霸赛
					_frameIndex=10;
					break;
				case 30: //王者之剑活动(争夺PK之王的)
					_frameIndex=11;
					break;
				case 120: //拉镖
				case 121:
					_frameIndex=12;
					//mc_normal_task['btnFuBenInfo_sex_girl'].visible=true;
//					mc_normal_task['btnFuBenInfo'].visible=false;
					break;
				case 130: //温泉
					_frameIndex=14;
					mc_normal_task['btnFuBenInfo_sex_girl'].visible=true;
//					mc_normal_task['btnFuBenInfo'].visible=false;
					break;
				case 140: //新增加PK之王活动
					_frameIndex=13;
					//mc_normal_task['btnFuBenInfo_sex_girl'].visible=true;
//					mc_normal_task['btnFuBenInfo'].visible=false;
					break;
				case 160: // 生死劫
					_frameIndex=15;
					break;
				case 170: // 死亡深渊
					_frameIndex=16;
					break;
				case 200: // 玄仙海战
					mc_normal_task['btnFuBenInfo_sex_girl'].visible=true;
//					mc_normal_task['btnFuBenInfo'].visible=false;
					_frameIndex=17;
					break;
				case 210: // 始皇魔窟
					_frameIndex=18;
					break;
				case 210000000: // 五子连珠
					_frameIndex=19;
					break;
				case 100011104: //躲猫猫
					_frameIndex=20;
					break;
				case 1001: // 20级装备副本副本界面
					_frameIndex=21;
					break;
				case 210000300: //领地争夺
					_frameIndex=22;
					break;
				case 210000400: //要塞争夺
					_frameIndex=26;
					break;
				case 210000500: //皇城争霸
					_frameIndex=27;
					break;
				case 1000075: //第一帮派战
					_frameIndex=24;
					break;
				case 1000130: //帮派迷宫
					_frameIndex=23;
					break;
				case 100013100: //PK之王
					_frameIndex=25;
					break;
				case 100011000: //天门阵
					_frameIndex=28;
					break;
				case 400: //战神殿1
					_frameIndex=30;
					break;
				case 401: //战神殿2
					_frameIndex=31;
					break;
				case 402: //战神殿3
					_frameIndex=32;
					break;
				case 403: //战神殿4
					_frameIndex=33;
					break;
				case 404: //战神殿5
					_frameIndex=34;
					break;
				case 405: //战神殿6
					_frameIndex=35;
					break;
				case 406: //战神殿7
					_frameIndex=36;
					break;
				case 407: //战神殿8
					_frameIndex=37;
					break;
				case 408: //战神殿9
					_frameIndex=38;
					break;
				case 100013700: //新增副本、
					_frameIndex=39;
					break;
				case 100013901: //皇城争霸
					_frameIndex=40;
					break;
				case 100006800: //决战战场
					_frameIndex=41;
					break;
				case 100011200: //天书
					_frameIndex=42;
					break;
				case 2022004000: //镇魔窟
					_frameIndex=43;
					break;
				
				default:
					break;
			}
			
			if ((bg.selectedIndex == 2 || bg.selectedIndex == 3) && _currentIndex >= 1)
			{
				mc_normal_task['mc_fuben_panel'].visible=true;
			}
			else
			{
				mc_normal_task['mc_fuben_panel'].visible=false;
			}

			if (_frameIndex >= 1 && _frameIndex <= 50)
			{
				mc_normal_task['mc_fuben_panel'].gotoAndStop(_frameIndex);

			}

			if (12 == _currentIndex)
			{
				mc_normal_task['mc_fuben_panel'].visible=false;
			}


			return _currentIndex;
		}

		/**
		 *	已接任务排序【右中】
		 *  需求比较复杂：主线置顶，最新完成，完成，最新已接，已接
		 *  2012-06-19 andy
		 */
		private function sortTaskList():Vector.<Object>
		{
			var vec1:Vector.<Object>=new Vector.<Object>;
			var vec20:Vector.<Object>=new Vector.<Object>;
			var vec2:Vector.<Object>=new Vector.<Object>;
			var vec30:Vector.<Object>=new Vector.<Object>;
			var vec3:Vector.<Object>=new Vector.<Object>;
			var vec4:Vector.<Object>=new Vector.<Object>;

			for each (var item:StructTaskList2 in taskList)
			{
				if (item.taskSort == 1)
				{
					vec1.push(item);
				}
				else if (item.status == 3 && item.taskid == this.newTaskId3)
				{
					vec20.push(item);
				}
				else if (item.status == 3 && item.taskid != this.newTaskId3)
				{
					vec2.push(item);
				}
				else if (item.status == 2 && item.taskid == this.newTaskId2)
				{
					vec30.push(item);
				}
				else if (item.status == 2 && item.taskid != this.newTaskId2)
				{
					vec3.push(item);
				}
				else
				{

				}
			}
			for each (var itemNext:StructNextList2 in nextList)
			{
				if (itemNext.taskSort == 1)
					vec1.push(itemNext);
				else
				{
					vec4.push(itemNext);
				}
			}
			vec4.sort(sortDiffcultEasy);
			return vec1.concat(vec20).concat(vec2).concat(vec30).concat(vec3).concat(vec4);
		}

		/**
		 *	可接任务排序【右中】
		 *  需求比较复杂：主线置顶
		 *  2012-06-19 andy
		 */
		private function sortNextList():Vector.<StructNextList2>
		{
			var vec1:Vector.<StructNextList2>=new Vector.<StructNextList2>;
			var vec2:Vector.<StructNextList2>=new Vector.<StructNextList2>;

			for each (var item:StructNextList2 in nextList)
			{
				if (item.taskSort == 1)
					vec1.push(item);
				else
				{
					vec2.push(item);
				}
			}
			vec2.sort(sortDiffcultEasy);
			return vec1.concat(vec2);
		}

		/**
		 *	可接任务根据【根据策划填写完成任务难易程度排序】
		 *  2012-08-08 andy
		 */
		private function sortDiffcultEasy(a:StructNextList2, b:StructNextList2):int
		{
			if (a.difficult_easy > b.difficult_easy)
			{
				return 1;
			}
			else if (a.difficult_easy < b.difficult_easy)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		/**
		 *	填充已接任务数据
		 */
		private function fillTask(v:StructTaskList2):void
		{
			var taskMode:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(v.taskid) as Pub_TaskResModel;
			v.sendNpc=taskMode.send_npc;
			v.submitNpc=taskMode.submit_npc;
			v.taskSort=taskMode.task_sort;
			v.minLevel=taskMode.min_level;
			v.taskTitle=taskMode.task_title;
			v.difficult_easy=taskMode.difficult_easy;
			v.task_name=taskMode.task_title;
			v.prize_exp=taskMode.prize_exp;
			v.prize_coin=taskMode.prize_coin;
			v.prize_rep=taskMode.prize_rep;
			v.autoSubmit=taskMode.auto_submit;
			v.FightPoint=taskMode.FightPoint;
			v.prize_soul=taskMode.prize_soul;
			v.access_auto=taskMode.access_auto;
			v.submit_auto=taskMode.submit_auto;
			v.access_guide=taskMode.access_guide;
			v.submit_guide=taskMode.submit_guide;
		}

		/**
		 *	填充可接任务数据
		 */
		private function fillNext(v:StructNextList2):void
		{
			var taskMode:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(v.taskid) as Pub_TaskResModel;

			if (null == taskMode)
			{
				return;
			}

			v.sendNpc=taskMode.send_npc;
			v.taskSort=taskMode.task_sort;
			v.minLevel=taskMode.min_level;
			v.taskTitle=taskMode.task_title;
			v.difficult_easy=taskMode.difficult_easy;
			v.access_auto=taskMode.access_auto;
			v.submit_auto=taskMode.submit_auto;
			v.access_guide=taskMode.access_guide;
			v.submit_guide=taskMode.submit_guide;
		}

		/**
		 *	主线任务
		 *  2012-11-01 andy
		 */
		private function getMainTask():StructTaskList2
		{
//			var ret:StructTaskList2=null;
			//============whr===============
			var ret:StructTaskList2=new StructTaskList2();
			for each (var item:StructTaskList2 in taskList)
			{
				if (item.taskSort == 1)
				{
					ret=item;
					break;
				}
			}
//			if (ret == null)
			if (ret.taskid == 0)
			{
				for each (var item1:StructNextList2 in nextList)
				{
					if (item1.taskSort == 1)
					{
						ret.taskid=item1.taskid;
						ret.sendNpc=item1.sendNpc;
						ret.status=item1.status;
						break;
					}
				}
			}

			return ret;
		}

		/**
		 * 显示任务列表Tip信息 ,无操作状态下每5秒显示一次。
		 *
		 */
		public function showMissionTip():void
		{



			if (MissionNPC.instance().isOpen) //npc对话界面打开则不判断
				return;
			if (LianDanLu.instance().isOpen)
				return;
			//进入副本
			if (FuBenModel.getInstance().isAtInstance())
				return;


			//			if(NewGuestHandlers.isOpen_gameAlert1007)
//			{
//				return ;
//			}


//			if (Data.myKing.level <= 20 && Data.myKing.level > 1)
			//========whr ====周六突击改=======
			if (Data.myKing.level <= autotask_5miao_level && Data.myKing.level > 1)
			{
				//获得主线任务
				var item:StructTaskList2=getMainTask();
				if (item != null)
				{

					if (item.status == 2)
					{
						//未完成按照任务寻径ID
						findPahtByTaskID(item.taskid);
					}
					else if (item.status == 3)
					{
						//已完成按照任务提交npc寻径ID
						var te:TextEvent=new TextEvent(TextEvent.LINK);
						te.text="1@" + item.submitNpc;
						Renwu.textLinkListener_(te);
					}
					else if (item.status == 1)
					{
						//========whr=========
						var vo:PacketCSAutoSeek=new PacketCSAutoSeek();
						vo.seekid=item.sendNpc;
						DataKey.instance.send(vo);

					}
				}

			}
			//20级之后就不再提示
//			if (Data.myKing.level >= 20)
			//========whr ====周六突击改=======
			//2012-12-17 andy 策划说箭头调整为35级
			if (Data.myKing.level >= 35)
			{
				return;
			}
			if (this.mc_special_task == null || this.mc_special_task.visible == false)
			{
				return;
			}
			addTip();
		}

		/**
		 *	根据任务ID找到寻径ID,并寻路
		 *  @2012-11-02 andy
		 */
		public function findPahtByTaskID(taskId:int):void
		{
			var taskStep:Pub_Task_StepResModel=XmlManager.localres.getPubTaskStepXml.getResPath(taskId) as Pub_Task_StepResModel;
			if (taskStep != null)
			{
				//已经和任务策划协商，任务目标字符串第一个:3为任务寻路ID
				var index:int=0;
				if (taskStep.task_target.indexOf(":3") >= 0)
				{
					index=taskStep.task_target.indexOf(":3");
				}
				if (taskStep.task_target.indexOf(":9") >= 0)
				{
					index=taskStep.task_target.indexOf(":9");
				}
				if (taskStep.task_target.indexOf(":8") >= 0)
				{
					index=taskStep.task_target.indexOf(":8");
				}
				if (index >= 0)
				{
					var seekId:int=int(taskStep.task_target.substr((index + 1), 8));
					var te:TextEvent=new TextEvent(TextEvent.LINK);
					te.text="1@" + seekId;
					Renwu.textLinkListener_(te);
				}

			}
		}

		/**
		 *	检查任务是否存在【可接任务】
		 *  @2012-11-14 andy
		 *  @param taskId 任务ID
		 *  @param status 任务状态
		 */
		public function checkNextTaskIsHave(taskId:int):StructNextList2
		{
			var ret:StructNextList2=null;
			for each (var item:StructNextList2 in nextList)
			{
				if (item.taskid == taskId)
				{
					ret=item;
					break;
				}
			}
			return ret;
		}

		/**
		 *	检查任务是否存在【已接任务】
		 *  @2012-11-14 andy
		 *  @param taskId 任务ID
		 *  @param status 任务状态
		 */
		public function checkTaskIsHave(taskId:int, status:int=-1):StructTaskList2
		{
			var ret:StructTaskList2=null;
			for each (var item:StructTaskList2 in taskList)
			{
				if (item.taskid == taskId && (item.status == status || status == -1))
				{
					ret=item;
					break;
				}
			}
			return ret;
		}

		/**
		 *	检查任务是否存在【历史任务】
		 *  @2013-06-19 andy
		 *  @param taskId 任务ID
		 */
		public function checkHistoryTaskIsHave(taskId:int):Boolean
		{
			return historyList.indexOf(taskId) >= 0 ? true : false;
		}

		/**
		 *	得到任务状态根据任务ID
		 *  @param  taskId
		 *  @return 0没有此任务1可接受2未完成3未提交4不可接5失败
		 */
		public function getTaskStatusById(taskId:int):int
		{
			var ret:int=0;
			var next:StructNextList2=checkNextTaskIsHave(taskId);
			if (next != null)
				ret=next.status;
			var task:StructTaskList2=checkTaskIsHave(taskId);
			if (task != null)
				ret=task.status;
			return ret;
		}

		public function closeMissionTip():void
		{
			removeTip();
		}
		/**
		 * 2014-09-30 60級神武插入位置 
		 * @param selectList
		 * @return 
		 * 
		 */		
		private function getSheWuIndex(selectList:Object):int{
			var shenWu60Index:int=-1;
			var k:int=0;
			var item:Object=null;
//			for each (var item:Object in selectList)
//			{
//				if(item.taskSort==3){
//					shenWu60Index=k;
//				}
//				k++;
//			}
//			if(shenWu60Index!=-1){
//				return shenWu60Index;
//			}
//			k=0;
			for each (var item:Object in selectList)
			{
				if(item.taskSort==1){
					shenWu60Index=k;
				}
				k++;
			}
			
			return shenWu60Index;
			
		}
	}


}




