package ui.base.huodong
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.color.GameColor;
	
	import ui.base.mainStage.UI_index;
	import ui.base.renwu.Renwu;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.view.view1.fuben.FuBenDuiWu;
	import ui.view.view1.fuben.area.HuoDongCommonEntry;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.motianwanjie.MoTianWanJie;
	import ui.view.view2.mrfl_qiandao.QianDao;
	import ui.view.view2.other.ControlButton;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 *	活动【右上角】
	 *  fux 2012-01-12
	 */
	public class HuoDong extends UIWindow
	{
		//列表内容容器
		private var mc_content:Sprite;
		public const AutoRefreshSecond:int=30;
		private var curAutoRefresh:int=0;
		private static var _instance:HuoDong;
		private var m_pk_tip:MovieClip=null;
		private static const SP_Y:int=106;
		//默认的OperatingActivity索引
		private var m_defaultOAIndex:int=0;
		public static var xmlModel:Pub_UpDateResModel;

		/**
		 *
		 */
		public static function instance():HuoDong
		{
			if (_instance == null)
			{
				_instance=new HuoDong();
			}
			return _instance;
		}

		public function HuoDong(d:Object=null)
		{
			blmBtn=12;
			type=3;
			super(getLink("win_huo_dong"), d);
		}

		public function setType(t:int=1, must:Boolean=false, defaultOAIndex:int=0):void
		{
			type=t;
			this.m_defaultOAIndex=defaultOAIndex;
			super.open(must);
		}

		override public function get width():Number
		{
			return 810;
		}

		override public function get height():Number
		{
			return 450;
		}

		override protected function openFunction():void
		{
			init();
		}

		//面板初始化
		override protected function init():void
		{
			if (m_initW < 0)
			{
				m_initW=mc.width;
				m_initH=mc.height;
			}
			//
			//			QianDao.getInstance().setUI(mc);
			//end
			clearMcContent();
			mc_content=new Sprite();
			//this.addChild(mc_content);
			super.sysAddEvent(mc_content, MouseEvent.MOUSE_OVER, overHandle);
			super.sysAddEvent(Data.huoDong, HuoDongSet.HUOYUE_UPD, showDayTuiJian);
			super.sysAddEvent(Data.huoDong, HuoDongSet.TUIJIAN_LIST_UPD, showDayTuiJian);
			//工资
			this.uiRegister(PacketSCActWeekOnline.id, actWeekOnline);
			//推荐
			this.uiRegister(PacketSCGetDayLimitPrize.id, SCGetDayLimitPrize);
			//
			this.uiRegister(PacketSCGetActivityPrize.id, linQuReturn);
			this.uiRegister(PacketSCLimitUpdate.id, limitUpdate);
			this.uiRegister(PacketSCServerTitleWinerName.id, _SCServerTitleWinerName);
			this.uiRegister(PacketSCGetDayPrizeRmb.id, SCGetDayPrizeRmb);
			//
			curAutoRefresh=0;
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			//
			mcHandler({name: "cbtn" + type});
			//
			HuoDongEventDispatcher.getInstance().checkReward();
			//
			UI_index.instance.huoYueChk();
			replace();
			//_visibleTipComplateTask(true);
		}

		private function _visibleTipComplateTask(b:Boolean):void
		{
			//0010527: [版本：玄仙传奇]推荐引导
			if (Data.myKing.level > 40)
			{
				b=false;
			}
			if (null == mc['mcTipComplateTask'])
			{
				return;
			}
			mc['mcTipComplateTask'].visible=b;
			if (b)
			{
				mc['mcTipComplateTask'].x=22;
			}
			else
			{
				mc['mcTipComplateTask'].x=142;
			}
		}

		private function _pkTipMouseOverListener(e:MouseEvent):void
		{
			var _name:String=e.target.name;
			var _gPoint:Point=new Point();
			_gPoint.x=e.stageX;
			_gPoint.y=e.stageY;
			var _lPoint:Point=null;
			_lPoint=m_pk_tip.parent.globalToLocal(_gPoint);
			m_pk_tip.x=_lPoint.x + 10;
			m_pk_tip.y=_lPoint.y + 10;
			m_pk_tip.visible=true;
			var _arr:Array=Lang.getLabelArr("arrPKHuoDong");
			switch (_name)
			{
				case "hot_area_100":
					m_pk_tip.gotoAndStop(1);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[100]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[100]));
					m_pk_tip['tf_0'].text=_arr[101];
					m_pk_tip['tf_1'].text=_arr[102];
					m_pk_tip['tf_2'].text=_arr[103];
					m_pk_tip['tf_3'].text=_arr[104];
					m_pk_tip['tf_4'].text=_arr[105];
					if (mc["hot_area"]["hot_area_100"].has)
					{
						m_pk_tip['tf_5'].text="";
					}
					else
					{
						m_pk_tip['tf_5'].text=Lang.getLabel("40063_huo_dong_pk");
					}
					break;
				case "hot_area_200":
					m_pk_tip.gotoAndStop(1);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[200]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[200]));
					m_pk_tip['tf_0'].text=_arr[201];
					m_pk_tip['tf_1'].text=_arr[202];
					m_pk_tip['tf_2'].text=_arr[203];
					m_pk_tip['tf_3'].text=_arr[204];
					m_pk_tip['tf_4'].text=_arr[205];
					if (mc["hot_area"]["hot_area_200"].has)
					{
						m_pk_tip['tf_5'].text="";
					}
					else
					{
						m_pk_tip['tf_5'].text=Lang.getLabel("40063_huo_dong_pk");
					}
					break;
				case "hot_area_300":
					m_pk_tip.gotoAndStop(1);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[300]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[300]));
					m_pk_tip['tf_0'].text=_arr[301];
					m_pk_tip['tf_1'].text=_arr[302];
					m_pk_tip['tf_2'].text=_arr[303];
					m_pk_tip['tf_3'].text=_arr[304];
					m_pk_tip['tf_4'].text=_arr[305];
					if (mc["hot_area"]["hot_area_300"].has)
					{
						m_pk_tip['tf_5'].text="";
					}
					else
					{
						m_pk_tip['tf_5'].text=Lang.getLabel("40063_huo_dong_pk");
					}
					break;
				case "hot_area_400":
					m_pk_tip.gotoAndStop(1);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[400]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[400]));
					m_pk_tip['tf_0'].text=_arr[401];
					m_pk_tip['tf_1'].text=_arr[402];
					m_pk_tip['tf_2'].text=_arr[403];
					m_pk_tip['tf_3'].text=_arr[404];
					m_pk_tip['tf_4'].text=_arr[405];
					if (mc["hot_area"]["hot_area_400"].has)
					{
						m_pk_tip['tf_5'].text="";
					}
					else
					{
						m_pk_tip['tf_5'].text=Lang.getLabel("40063_huo_dong_pk");
					}
					break;
				case "hot_area_500":
					m_pk_tip.gotoAndStop(2);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[500]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[500]));
					m_pk_tip['tf_0'].text=_arr[501];
					//m_pk_tip['tf_1'].text = _arr[502];
					//m_pk_tip['tf_2'].text = _arr[503];
					//m_pk_tip['tf_3'].text = _arr[504];
					m_pk_tip['tf_1'].text=_arr[505];
					break;
				case "hot_area_600":
					m_pk_tip.gotoAndStop(2);
//					m_pk_tip['uil'].source=FileManager.instance.getIconHongDongPK(_arr[600]);
					ImageUtils.replaceImage(m_pk_tip,m_pk_tip['uil'],FileManager.instance.getIconHongDongPK(_arr[600]));
					m_pk_tip['tf_0'].htmlText=_arr[601];
					//m_pk_tip['tf_1'].text = _arr[602];
					//m_pk_tip['tf_2'].text = _arr[603];
					//m_pk_tip['tf_3'].text = _arr[604];
					m_pk_tip['tf_1'].htmlText=_arr[605];
					break;
				default:
					break;
			}
		}

		private function _pkTipMouseOutListener(e:MouseEvent):void
		{
			var _name:String=e.target.name;
			m_pk_tip.visible=false;
			m_pk_tip.x=300;
			m_pk_tip.y=100;
		}

		public function SCGetDayLimitPrize(p:PacketSCGetDayLimitPrize2):void
		{
			if (super.showResult(p))
			{
				StringUtils.setUnEnable(mc["btnTuiJianTaskLingQu"]);
				if (ControlButton.getInstance().isVisible("arrHuoYue"))
				{
					ControlButton.getInstance().setVisible("arrHuoYue", true, false, 0, HuoDong.GetDayTuiJianByNumTip());
				}
			}
			else
			{
			}
		}

		public function SCGetDayPrizeRmb(p:PacketSCGetDayPrizeRmb2):void
		{
			if (super.showResult(p))
			{
				//刷新数据 2013-08-15 andy
				refreshContent(type);
			}
			else
			{
				//nothing
			}
			//
		}
		private var m_pSCServerTitleWinerName2:PacketSCServerTitleWinerName2=null;

		private function _SCServerTitleWinerName(p:PacketSCServerTitleWinerName2):void
		{
			m_pSCServerTitleWinerName2=p;
			showPK();
		}

		private function autoRefreshHandler(e:WorldEvent):void
		{
			if (6 == type)
			{
				return;
			}
			curAutoRefresh++;
			if (curAutoRefresh >= AutoRefreshSecond)
			{
				curAutoRefresh=0;
				mcHandler({name: "cbtn" + type});
				//
				HuoDongEventDispatcher.getInstance().checkReward();
				//
				UI_index.instance.huoYueChk();
			}
			refreshTxt();
		}

		public function clearMcContent():void
		{
			if (null != mc_content)
			{
				while (mc_content.numChildren > 0)
					mc_content.removeChildAt(0);
			}
		}

		private function overHandle(e:MouseEvent):void
		{
			var nm:String=e.target.name;
			if (nm.indexOf("item") == 0)
			{
								//								var itemData:StructFriendData2=e.target.data;
				//								e.target.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
			}
		}

		public function itemSelectedOther(target:Object):void
		{
			var tp:int=(mc as MovieClip).currentFrame;
			mc["txt_action_name"].htmlText=target.data.action_name;
			mc["txt_action_join"].htmlText=target.data.action_join;
			if (null == target.data.action_join || undefined == target.data.action_join)
			{
				target.data.action_join="";
			}
			mc["txt_action_join"].htmlText=Renwu.setTextColor(target.data.action_join);
			//				mc["txt_limit"].htmlText =  target.data.limit_id;
			for (var k:int=1; k <= 5; k++)
			{
				if (k <= target.data.action_star)
				{
					mc["action_star" + k].visible=true;
				}
				else
				{
					mc["action_star" + k].visible=false;
				}
			}
			var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
			var len:int;
			if (null == limitList)
			{
				len=0;
			}
			else
			{
				len=limitList.length;
			}
			var limit_id:int=target.data.limit_id;
			for (var j:int=0; j < len; j++)
			{
				if (limitList[j].limitid == limit_id)
				{
					//										mc["txt_limit"].htmlText=limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
					break;
				}
			}
			//								mc["txt_action_prize"].htmlText=target.data.action_prize;
			mc["txt_action_desc"].htmlText=target.data.action_desc; //活动介绍
			this.renderRewards(target.data.show_prize);
		}

		/**
		 * 显示掉落对应的物品奖励
		 * @param dropId 掉落ID
		 *
		 */
		private function renderRewards(dropId:int):void
		{
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			var uiMC:MovieClip;
			var itemData:StructBagCell2;
			var item:Pub_ToolsResModel;
			var drop:Pub_DropResModel;
			var dataLen:int=arr.length;
			for (var i:int=1; i <= 10; i++)
			{
				uiMC=mc["reward_" + i];
				if (i <= dataLen)
				{
					drop=arr[i - 1];
					item=XmlManager.localres.getToolsXml.getResPath(drop.drop_item_id) as Pub_ToolsResModel;
					if (item != null)
					{
						uiMC["txt_num"].text=drop.drop_num.toString();
						itemData=new StructBagCell2();
						itemData.itemid=drop.drop_item_id;
						itemData.num=drop.drop_num;
						Data.beiBao.fillCahceData(itemData);
						uiMC["uil"].source=itemData.icon;
						uiMC.data=itemData;
						CtrlFactory.getUIShow().addTip(uiMC);
						ItemManager.instance().setEquipFace(uiMC);
						uiMC.visible=true;
					}
				}
				else
				{
					uiMC["uil"].unload();
					uiMC["txt_num"].text="";
					uiMC.visible=false;
				}
			}
		}

		public function limitUpdate(p:PacketSCLimitUpdate2):void
		{
			//面板刷新 mcHandler
			this.refreshContent((mc as MovieClip).currentFrame);
		}

		public function linQuReturn(p:PacketSCGetActivityPrize):void
		{
			if (super.showResult(p))
			{
				HuoDongPrize.instance().open(true);
				HuoDongPrize.instance().btnStartClick(p);
			}
			else
			{
			}
		/*var p:PacketSCGetActivityPrize = new PacketSCGetActivityPrize();
		p.arrItemprizelist = new Vector.<StructPrizeInfo2>();
		for(var i:int =1;i<=8;i++)
		{
		var spi:StructPrizeInfo2= new StructPrizeInfo2();
		spi.toolid = 10901001;
		spi.toolnum = 99;
		p.arrItemprizelist.push(spi);
		}
		p.prizeid = 10901001;
		HuoDongPrize.instance(true).btnStartClick(p);*/
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			//			
			//有任何点击都将重置倒计时
			curAutoRefresh=0;
			var target_name:String=target.name;
			if (target_name.indexOf("cbtn") >= 0)
			{
				var tp:int=int(target_name.replace("cbtn", ""));
				this.type=tp;
				//有limitUpdate指令
				//UI_index.HuoDongLimitInit();
				refreshContent(tp);
				return;
			}
			if (target_name.indexOf("item") == 0)
			{
				itemSelected(target);
				itemSelectedOther(target);
			}
			var client1:PacketCSGetActivityPrize;
			switch (target_name)
			{
				case "btnWeekOnlinePrize":
					var vo:PacketCSActWeekOnlinePrize=new PacketCSActWeekOnlinePrize();
					uiSend(vo);
					break;
				case "btnLinQu":
					var target_parent_name:String=target.parent.name;
					var btnLinQu_n:int=int(target_parent_name.replace("btnLinQu", ""));
					client1=new PacketCSGetActivityPrize();
					client1.step_id=btnLinQu_n;
					this.uiSend(client1);
					break;
				case "boxLinQu1":
				case "boxLinQu2":
				case "boxLinQu3":
				case "boxLinQu4":
					var boxLinQu_n:int=int(target_name.replace("boxLinQu", ""));
					client1=new PacketCSGetActivityPrize();
					client1.step_id=boxLinQu_n;
					this.uiSend(client1);
					break;
				case "btnLinQuFuLi":
					var csAward:PacketCSGetCampActRankAward=new PacketCSGetCampActRankAward();
					this.uiSend(csAward);
					break;
				case "btnTuiJianQianDao": //签到
					mcHandler({name: "cbtn12"});
					break;
				case "btnTuiJianTaskLingQu":
					//	var csTuiJianTaskLingQu:PacketCSGetDayLimitPrize=new PacketCSGetDayLimitPrize();
					//	this.uiSend(csTuiJianTaskLingQu);
					if ("btnTuiJianTaskLingQu3" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step=1;
						this.uiSend(csTuiJianTaskLingQu);
					}
					else if ("btnTuiJianTaskLingQu5" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step=2;
						this.uiSend(csTuiJianTaskLingQu);
					}
					else if ("btnTuiJianTaskLingQu8" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step=3;
						this.uiSend(csTuiJianTaskLingQu);
					}
					else if ("btnTuiJianTaskLingQu10" == target.parent.name)
					{
						csTuiJianTaskLingQu=new PacketCSGetDayLimitPrize();
						csTuiJianTaskLingQu.step=4;
						this.uiSend(csTuiJianTaskLingQu);
					}
					else
					{
						var csTuiJianTaskLingQu:PacketCSGetDayLimitPrize=new PacketCSGetDayLimitPrize();
						this.uiSend(csTuiJianTaskLingQu);
					}
					break;
				default:
					break;
			}
		}

		/**
		 * 自动寻路
		 *
		 */
		private function autoSeek(seekId:int):void
		{
			var vo:PacketCSAutoSeek=new PacketCSAutoSeek();
			vo.seekid=seekId;
			this.uiSend(vo);
		}

		public function refreshTxt():void
		{
			var now:Date=Data.date.nowDate;
			if (null != mc['txt_server_time'])
			{
				var min:String=now.minutes >= 10 ? now.minutes.toString() : "0" + now.minutes;
				var sec:String=now.seconds >= 10 ? now.seconds.toString() : "0" + now.seconds;
				mc['txt_server_time'].text=now.hours + ":" + min + ":" + sec;
			}
		}

		public function refreshContent(cbtnX:int):void
		{
			//			if (null != mc['hot_area'])
			//			{
			//				mc['hot_area'].removeEventListener(MouseEvent.MOUSE_OVER, _pkTipMouseOverListener);
			//				mc['hot_area'].removeEventListener(MouseEvent.MOUSE_OUT, _pkTipMouseOutListener);
			//			}
			if((this.mc as MovieClip).currentFrame!=cbtnX)
			(this.mc as MovieClip).gotoAndStop(cbtnX);
			mc["f6_sp6"].visible=false;
			mc["sp10"].visible=false;
			mc["sp"].visible=false;
			mc["sp2"].visible=false;
			_visibleTipComplateTask(false);
			refreshTxt();
			switch (cbtnX)
			{
				case 1: //每日活动
					//					showDayTuiJian();
					//					_visibleTipComplateTask(true);
					//HuoDongBridge.qianDao(mc).show();
					//					showKuaFuHuoDong();
					sysAddEvent(mc["txt_action_join"], TextEvent.LINK, txtActionJoinLink);
					showDayHuoDong();
					break;
				case 2: //每日任务
					sysAddEvent(mc["txt_action_join"], TextEvent.LINK, txtActionJoinLink);
					showDayRenWu();
					break;
				case 3: //地宫boss
					sysAddEvent(mc["txt_action_join"], TextEvent.LINK, txtActionJoinLink);
					DiGongBoss.getInstance().setUi(this.mc, this.mc_content);
					break;
				case 4: //精英boss
					sysAddEvent(mc["txt_action_join"], TextEvent.LINK, txtActionJoinLink);
					DiGongBoss.getInstance().setUi(this.mc, this.mc_content, 7);
					break;
				case 5:
					sysAddEvent(mc["txt_action_join"], TextEvent.LINK, txtActionJoinLink);
					showDuoRenHuoDong();
					break;
				case 6:
					break;
				case 7:
					mc["f6_sp6"].visible=false;
					mc["sp"].visible=false;
					mc["sp2"].visible=false;
					mc["sp10"].visible=false;
					HuoDongBridge.m_RewardOfAddMoney(mc).repaint();
					break;
				case 8:
					break;
				case 9:
					mc["f6_sp6"].visible=false;
					mc["sp"].visible=false;
					mc["sp2"].visible=false;
					mc["sp10"].visible=false;
					m_pk_tip=mc['pk_tip'] as MovieClip;
					//增加热区的鼠标事件
					m_pk_tip.visible=false;
					mc['hot_area'].addEventListener(MouseEvent.MOUSE_OVER, _pkTipMouseOverListener);
					mc['hot_area'].addEventListener(MouseEvent.MOUSE_OUT, _pkTipMouseOutListener);
					//请求数据
					var _CSServerTitleWinerName:PacketCSServerTitleWinerName=new PacketCSServerTitleWinerName();
					this.uiSend(_CSServerTitleWinerName);
					//描述 PK 赛获得页签
					showPK();
					break;
				case 10:
					mc["f6_sp6"].visible=false;
					mc["sp"].visible=false;
					mc["sp2"].visible=false;
					mc["sp10"].visible=true;
					showServerVerUpdate();
					//save ver 
					PubData.save(3, PubData.para3);
					//					var cs: = new ();
					//					
					//					cs.data.para1 = -1;
					//					cs.data.para2 = -1;
					//					cs.data.para3 = PubData.data.para3;
					//					cs.data.para4 = -1;
					//					
					//					uiSend(cs);	
					break;
				case 11:
					break;
				case 12: //签到奖励
					QianDao.qianDao(mc).show();
					mc["btnyilingqu"].visible=false;
					var vo:PacketCSActWeekOnline=new PacketCSActWeekOnline();
					uiSend(vo);
					break;
				default:
					break;
			}
		}

		public function showKuaFuHuoDong():void
		{
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			//列表	
			clearMcContent();
			var i:int=0;
			var _length:int;
			var arr:Vector.<Object>=Data.huoDong.kuaFuHuoDong;
			var myCamp:int=Data.myKing.campid;
			for (i=0; i < _length; i++)
			{
				var needCamp:int=parseInt(arr[i]["action_camp"]);
				if (0 == needCamp)
				{
					continue;
				}
				if (needCamp != myCamp)
				{
					arr.splice(i, 1);
					//重置
					i=0;
					_length=arr.length;
				}
			}
			//原始顺序，按照表格中排序字段排序
			var _arrOriginal:Vector.<Object>=arr.sort(viewSort);
			//满足条件的列表
			var _arrEnoughCondition:Vector.<Object>=new Vector.<Object>();
			//未满足条件列表
			var _arrUnEnoughCondition:Vector.<Object>=new Vector.<Object>();
			if (null == _arrOriginal)
			{
				return;
			}
			_length=_arrOriginal.length;
			var _level:int=Data.myKing.level;
			for (i=0; i < _length; ++i)
			{
				if (_level >= parseInt(_arrOriginal[i].action_minlevel) && _level <= parseInt(_arrOriginal[i].action_maxlevel))
				{
					_arrEnoughCondition.push(_arrOriginal[i]);
					_arrOriginal[i]["ash"]=false;
				}
				else
				{
					_arrUnEnoughCondition.push(_arrOriginal[i]);
					_arrOriginal[i]["ash"]=true;
				}
			}
			//当已达到条件，开启，未开启 ，已结束 状态,
			var _arrOpened:Vector.<Object>=new Vector.<Object>();
			var _arrUpOpened:Vector.<Object>=new Vector.<Object>();
			var _arrFinished:Vector.<Object>=new Vector.<Object>();
			_length=_arrEnoughCondition.length;
			var time_cp:int=0;
			for (i=0; i < _length; ++i)
			{
				time_cp=joinTime(_arrEnoughCondition[i]["action_start"], _arrEnoughCondition[i]["action_end"]);
				//开启
				if (1 == time_cp)
				{
					_arrOpened.push(_arrEnoughCondition[i]);
				}
				//未开启
				else if (0 == time_cp)
				{
					_arrUpOpened.push(_arrEnoughCondition[i]);
				}
				//已结束
				else
				{
					_arrFinished.push(_arrEnoughCondition[i]);
				}
			}
			var _arrFinal:Vector.<Object>=_arrOpened.concat(_arrUpOpened, _arrFinished, _arrUnEnoughCondition);
			_arrFinal.forEach(callbackByKuaFuHuoDong);
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			mc["sp2"].source=mc_content;
//			mc["sp2"].position=0;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			this.itemSelectedOther(item1);
		}

		private function txtActionJoinLink(e:TextEvent):void
		{
			Renwu.textLinkListener_(e);
		}

		public static function isBtnTuiJianTaskYiLin(index:int):Boolean
		{
			//test
			//return true;	
			var limit_id:int=Data.huoDong.dayTuiJianTaskLimit_id;
			var limit_id2:int=parseInt(Data.huoDong.dayTuiJianTaskLimit_id_LinQu[index]);
			var sli:StructLimitInfo2=Data.huoDong.getLimitById(limit_id);
			var sli2:StructLimitInfo2=Data.huoDong.getLimitById(limit_id2);
			if (null == sli || null == sli2)
			{
				return false;
			}
			//			MsgPrint.printTrace("sli.curnum:" + sli.curnum.toString(),MsgPrintType.WINDOW_REFRESH);
			//			MsgPrint.printTrace("sli2.curnum:" + sli2.curnum.toString(),MsgPrintType.WINDOW_REFRESH);
			var maxnum:int=0;
			if (0 == index)
			{
				maxnum=3;
			}
			if (1 == index)
			{
				maxnum=5;
			}
			if (2 == index)
			{
				maxnum=8;
			}
			if (3 == index)
			{
				maxnum=10;
			}
			//if (sli.curnum >= 5)
			if (sli.curnum >= maxnum)
			{
				//0表示没领
				if (sli2.curnum > 0)
				{
					return true;
				}
			}
			return false;
		}

		public static function isDayTuiJianTaskCanLing():Boolean
		{
			var arr:Vector.<Pub_CommendResModel>=Data.huoDong.dayTuiJianTaskList;
			var j:int;
			var jLen:int=arr.length;
			for (j=0; j < jLen; j++)
			{
				if (arr[j].name != "undefined")
				{
					//			
					var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(arr[j].limit_id) as Pub_Limit_TimesResModel;
					var limitCount:int;
					if (null == model2)
					{
						limitCount=0;
					}
					else
					{
						limitCount=model2.max_times;
					}
					//
					var itemData_count:int=arr[j].curnum;
					var itemData_show_level:int=arr[j].show_level;
					var myLvl:int=Data.myKing.level;
					//
					if (itemData_count >= limitCount && 0 == arr[j].isGet(Data.huoDong.isGet))
					{
						//点击领取奖励
						return true;
					}
				} //
			}
			return false;
		}

		public static function isBtnTuiJianTaskCanLin(index:int):Boolean
		{
			//test
			//return true;			
			var limit_id:int=Data.huoDong.dayTuiJianTaskLimit_id;
			var limit_id2:int=parseInt(Data.huoDong.dayTuiJianTaskLimit_id_LinQu[index]);
			var sli:StructLimitInfo2=Data.huoDong.getLimitById(limit_id);
			var sli2:StructLimitInfo2=Data.huoDong.getLimitById(limit_id2);
			if (null == sli || null == sli2)
			{
				return false;
			}
			//			MsgPrint.printTrace("sli.curnum:" + sli.curnum.toString(),MsgPrintType.WINDOW_REFRESH);
			//			MsgPrint.printTrace("sli2.curnum:" + sli2.curnum.toString(),MsgPrintType.WINDOW_REFRESH);
			var maxnum:int=0;
			if (0 == index)
			{
				maxnum=3;
			}
			if (1 == index)
			{
				maxnum=5;
			}
			if (2 == index)
			{
				maxnum=8;
			}
			if (3 == index)
			{
				maxnum=10;
			}
			//if (sli.curnum >= 5)
			if (sli.curnum >= maxnum)
			{
				//0表示没领
				if (0 == sli2.curnum)
				{
					return true;
				}
			}
			return false;
		}

		public function showDayTuiJianTaskSort(a:Pub_CommendResModel, b:Pub_CommendResModel):int
		{
			if (a.ar_complete)
			{
				return 1;
			}
			if (b.ar_complete)
			{
				return -1;
			}
			//原样排序
			return 0;
		}

		public function showDayTuiJianSort(a:StructActRecList2, b:StructActRecList2):int
		{
			if (a.ar_complete)
			{
				return 1;
			}
			if (b.ar_complete)
			{
				return -1;
			}
			//原样排序
			return 0;
		}
		public var wan_cheng:int=0;

		public static function GetDayTuiJianByNumTip():int
		{
			var arr:Vector.<Pub_CommendResModel>=Data.huoDong.dayTuiJianTaskList;
			var kLen:int=arr.length;
			var k:int;
			var numTip:int=0;
			var myLvl:int=Data.myKing.level;
			for (k=0; k < kLen; k++)
			{
				//			
				var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(arr[k].limit_id) as Pub_Limit_TimesResModel;
				var limitCount:int;
				if (null == model2)
				{
					limitCount=0;
				}
				else
				{
					limitCount=model2.max_times;
				}
				//== 改为 >= ，以防策划数据填写有误
				var itemData_count:int=arr[k].curnum;
				var itemData_show_level:int=arr[k].show_level;
				var _isGet:int=arr[k].isGet(Data.huoDong.isGet);
				//排序规则调整为：可领取奖励的任务→可接取的任务→已完成的任务→不可接取的任务。
				//
				if (itemData_count >= limitCount && 0 == _isGet)
				{
					//arr1.push(arr[k]);
				}
				else if (itemData_count >= limitCount && 1 == _isGet)
				{
					//"已完成";
					//arr3.push(arr[k]);
				}
				else
				{
					if (myLvl >= itemData_show_level)
					{
						//未完成
						//arr2.push(arr[k]);
						numTip++;
					}
					else
					{
						//不可接
						//arr4.push(arr[k]);
					}
						//-------------------------------------------------------------------------------------
				}
			}
			return numTip;
		}

		/**
		 *	每日推荐
		 */
		public function showDayTuiJian(e:DispatchEvent=null):void
		{
			return;
			if (1 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			//
			mc["sp"].visible=true;
			mc["sp2"].visible=false;
			var i:int;
			var len:int;
			//领取按钮根据活跃度来
			var huoYue:int=Data.huoDong.huoYue;
			var myLvl:int=Data.myKing.level;
			//列表	
			clearMcContent();
			//
			//mc["txtHuoYue"].text = Data.huoDong.huoYue;
			//活跃进度条			
			if (0 == huoYue)
			{
				huoYue=1;
			}
			if (huoYue > 100)
			{
				huoYue=100;
			}
			//			var btnList:Array = [
			//				mc["btnTuiJianTaskLingQu3"],
			//				mc["btnTuiJianTaskLingQu5"],
			//				mc["btnTuiJianTaskLingQu8"],
			//				mc["btnTuiJianTaskLingQu10"],
			//			];
			//			var txtList:Array = [
			//				mc["txtTuiJianTaskLingQu3"],
			//				mc["txtTuiJianTaskLingQu5"],
			//				mc["txtTuiJianTaskLingQu8"],
			//				mc["txtTuiJianTaskLingQu10"],
			//			];
			//			var j:int;
			//			for(j=0;j<btnList.length;j++)
			//			{
			//				btnList[j].visible = false;				
			//				btnList[j].gotoAndStop(1);
			//				
			//				(txtList[j] as TextField).visible = false;
			//				(txtList[j] as TextField).mouseEnabled = false;			
			//			}
			//			for(j=0;j<btnList.length;j++)
			//			{
			//				var canLin:Boolean = HuoDong.isBtnTuiJianTaskCanLin(j);
			//				var yiLin:Boolean = HuoDong.isBtnTuiJianTaskYiLin(j);
			//				
			//				//
			//				if(canLin && !yiLin)
			//				{
			//					btnList[j].visible = true;
			//					btnList[j].gotoAndStop(1);
			//					btnList[j]["mc_effect"].mouseEnabled = false;
			//					
			//					(txtList[j] as TextField).visible = false;
			//				}
			//				else if(yiLin && !canLin)
			//				{
			//					btnList[j].visible = true;
			//					btnList[j].gotoAndStop(2);
			//					
			//					(txtList[j] as TextField).visible = false;
			//				}
			//				else
			//				{
			//					btnList[j].visible = false;
			//					(txtList[j] as TextField).visible = true;					
			//				}
			//			}
			//共4行，每行的格子个数
			//			var line:Array = [5,5,5,5];
			//			
			//			//60100549	活跃度领奖
			//			var DROP_ID_LIST:Array=Data.huoDong.dayTuiJianTaskDropid;
			//			
			//			len = line.length;
			//			
			//			for(var k:int=1;k<=len;k++)
			//			{					
			//				var dropArr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(
			//					
			//					DROP_ID_LIST[k-1]
			//					
			//				);
			//				
			//				var item:Pub_ToolsResModel;
			//				arrayLen=dropArr.length;
			//				
			//				var iLen:int = line[k-1];
			//				for(i=1;i<=iLen;i++)
			//				{
			//					item=null;
			//					child=mc["pic"+ k.toString() + i.toString()];
			//					if(i<=arrayLen)
			//						item=XmlManager.localres.getToolsXml.getResPath(dropArr[i-1].drop_item_id);
			//					if(item!=null){
			//						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
			//						child["txt_num"].text=VipGift.getInstance().getWan(dropArr[i-1].drop_num);		
			//						var bag:StructBagCell2=new StructBagCell2();
			//						bag.itemid=item.tool_id;
			//						Data.beiBao.fillCahceData(bag);
			//						
			//						child.data=bag;
			//						CtrlFactory.getUIShow().addTip(child);
			//						ItemManager.instance().setEquipFace(child);
			//						
			//						//
			//						child.visible = true;
			//						
			//					}else{
			//						child["uil"].unload();
			//						child["txt_num"].text="";
			//						child.data=null;
			//						CtrlFactory.getUIShow().removeTip(child);
			//						ItemManager.instance().setEquipFace(child,false);
			//						//
			//						child.visible = false;
			//					}
			//				}
			//				
			//				
			//			}
			//			var arr:Vector.<Pub_CommendResModel2>=Data.huoDong.dayTuiJianTaskList;
			//			
			//			var arr1:Vector.<Pub_CommendResModel2>=new Vector.<Pub_CommendResModel2>();
			//			var arr2:Vector.<Pub_CommendResModel2>=new Vector.<Pub_CommendResModel2>();
			//			var arr3:Vector.<Pub_CommendResModel2>=new Vector.<Pub_CommendResModel2>();
			//			var arr4:Vector.<Pub_CommendResModel2>=new Vector.<Pub_CommendResModel2>();
			//			
			//			var kLen:int=arr.length;
			//			
			//			for (k=0; k < kLen; k++)
			//			{
			//				//			
			//				var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(arr[k].limit_id);
			//				
			//				var limitCount:int;
			//				
			//				if (null == model2)
			//				{
			//					limitCount=0;
			//					
			//				}
			//				else
			//				{
			//					limitCount=model2.max_times;
			//				}
			//				
			//				
			//				//== 改为 >= ，以防策划数据填写有误
			//				var itemData_count:int=arr[k].curnum;
			//				var itemData_show_level:int=arr[k].show_level;
			//				
			//				var _isGet:int = arr[k].isGet;
			//				
			//				//排序规则调整为：可领取奖励的任务→可接取的任务→已完成的任务→不可接取的任务。
			//				
			//				//
			//				if(itemData_count >= limitCount && 0 == _isGet)
			//				{				
			//					arr1.push(arr[k]);
			//					
			//				}else if (itemData_count >= limitCount && 1 == _isGet)
			//				{
			//					//"已完成";
			//					arr3.push(arr[k]);
			//					
			//				}
			//				else
			//				{
			//					
			//					if (myLvl >= itemData_show_level)
			//					{
			//						//未完成
			//						arr2.push(arr[k]);
			//						
			//						
			//						
			//					}
			//					else
			//					{
			//						//不可接
			//						arr4.push(arr[k]);
			//						
			//						
			//					}
			//					
			//					//-------------------------------------------------------------------------------------
			//				}
			//				
			//			}
			//			
			//			var arrA:Vector.<Pub_CommendResModel2>=arr1.concat(arr2).concat(arr3).concat(arr4);
			//			
			//			wan_cheng=0;
			//			
			//			arrA.forEach(callbackByTuiJianTask);
			//			
			//			//
			//			CtrlFactory.getUIShow().showList2(mc_content, 1, 320, 25);
			//			
			//			//
			//			mc["txt_tui_jian_lian_xu_day"].text=Data.huoDong.getQianDao().continuetimes;
			//			
			//			//
			//			mc["txt_wan_cheng"].text="(" + wan_cheng.toString() + "/" + "10)";//arrA.length.toString() + ")";
			//			
			//			//
			//			var wan_cheng_per:int =  (wan_cheng / arrA.length) * 100;
			//			
			//			if(0 == wan_cheng_per)
			//			{
			//				wan_cheng_per = 1;
			//			}
			//			
			//			if(wan_cheng_per > 100)
			//			{
			//				wan_cheng_per = 100;
			//			}
			//			
			//			mc["bar_wan_cheng"].gotoAndStop(wan_cheng_per);
			//			
			//			mc["sp"].source=mc_content;
			//			mc["sp"].y = 117;
			//			mc_content.x=10;
			//			
			//			var item1:DisplayObject=mc_content.getChildAt(0)
			//			
			//			if (null == item1)
			//			{
			//				return;
			//			}
			//			this.itemSelected(item1);
			//			if(null!=getItemByName("完成宝石副本")){
			//			}
		}

		private function getItemByName(_str:String):Sprite
		{
			var s:Sprite;
			var i:int;
			for (i=0; i < mc_content.numChildren; i++)
			{
				s=mc_content.getChildAt(i) as Sprite;
				if (s["txt_active_desc"].text == _str)
				{
					return s;
				}
			}
			return null;
		}

		private function callbackByTuiJianTask(itemData:Pub_CommendResModel, index:int, arr:Vector.<Pub_CommendResModel>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTuiJianTaskItem(itemData.id);
			super.itemEvent(sprite, itemData, true);
			sprite["txt_active_desc"].mouseEnabled=false;
			sprite["txt_activity"].mouseEnabled=false;
			sprite["bg"].mouseEnabled=false;
			//
			sprite["name"]="item" + (index + 1);
			if (itemData.name == "undefined" || itemData.name == "name")
				return;
			sprite["txt_active_desc"].text=itemData.name;
			sprite["txt_activity"].text=itemData.prize_desc;
			sprite["txt_count"].text=itemData.npc_name;
			sprite["txt_chuan"].htmlText="";
			//
			sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
			sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
			sprite["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
			sprite["btn_chuan"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
			sprite["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
			sprite["btn_chuan"].removeEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
			//			
			var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(itemData.limit_id) as Pub_Limit_TimesResModel;
			var limitCount:int;
			if (null == model2)
			{
				limitCount=0;
			}
			else
			{
				limitCount=model2.max_times;
			}
			//== 改为 >= ，以防策划数据填写有误
			var itemData_count:int=itemData.curnum;
			var itemData_show_level:int=itemData.show_level;
			var myLvl:int=Data.myKing.level;
			//
			if (itemData_count >= limitCount && 0 == itemData.isGet(Data.huoDong.isGet))
			{
				//点击领取奖励
				sprite["txt_count"].text="";
				sprite["txt_count"].htmlText="<font color='#e17d24'><u>" + Lang.getLabel("pub_lin_qu_jiang_li") + "</u></font>";
				sprite["txt_chuan"].htmlText="";
				wan_cheng++;
				var fontGetColor:uint=0x00CC00;
				GameColor.setTextColor(sprite["txt_active_desc"], fontGetColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontGetColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontGetColor, TextFormatAlign.CENTER);
				//				
				sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
				sprite["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
				sprite["btn_chuan"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTaskLinQu);
			}
			else if (itemData_count >= limitCount && 1 == itemData.isGet(Data.huoDong.isGet))
			{
				//sprite["txt_count"].text= "已完成";
				sprite["txt_count"].text=Lang.getLabel("pub_complete");
				sprite["txt_chuan"].htmlText="";
				wan_cheng++;
				var fontCompleteColor:uint=0x00CC00;
				GameColor.setTextColor(sprite["txt_active_desc"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontCompleteColor, TextFormatAlign.CENTER);
					//
			}
			else
			{
				if (myLvl >= itemData_show_level)
				{
					//未完成
					var fontJieShou1:uint=0xfff5d2;
					var fontJieShou2:String="#7bac1b";
					sprite["txt_count"].text="";
					sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + Lang.getLabel("pub_jie_shou_ren_wu") + "</u><font>";
					sprite["txt_chuan"].htmlText="<font color='#e17d24'><u>{" + Lang.getLabel("pub_chuan") + "}</u></font>";
					GameColor.setTextColor(sprite["txt_active_desc"], fontJieShou1, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_activity"], fontJieShou1, TextFormatAlign.LEFT);
					//GameColor.setTextColor(sprite["txt_count"],fontJieShou1,TextFormatAlign.LEFT);
					//					
					sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJianTask);
					sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJianTask);
					sprite["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
					sprite["btn_chuan"].addEventListener(MouseEvent.CLICK, itemClickByTuiJianTask);
				}
				else
				{
					//不可接
					//19ff01
					var fontCannotJie:int=0x666666;
					sprite["txt_count"].text=itemData.level_desc;
					sprite["txt_chuan"].htmlText="";
					GameColor.setTextColor(sprite["txt_active_desc"], fontCannotJie, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_activity"], fontCannotJie, TextFormatAlign.LEFT);
					GameColor.setTextColor(sprite["txt_count"], fontCannotJie, TextFormatAlign.CENTER);
				}
					//-------------------------------------------------------------------------------------
			}
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
			sprite.tipParam=[itemData.tips_desc];
			Lang.addTip(sprite, "pub_param", 150);
		}

		public function itemClickByTuiJianTaskLinQu(e:MouseEvent):void
		{
			var s:*=e.target;
			var sprite:DisplayObjectContainer;
			var vo:PacketCSGetDayPrizeRmb;
			//
			if (s as TextField || s as SimpleButton)
			{
				if ("txt_chuan" == s.name || "btn_chuan" == s.name)
				{
					sprite=s.parent;
					if (sprite.name.indexOf("item") >= 0)
					{
						if (0 == sprite["data"]["isGet"])
						{
							vo=new PacketCSGetDayPrizeRmb();
							vo.limitid=sprite["data"]["limit_id"];
							this.uiSend(vo);
						}
					}
				}
				//
				if ("txt_count" == s.name || "btn_count" == s.name)
				{
					sprite=s.parent;
					if (sprite.name.indexOf("item") >= 0)
					{
						if (0 == sprite["data"]["isGet"])
						{
							vo=new PacketCSGetDayPrizeRmb();
							vo.limitid=sprite["data"]["limit_id"];
							this.uiSend(vo);
						}
					}
				}
			}
		}

		public function itemClickByTuiJianTask(e:MouseEvent):void
		{
			var s:*=e.target;
			var sprite:DisplayObjectContainer;
			var npcid:int;
			var npcid2:int;
			var isNeedCamp:Boolean;
			var vo:PacketCSAutoSeek;
			if (s as TextField || s as SimpleButton)
			{
				if ("txt_chuan" == s.name || "btn_chuan" == s.name)
				{
					sprite=s.parent;
					if (sprite.name.indexOf("item") >= 0)
					{
						npcid=sprite["data"]["npc_id"];
						npcid2=sprite["data"]["npc_id2"];
						isNeedCamp=1 == sprite["data"]["camp"] ? true : false;
						if (isNeedCamp)
						{
							if (3 == Data.myKing.campid)
							{
								GameAutoPath.chuan(npcid2);
							}
							else
							{
								GameAutoPath.chuan(npcid);
							}
						}
						else
						{
							GameAutoPath.chuan(npcid);
						}
					}
				} //end if
				if ("txt_count" == s.name || "btn_count" == s.name)
				{
					sprite=s.parent;
					if (sprite.name.indexOf("item") >= 0)
					{
						npcid=sprite["data"]["npc_id"];
						npcid2=sprite["data"]["npc_id2"];
						isNeedCamp=1 == sprite["data"]["camp"] ? true : false;
						if (isNeedCamp)
						{
							if (3 == Data.myKing.campid)
							{
								GameAutoPath.seek(npcid2);
									//MissionNPC.instance().setNpcId(npcid2, false);
							}
							else
							{
								GameAutoPath.seek(npcid);
									//MissionNPC.instance().setNpcId(npcid, false);
							}
						}
						else
						{
							GameAutoPath.seek(npcid);
								//MissionNPC.instance().setNpcId(npcid, false);
						}
					}
				} //end if
			}
		}

		//tuiJian task begin -----------------------------------------------------------------------------------
		public function itemOverListenerTuiJianTask(e:MouseEvent):void
		{
			var sprite:*=e.target;
			if (sprite as TextField)
			{
				sprite=sprite.parent;
			}
			if (sprite.name.indexOf("item") >= 0)
			{
				GameColor.setTextColor(sprite["txt_active_desc"], 0x54E9D3, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], 0x54E9D3, TextFormatAlign.LEFT);
					//GameColor.setTextColor(sprite["txt_count"],0x54E9D3,TextFormatAlign.CENTER);
			}
		}

		public function itemOutListenerTuiJianTask(e:MouseEvent):void
		{
			var sprite:*=e.target;
			if (sprite as TextField)
			{
				sprite=sprite.parent;
			}
			if (sprite.name.indexOf("item") >= 0)
			{
				GameColor.setTextColor(sprite["txt_active_desc"], 0xfff5d2, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], 0xfff5d2, TextFormatAlign.LEFT);
					//Lang.getLabel("pub_complete")
					//GameColor.setTextColor(sprite["txt_count"],0xffffff,TextFormatAlign.CENTER);
			}
		}

		public function showDayRenWu():void
		{
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			//列表	
			clearMcContent();
			var arr:Vector.<Object>=Data.huoDong.dayTask;
			//活动等级过滤
			var len:int=arr.length;
			var myLvl:int=Data.myKing.level;
			for (var i:int=0; i < len; i++)
			{
				var minLvl:int=parseInt(arr[i]["action_minlevel"]);
				var maxLvl:int=parseInt(arr[i]["action_maxlevel"]);
				if (myLvl >= minLvl && myLvl <= maxLvl)
				{
				}
				else
				{
					arr.splice(i, 1);
					//重置
					i=-1;
					len=arr.length;
				}
			}
			//陈营过滤
			//需求补充：
			//在活动表中增加“需求阵营”字段action_camp。
			//填0为无阵营需求，填其他为对应阵营玩家才能看到
			len=arr.length;
			var myCamp:int=Data.myKing.campid;
			for (i=0; i < len; i++)
			{
				var needCamp:int=parseInt(arr[i]["action_camp"]);
				if (0 == needCamp)
				{
					continue;
				}
				if (needCamp != myCamp)
				{
					arr.splice(i, 1);
					//重置
					i=0;
					len=arr.length;
				}
			}
			//MissionMain.getTaskStatusById() 
			//	技术部-王稳 09:20:42
			//0没有此任务1可接受2未完成3未提交4不可接5失败
			//走limitId
			var A1:Vector.<Object>=new Vector.<Object>();
			var A2:Vector.<Object>=new Vector.<Object>();
			var A3:Vector.<Object>=new Vector.<Object>();
			len=arr.length;
			//<1>.每日任务排序规则：未完成的任务→未达到任务开启等级的任务(灰态显示)→已经完成的任务
			for (i=0; i < len; i++)
			{
				var itemData:Object=arr[i];
				var limit_id:int=itemData["limit_id"];
				var limit_result:Array=findLimit(limit_id);
				var itemObj:Object = new Object();
				itemObj["enough"] = arr[i];
				if (limit_result[0] && !limit_result[1])
				{
					if (myLvl >= itemData["action_minlevel"] && myLvl <= itemData["action_maxlevel"])
					{
						A1.push(itemObj);
						itemObj["ash"]=false;
					}
					else
					{
						A2.push(itemObj);
						itemObj["ash"]=true;
					}
				}
				if (!limit_result[0])
				{
					A2.push(itemObj);
				}
				if (limit_result[0] && limit_result[1])
				{
					A3.push(itemObj);
				}
			}
			//var arr2:Vector.<Object> = arr.sort(viewSort);
			var arr2:Vector.<Object>=new Vector.<Object>().concat(A1.concat(A2).concat(A3));
			arr2.forEach(callbackByDayRenWu);
			//arr.forEach(callbackByDayRenWu);
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			/*
			指定宽高，滑动条会有问题
			mc["sp2"].x = this.SP_DAY_TASK_REC.x;
			mc["sp2"].y = this.SP_DAY_TASK_REC.y;
			mc["sp2"].width = this.SP_DAY_TASK_REC.width;
			mc["sp2"].height = this.SP_DAY_TASK_REC.height;
			*/
			mc["sp2"].source=mc_content;
			mc["sp2"].position=0;
			mc["sp2"].x=50;
			mc["sp2"].y=SP_Y;
			//mc_content.x=10;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			this.itemSelectedOther(item1);
		}

		public function showDuoRenHuoDong():void
		{
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			//列表	
			clearMcContent();
			var arr:Vector.<Object>=Data.huoDong.duoRenHuoDong;
			//陈营过滤
			//需求补充：
			//在活动表中增加“需求阵营”字段action_camp。
			//填0为无阵营需求，填其他为对应阵营玩家才能看到
			var _length:uint=arr.length;
			var myCamp:int=Data.myKing.campid;
			for (i=0; i < _length; i++)
			{
				var needCamp:int=parseInt(arr[i]["action_camp"]);
				if (0 == needCamp)
				{
					continue;
				}
				if (needCamp != myCamp)
				{
					arr.splice(i, 1);
					//重置
					i=0;
					_length=arr.length;
				}
			}
			//原始顺序，按照表格中排序字段排序
			var _arrOriginal:Vector.<Object>=arr.sort(viewSort);
			//满足条件的列表
			var _arrEnoughCondition:Vector.<Object>=new Vector.<Object>();
			//未满足条件列表
			var _arrUnEnoughCondition:Vector.<Object>=new Vector.<Object>();
			//活动等级过滤
			_length=arr.length;
			var myLvl:int=Data.myKing.level;
			for (var i:int=0; i < _length; i++)
			{
				var minLvl:int=parseInt(_arrOriginal[i]["action_minlevel"]);
				var maxLvl:int=parseInt(_arrOriginal[i]["action_maxlevel"]);
				if (myLvl >= minLvl && myLvl <= maxLvl)
				{
					_arrEnoughCondition.push(_arrOriginal[i]);
					_arrOriginal[i]["ash"]=false;
				}
				else
				{
					_arrUnEnoughCondition.push(_arrOriginal[i]);
					_arrOriginal[i]["ash"]=true;
				}
			}
			var _arrFinal:Vector.<Object>=_arrEnoughCondition.concat(_arrUnEnoughCondition);
			_arrFinal.forEach(callbackByDuoRenHuoDong);
			//arr.forEach(callbackByDuoRenHuoDong);
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			/*
			指定宽高，滑动条会有问题
			mc["sp2"].x = this.SP_DAY_HUODONG_REC.x;
			mc["sp2"].y = this.SP_DAY_HUODONG_REC.y;
			mc["sp2"].width = this.SP_DAY_HUODONG_REC.width;
			mc["sp2"].height = this.SP_DAY_HUODONG_REC.height;
			*/
			mc["sp2"].source=mc_content;
			mc["sp2"].position=0;
			mc["sp2"].x=17;
			mc["sp2"].y=SP_Y;
			//mc_content.x=10;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			this.itemSelectedOther(item1);
		}

		/**
		 * PK 赛活动
		 *
		 */
		public function showPK():void
		{
			if (9 != (this.mc as MovieClip).currentFrame)
			{
				return;
			}
			//掌教至尊 [通天]
			if (null == m_pSCServerTitleWinerName2 || "" == m_pSCServerTitleWinerName2.name_2)
			{
				mc["name_100"].text=Lang.getLabel("pub_xu_wei_yi_dai");
				mc["hot_area"]["hot_area_100"].has=false;
			}
			else
			{
				mc["name_100"].text=m_pSCServerTitleWinerName2.name_2;
				mc["hot_area"]["hot_area_100"].has=true;
			}
			//掌教至尊 [太乙]
			if (null == m_pSCServerTitleWinerName2 || "" == m_pSCServerTitleWinerName2.name_1)
			{
				mc["name_200"].text=Lang.getLabel("pub_xu_wei_yi_dai");
				mc["hot_area"]["hot_area_200"].has=false;
			}
			else
			{
				mc["name_200"].text=m_pSCServerTitleWinerName2.name_1;
				mc["hot_area"]["hot_area_200"].has=true;
			}
			//PK之王
			if (null == m_pSCServerTitleWinerName2 || "" == m_pSCServerTitleWinerName2.name_3)
			{
				mc["name_300"].text=Lang.getLabel("pub_xu_wei_yi_dai");
				mc["hot_area"]["hot_area_300"].has=false;
			}
			else
			{
				mc["name_300"].text=m_pSCServerTitleWinerName2.name_3;
				mc["hot_area"]["hot_area_300"].has=true;
			}
			//皇城霸主
			if (null == m_pSCServerTitleWinerName2 || "" == m_pSCServerTitleWinerName2.name_4)
			{
				mc["name_400"].text=Lang.getLabel("pub_xu_wei_yi_dai");
				mc["hot_area"]["hot_area_400"].has=false;
			}
			else
			{
				mc["name_400"].text=m_pSCServerTitleWinerName2.name_4;
				mc["hot_area"]["hot_area_400"].has=true;
			}
		}

		public function showServerVerUpdate():void
		{
			if (10 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			if (null != xmlModel)
			{
				mc["txt_title"].htmlText=xmlModel.title;
				mc["txt_contents"].htmlText=xmlModel.contents;
				mc["txt_contents"].height=mc["txt_contents"].textHeight + 10;
				mc["sp10"].source=mc["txt_contents"];
			}
		}

		public function viewSort(a:Object, b:Object):int
		{
			var a_view_sort_id:int=parseInt(a.view_sort_id);
			var b_view_sort_id:int=parseInt(b.view_sort_id);
			//if(a.view_sort_id > b.view_sort_id)
			if (a_view_sort_id > b_view_sort_id)
			{
				return 1;
			}
			//if(a.view_sort_id < b.view_sort_id)
			if (a_view_sort_id < b_view_sort_id)
			{
				return -1;
			}
			//原样排序
			return 0;
		}

		public function showDayHuoDong():void
		{
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			mc["sp2"].overHeight=30;
			//列表	
			
			var i:int=0;
			var _length:int;
			var arr:Vector.<Object>=Data.huoDong.dayHuoDong;
			var myCamp:int=Data.myKing.campid;
			for (i=0; i < _length; i++)
			{
				var needCamp:int=parseInt(arr[i]["action_camp"]);
				if (0 == needCamp)
				{
					continue;
				}
				if (needCamp != myCamp)
				{
					arr.splice(i, 1);
					//重置
					i=0;
					_length=arr.length;
				}
			}
			//原始顺序，按照表格中排序字段排序
			var _arrOriginal:Vector.<Object>=arr.sort(viewSort);
			//满足条件的列表
			var _arrEnoughCondition:Vector.<Object>=new Vector.<Object>();
			//未满足条件列表
			var _arrUnEnoughCondition:Vector.<Object>=new Vector.<Object>();
			if (null == _arrOriginal)
			{
				return;
			}
			_length=_arrOriginal.length;
			if(_length>0){
				clearMcContent();
			}else{
				return;
			}
			var _level:int=Data.myKing.level;
			for (i=0; i < _length; ++i)
			{
				if (_level >= parseInt(_arrOriginal[i].action_minlevel) && _level <= parseInt(_arrOriginal[i].action_maxlevel))
				{
					_arrEnoughCondition.push(_arrOriginal[i]);
						//_arrOriginal[i]["ash"]=false;
				}
				else
				{
					_arrUnEnoughCondition.push(_arrOriginal[i]);
						//_arrOriginal[i]["ash"]=true;
				}
			}
			var arrAll:Vector.<Object>=_arrEnoughCondition.concat(_arrUnEnoughCondition);
			//当已达到条件，开启，未开启 ，已结束 状态,
			var _arrOpened:Vector.<Object>=new Vector.<Object>();
			var _arrUpOpened:Vector.<Object>=new Vector.<Object>();
			var _arrFinished:Vector.<Object>=new Vector.<Object>();
			_length=arrAll.length;
			var time_cp:int=0;
			for (i=0; i < _length; ++i)
			{
				time_cp=joinTime(arrAll[i]["action_start"], arrAll[i]["action_end"]);
				var obj:Object = new Object();
				obj["enough"] = arrAll[i];
				//开启
				if (1 == time_cp)
				{
					obj["ash"]=true;
					_arrOpened.push(obj);
				}
				//未开启
				else if (0 == time_cp)
				{
					//_arrEnoughCondition[i]["ash"]=false;
					obj["ash"]=true;
					_arrUpOpened.push(obj);
				}
				//已结束
				else
				{
					obj["ash"]=false;
					_arrFinished.push(obj);
				}
			}

			var _arrFinal:Vector.<Object>=_arrOpened.concat(_arrUpOpened, _arrFinished);
//			var _arrFinal:Vector.<Object>=_arrOpened.concat(_arrUpOpened.sort(viewSort), _arrFinished.sort(viewSort));
			//_arrFinal=_arrFinal.sort(viewSort);
			_arrFinal.forEach(callbackByDayHuoDong);
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			mc["sp2"].source=mc_content;
			mc["sp2"].position=0;
			mc["sp2"].x=50;
			mc["sp2"].y=SP_Y;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			this.itemSelectedOther(item1);
		}

		//付老师原始函数
		public function showDayHuoDong2():void
		{
			mc["sp"].visible=false;
			mc["sp2"].visible=true;
			//列表	
			clearMcContent();
			var arr:Vector.<Object>=Data.huoDong.dayHuoDong;
			//活动等级过滤
			var len:int=arr.length;
			var myLvl:int=Data.myKing.level;
			//for(var i:int=0;i<len;i++)
			//{
			//	var minLvl:int = parseInt(arr[i]["action_minlevel"]);
			//	var maxLvl:int = parseInt(arr[i]["action_maxlevel"]);
			//	if(myLvl >= minLvl   &&
			//		myLvl <= maxLvl)
			//	{
			//nothing
			//	}else
			//	{
			//arr.splice(i,1);
			//重置
			//i = -1;
			//len = arr.length;
			//	}
			//}
			//陈营过滤
			//需求补充：
			//在活动表中增加“需求阵营”字段action_camp。
			//填0为无阵营需求，填其他为对应阵营玩家才能看到
			len=arr.length;
			var myCamp:int=Data.myKing.campid;
			for (i=0; i < len; i++)
			{
				var needCamp:int=parseInt(arr[i]["action_camp"]);
				if (0 == needCamp)
				{
					continue;
				}
				if (needCamp != myCamp)
				{
					arr.splice(i, 1);
					//重置
					i=0;
					len=arr.length;
				}
			}
			//原排序
			var A1:Vector.<Object>=arr.sort(viewSort);
			//
			var A2:Vector.<Object>=new Vector.<Object>();
			//找出未开启放出最小，且变灰
			//找出最小等级大于我等级，且变灰
			len=A1.length;
			var itemData:Object;
			var time_cp:int;
			var vcc:Vector.<Object>;
			for (i=0; i < len; i++)
			{
				itemData=A1[i];
				time_cp=joinTime(itemData["action_start"], itemData["action_end"]);
				//变灰
				itemData["ash"]=false;
				if (0 == time_cp)
				{
					itemData["ash"]=true;
					vcc=A1.splice(i, 1);
					A2.push(vcc[0]);
					len=A1.length;
					i=-1;
					continue;
				}
			}
			//			
			A2=A1.concat(A2);
			//
			var A3:Vector.<Object>=new Vector.<Object>();
			len=A2.length;
			for (i=0; i < len; i++)
			{
				itemData=A2[i];
				time_cp=joinTime(itemData["action_start"], itemData["action_end"]);
				if (myLvl < itemData["action_minlevel"])
				{
					itemData["ash"]=true;
					vcc=A2.splice(i, 1);
					A3.push(vcc[0]);
					len=A2.length;
					i=-1;
					continue;
				}
			}
			A3=A2.concat(A3);
			//var arr2:Vector.<Object> = arr.sort(viewSort);
			A3.forEach(callbackByDayHuoDong);
			//arr.forEach(callbackByDayHuoDong);
			CtrlFactory.getUIShow().showList2(mc_content, 1, 417, 25);
			/*
			指定宽高，滑动条会有问题
			mc["sp2"].x = this.SP_DAY_HUODONG_REC.x;
			mc["sp2"].y = this.SP_DAY_HUODONG_REC.y;
			mc["sp2"].width = this.SP_DAY_HUODONG_REC.width;
			mc["sp2"].height = this.SP_DAY_HUODONG_REC.height;
			*/
			mc["sp2"].source=mc_content;
			mc["sp2"].position=0;
			mc["sp2"].x=17;
			mc["sp2"].y=SP_Y;
			//mc_content.x=10;
			mc_content.x=0;
			var item1:DisplayObject=mc_content.getChildByName("item1");
			if (null == item1)
			{
				return;
			}
			this.itemSelected(item1);
			this.itemSelectedOther(item1);
		}

		//列表中条目处理方法
		private function callbackByTuiJian(itemData:StructActRecList2, index:int, arr:Vector.<StructActRecList2>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTuiJianItem(itemData.arid);
			super.itemEvent(sprite, itemData);
			sprite["name"]="item" + (index + 1);
			//
			var model1:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(itemData.arid) as Pub_AchievementResModel;
			if (null == model1)
			{
				return;
			}
			sprite["txt_active_desc"].text=itemData.target_desc;
			sprite["txt_activity"].text=itemData.active_desc;
			var model2:Pub_Limit_TimesResModel=XmlManager.localres.limitTimesXml.getResPath(model1.limit_id) as Pub_Limit_TimesResModel;
			var limitCount:int;
			if (null == model2)
			{
				limitCount=0;
			}
			else
			{
				limitCount=model2.max_times;
			}
			//== 改为 >= ，以防策划数据填写有误
			if (itemData.count >= limitCount)
			{
				//sprite["txt_count"].text= "已完成";
				sprite["txt_count"].text=Lang.getLabel("pub_complete");
				var fontCompleteColor:uint=0x19ff01; //0x666666;
				GameColor.setTextColor(sprite["txt_active_desc"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"], fontCompleteColor, TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_count"], fontCompleteColor, TextFormatAlign.CENTER);
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.removeEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				sprite.removeEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
			}
			else
			{
				sprite["txt_count"].text=itemData.count.toString() + "/" + limitCount.toString();
				//-------------------------------------------------------------------------------------
				sprite.removeEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.removeEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.removeEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				sprite.removeEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
				sprite.addEventListener(MouseEvent.MOUSE_OVER, itemOverListenerTuiJian);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, itemOutListenerTuiJian);
				//sprite.addEventListener(MouseEvent.CLICK, itemClickByTuiJian);
				sprite.doubleClickEnabled=true;
				sprite.addEventListener(MouseEvent.DOUBLE_CLICK, itemDClickByTuiJian);
				/*function itemOverListener2(e:MouseEvent):void
				{
				GameColor.setTextColor(sprite["txt_count"],0x54E9D3,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_active_desc"],0x54E9D3,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"],0x54E9D3,TextFormatAlign.LEFT);
				}
				function itemOutListener2(e:MouseEvent):void
				{
				GameColor.setTextColor(sprite["txt_count"],0xffffff,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_active_desc"],0xffffff,TextFormatAlign.LEFT);
				GameColor.setTextColor(sprite["txt_activity"],0xffffff,TextFormatAlign.LEFT);
				}*/
					//-------------------------------------------------------------------------------------
			}
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
		}

		//tuiJian begin -----------------------------------------------------------------------------------
		public function itemOverListenerTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			GameColor.setTextColor(sprite["txt_count"], 0x54E9D3, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_active_desc"], 0x54E9D3, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_activity"], 0x54E9D3, TextFormatAlign.LEFT);
		}

		public function itemOutListenerTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			GameColor.setTextColor(sprite["txt_count"], 0xfff5d2, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_active_desc"], 0xfff5d2, TextFormatAlign.LEFT);
			GameColor.setTextColor(sprite["txt_activity"], 0xfff5d2, TextFormatAlign.LEFT);
		}

		//tuiJian end -----------------------------------------------------------------------------------
		/**
		 * 1	进入强化页面
		 2	进入重铸页面
		 * LianDanLu.instance().setType(1)  强化
		 * LianDanLu.instance().setType(2)重铸
		 * LianDanLu.instance().setType(3)丹药
		 *  JiaoSe.getInstance().setType(2); 炼骨
		 */
		public function itemDClickByTuiJian(e:MouseEvent):void
		{
			var sprite:*=e.target;
			var win_t:int=parseInt(sprite["data"]["window_type"]);
			switch (win_t)
			{
				case 1:
					LianDanLu.instance().setType(1);
					break;
				case 2:
					LianDanLu.instance().setType(2);
					break;
				case 3:
					break;
				case 4:
					//LianDanLu.instance().setType(3);
					break;
				case 5:
					//JiaoSe.getInstance().setType(2); 
					break;
			}
		}

		public function findLimit(limit_id:int, sprite:Sprite=null):Array
		{
			var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
			var jLen:int=limitList.length;
			//var limit_id:int = itemData["limit_id"];
			var find:Boolean=false;
			var numComplete:Boolean=false;
			var find_cunnum:int=0;
			var find_maxnum:int=0;
			for (var j:int=0; j < jLen; j++)
			{
				if (limitList[j].limitid == limit_id)
				{
					if (limitList[j].curnum == limitList[j].maxnum)
					{
						//sprite["kai_qi2"].visible = false;
						//sprite["kai_qi3"].visible = true;		
						numComplete=true;
					}
					else
					{
						//sprite["kai_qi2"].visible = true;
						//sprite["kai_qi3"].visible = false;	
						numComplete=false;
					}
					find_cunnum=limitList[j].curnum;
					find_maxnum=limitList[j].maxnum;
					find=true;
					if (null != sprite)
					{
						sprite["txt_limit"].htmlText=limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						if (limit_id == 0)
						{
							sprite["txt_limit"].htmlText="无";
						}
					}
					break;
				}
			} //end for
			//test
			//return [find, true, find_cunnum, find_maxnum];
			return [find, numComplete, find_cunnum, find_maxnum];
		}

		public static function joinTime(action_start:String, action_end:String, now:Date=null):int
		{
			var time_cp:int=0;
			//
			//var now:Date=Data.date.nowDate;
			if (null == now)
			{
				now=Data.date.nowDate;
			}
			//var action_start:String = itemData["action_start"];
			//var action_end:String = itemData["action_end"];
			var action_start_spli:Array=action_start.split(":");
			var action_end_spli:Array=action_end.split(":");
			var action_start_hour:int=action_start_spli[0];
			var action_start_min:int=action_start_spli[1];
			var action_start_sec:int=action_start_spli[2];
			var action_end_hour:int=action_end_spli[0];
			var action_end_min:int=action_end_spli[1];
			var action_end_sec:int=action_end_spli[2];
			var start:Date=Data.date.nowDate;
			start.hours=action_start_hour;
			start.minutes=action_start_min;
			start.seconds=action_start_sec;
			var end:Date=Data.date.nowDate;
			end.hours=action_end_hour;
			end.minutes=action_end_min;
			end.seconds=action_end_sec;
			//开启时间
			if (now.time >= start.time && now.time <= end.time)
			{
				//开启
				//sprite["kai_qi1"].visible = false;
				//sprite["kai_qi2"].visible = true;
				time_cp=1;
			}
			else if (now.time < start.time)
			{
				//sprite["kai_qi1"].visible = true;
				//sprite["kai_qi1"].gotoAndStop(1);
				//sprite["kai_qi2"].visible = false;
				time_cp=0;
			}
			else if (now.time > end.time)
			{
				//sprite["kai_qi1"].visible = true;
				//sprite["kai_qi1"].gotoAndStop(2);
				//sprite["kai_qi2"].visible = false;
				time_cp=2;
			}
			return time_cp;
		}

		/**
		 *	得到活动需要时间
		 * 	2014-02-18
		 */
		public static function getJoinTime(action_start:String, action_end:String):int
		{
			var now:Date=Data.date.nowDate;
			var action_start_spli:Array=action_start.split(":");
			var action_end_spli:Array=action_end.split(":");
			var action_start_hour:int=action_start_spli[0];
			var action_start_min:int=action_start_spli[1];
			var action_start_sec:int=action_start_spli[2];
			var action_end_hour:int=action_end_spli[0];
			var action_end_min:int=action_end_spli[1];
			var action_end_sec:int=action_end_spli[2];
			var start:Date=Data.date.nowDate;
			start.hours=action_start_hour;
			start.minutes=action_start_min;
			start.seconds=action_start_sec;
			var end:Date=Data.date.nowDate;
			end.hours=action_end_hour;
			end.minutes=action_end_min;
			end.seconds=action_end_sec;
			if (now.time > start.time)
			{
				return int((end.time - now.time) / 1000);
			}
			else
			{
				return int((end.time - start.time) / 1000);
			}
		}

		/**
		 *	每日任务
		 */
		private function callbackByDayRenWu(_itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var itemData:Object = _itemData.enough;
			var sprite:*=ItemManager.instance().getHuoDongTaskAndHuoDongItem2(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			sprite["name"]="item" + (index + 1);
			//
			if (sprite.hasOwnProperty("bg"))
			{
				sprite["bg"].mouseEnabled=false;
			}
			if (sprite.hasOwnProperty("back"))
			{
				sprite["back"].mouseEnabled=false;
			}
			//
			sprite["txt_action_date"].mouseEnabled=false;
			sprite['txt_Condition'].mouseEnabled=false;
			sprite["txt_limit"].mouseEnabled=false;
			sprite["uil"].mouseEnabled=sprite["uil"].mouseChildren=false;
			sprite['txt_Condition'].mouseEnabled=false;
			sprite["txt_action_date"].mouseEnabled=false;
			sprite['txt_limit'].mouseEnabled=false;
			sprite["txt_action_date"].text=itemData["action_date"];
			sprite["txt_count"].htmlText="";
			//
			StringUtils.setEnable(sprite);
			//
			sprite['txt_Condition'].htmlText=itemData["action_prize"];
			//				
			var myLvl:int=Data.myKing.level;
			//
			//未完成
			var fontJieShou1:uint=0xfff5d2;
			var fontJieShou2:String="#7bac1b";
			//
			var limit_id:int=itemData["limit_id"];
			var limit_result:Array=findLimit(limit_id, sprite);
			//
			var yijie:Boolean=false;
			var cycle_id:int=itemData["cycle_id"];
			yijie=Data.npc.yiJie(cycle_id);
			//
			var cycle_list:Vector.<StructTaskList2>=Data.npc.findByCycleId(cycle_id);
			var end:Boolean=false;
			if (cycle_list.length > 0)
			{
				end=3 == cycle_list[0].status ? true : false;
			}
			//
			if (limit_result[1]) // || end)
			{
				sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + "已完成" + "</u><font>";
			}
			else if (false == yijie && (false == limit_result[1] || false == end))
			{
				sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + "领取任务" + "</u><font>";
			}
			else if (true == yijie && false == limit_result[1])
				//(false == limit_result[1] && false == end))
			{
				sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + "任务进行中" + "</u><font>";
			}
			else
			{
				sprite["txt_count"].htmlText="<font color='" + fontJieShou2 + "'><u>" + Lang.getLabel("pub_jie_shou_ren_wu") + "</u><font>";
			}
			//---------------------------------------------------------------
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByDayRenWu2);
			sprite["btn_count"].removeEventListener(MouseEvent.CLICK, itemClickByDayRenWu2);
			sprite["btn_count"].addEventListener(MouseEvent.CLICK, itemClickByDayRenWu2);
			//
//			sprite["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			sprite["uil"].mouseEnabled=false;
			//----------------------------------------------------------------
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
		}

		public static function itemClickByDayRenWuByActionId(action_id:int):void
		{
			var m:Pub_Action_DescResModel=XmlManager.localres.ActionDescXml.getResPath(action_id) as Pub_Action_DescResModel;
			if (null == m)
			{
				return;
			}
			var action_jointype:String=m["action_jointype"];
			if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
			}
			else if ("1" == action_jointype)
			{
				//寻路		
				GameAutoPath.seek(m["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=m["action_para1"];
				FuBenDuiWu.groupid=instance_id;
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					//#Request:PacketCSSInstanceStart
					//#Respond:PacketSCSInstanceStart
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					//this.uiSend(client1);
					DataKey.instance.send(client1);
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
				/*if(0 == m["action_para1"] ||
				1 == m["action_para1"])
				{
				//单人副本快速进入
				//#Request:PacketCSSInstanceStart
				//#Respond:PacketSCSInstanceStart
				var client1:PacketCSSInstanceStart = new PacketCSSInstanceStart();
				client1.map_id = selectedItem.instanceid;
				this.uiSend(client1);
				}else
				{
				FuBenDuiWu.instance.open(true);
				}*/
				FuBenDuiWu.instance.open(true);
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
			}
			else if ("4" == action_jointype)
			{
				/*var cs:PacketCSMapSend = new PacketCSMapSend();
				cs.sendid = parseInt(sprite["data"]["action_para1"]);
				uiSend(cs);*/
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=m["action_id"];
				cs.seek_id=m["action_para1"];
				cs.token=0;
				//uiSend(cs);
				DataKey.instance.send(cs);
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=m["action_para1"];
				//uiSend(cs5);
				DataKey.instance.send(cs5);
			}
			else if ("6" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();
			}
			else if ("7" == action_jointype)
			{
				//CSEntryGuildBoss
				var cs7:PacketCSEntryGuildBoss=new PacketCSEntryGuildBoss();
				DataKey.instance.send(cs7);
			}
			else if ("8" == action_jointype)
			{
				//var cs8:PacketCSAutoSend = new PacketCSAutoSend();
				//cs8.seekid = parseInt(sprite["data"]["action_para1"]);
				//uiSend(cs8);
				JiaZuModel.getInstance().requestEntryGuildHome(1);
			}
			else if ("9" == action_jointype)
			{
				JiaZuModel.getInstance().requestEntryGuildHome(2);
			}
			else if ("10" == action_jointype)
			{
				var cs10:PacketCSEntryGuildMelee=new PacketCSEntryGuildMelee();
				cs10.action_id=m["action_id"];
				DataKey.instance.send(cs10);
			}
			else if ("11" == action_jointype)
			{
				//直接传送
				//var cs11:PacketCSAutoSend = new PacketCSAutoSend();
				//cs11.seekid=m["action_para1"];
				//DataKey.instance.send(cs11);
				JiaZuModel.getInstance().requestEntryGuildHome(3);
			}
			else if ("12" == action_jointype)
			{
				var cs12:PacketCSEntryCityAction=new PacketCSEntryCityAction();
				cs12.action_id=m["action_id"];
				DataKey.instance.send(cs12);
			}
			else if ("13" == action_jointype)
			{
				var cs13:PacketCSEntryPKKinger=new PacketCSEntryPKKinger();
				cs13.action_id=m["action_id"];
				DataKey.instance.send(cs13);
			}
			else if ("14" == action_jointype)
			{
				DiGongMap.instance().open(true);
			}
			else if ("15" == action_jointype)
			{
				var cs15:PacketCSEntryPKOneAction=new PacketCSEntryPKOneAction();
				cs15.action_id=m["action_id"];
				DataKey.instance.send(cs15);
			}
			else if ("16" == action_jointype)
			{
				var cs16:PacketCSEntryServerTower=new PacketCSEntryServerTower();
				cs16.action_id=m["action_id"];
				DataKey.instance.send(cs16);
			}
			else if ("18" == action_jointype)
			{
				//BangPaiTuLongDaZuoZhan.instance.open();
			}
			else if ("50" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=20012;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("51" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=80005;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("52" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=80004;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("60" == action_jointype)
			{
				//
			}
		}

		public function itemClickByDayRenWu2(e:MouseEvent):void
		{
						var sprite:*=e.target.parent;
			var action_jointype:String=sprite["data"]["action_jointype"];
			if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
			}
			else if ("1" == action_jointype)
			{
				//寻路		
				GameAutoPath.seek(sprite["data"]["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					//#Request:PacketCSSInstanceStart
					//#Respond:PacketSCSInstanceStart
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					this.uiSend(client1);
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
			}
			else if ("4" == action_jointype)
			{
				/*var cs:PacketCSMapSend = new PacketCSMapSend();
				cs.sendid = parseInt(sprite["data"]["action_para1"]);
				uiSend(cs);*/
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				uiSend(cs);
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
				uiSend(cs5);
			}
			else if ("6" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();
			}
		}

		public function itemClickByDuoRenHuoDong2(e:MouseEvent):void
		{
						var sprite:*=e.target.parent;
			var action_jointype:String=sprite["data"]["action_jointype"];
			if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
			}
			else if ("1" == action_jointype)
			{
				//寻路
				GameAutoPath.seek(sprite["data"]["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					//#Request:PacketCSSInstanceStart
					//#Respond:PacketSCSInstanceStart
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					this.uiSend(client1);
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
			}
			else if ("4" == action_jointype)
			{
				/*var cs:PacketCSMapSend = new PacketCSMapSend();
				cs.sendid = parseInt(sprite["data"]["action_para1"]);
				uiSend(cs);*/
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				uiSend(cs);
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
				uiSend(cs5);
			}
			else if ("6" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();
			}
		}

		private function callbackByBossHuoDong(itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTaskAndHuoDongItem(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			sprite["name"]="item" + (index + 1);
			//
			if (sprite.hasOwnProperty("bg"))
			{
				sprite["bg"].mouseEnabled=false;
			}
			//
			//			sprite["txt_action_name"].text=itemData["action_name"];
			//			sprite["txt_action_name"].mouseEnabled=false;
			sprite["txt_action_date"].text=itemData["action_date"];
			sprite["txt_action_date"].mouseEnabled=false;
//			sprite["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			sprite["uil"].mouseEnabled=false;
			sprite["kai_qi1"].visible=false;
			sprite["kai_qi2"].visible=false;
			sprite["kai_qi3"].visible=false;
			if (null != sprite["kai_qi4"])
				sprite["kai_qi4"].visible=false;
			//
			StringUtils.setEnable(sprite);
			sprite['txt_Condition'].htmlText=itemData["action_prize"];
			;
			//			if (itemData["ash"])
			//			{
			//				StringUtils.setUnEnable(sprite);
			//				sprite['txt_Condition'].htmlText=Lang.getLabel("40080_DayHuoDong_condition", [itemData.action_minlevel, itemData.action_maxlevel]);
			//			}
			//
			var time_cp:int=joinTime(itemData["action_start"], itemData["action_end"]);
			//
			//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
			//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
			if ("2" == itemData["sort"] || "3" == itemData["sort"])
			{
				sprite["kai_qi3"].visible=false;
				//开启时间
				//if(now.time >= start.time &&
				//	now.time <= end.time)
				if (1 == time_cp)
				{
					//开启
					sprite["kai_qi1"].visible=false;
					sprite["kai_qi2"].visible=true;
						//StringUtils.setEnable(sprite);
						//}else if(now.time < start.time)
				}
				else if (0 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(1);
					sprite["kai_qi2"].visible=false;
						//StringUtils.setUnEnable(sprite);
						//}else if(now.time > end.time)
				}
				else if (2 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(2);
					sprite["kai_qi2"].visible=false;
						//StringUtils.setEnable(sprite);
				}
			}
			else
			{
				sprite["kai_qi1"].visible=false;
				var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
				var jLen:int=limitList.length;
				var limit_id:int=itemData["limit_id"];
				var find:Boolean=false;
				for (var j:int=0; j < jLen; j++)
				{
					if (limitList[j].limitid == limit_id)
					{
						if (limitList[j].curnum == limitList[j].maxnum)
						{
							sprite["kai_qi2"].visible=false;
							sprite["kai_qi3"].visible=true;
						}
						else
						{
							sprite["kai_qi2"].visible=true;
							sprite["kai_qi3"].visible=false;
						}
						find=true;
						sprite["txt_limit"].htmlText=limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						if (limit_id == 0)
						{
							sprite["txt_limit"].htmlText="无";
						}
						break;
					}
				} //end for
				if (!find)
				{
					sprite["kai_qi2"].visible=true;
					sprite["kai_qi3"].visible=false;
				}
			}
			//---------------------------------------------------------------
			//			sprite.removeEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
			//			sprite["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
			//			sprite["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByBossHuoDong2);
			mc_content.addChild(sprite);
		}

		public function itemClickByDayHuoDong2(e:MouseEvent):void
		{
						var sprite:*=e.target.parent;
			var action_jointype:String=sprite["data"]["action_jointype"];
			if ("0" == action_jointype)
			{
				//nothing
				//该活动到时间会自动参加，保持在线即可
				Lang.showMsg({type: 4, msg: Lang.getLabel("20048_HuoDongJoin")});
			}
			else if ("1" == action_jointype)
			{
				//寻路
				GameAutoPath.seek(sprite["data"]["action_para1"]);
			}
			else if ("2" == action_jointype)
			{
				//副本id
				var instance_id:int=sprite["data"]["action_para1"]
				FuBenDuiWu.groupid=instance_id;
				//instancesort:int;//副本类型(1单人，2多人)
				var instance_model:Pub_InstanceResModel=XmlManager.localres.getInstanceXml.getResPath(instance_id) as Pub_InstanceResModel;
				if (0 == instance_model.instancesort || 1 == instance_model.instancesort)
				{
					//单人副本快速进入
					//#Request:PacketCSSInstanceStart
					//#Respond:PacketSCSInstanceStart
					var client1:PacketCSSInstanceStart=new PacketCSSInstanceStart();
					client1.map_id=instance_id;
					this.uiSend(client1);
				}
				else
				{
					FuBenDuiWu.instance.open(true);
				}
			}
			else if ("3" == action_jointype)
			{
				MoTianWanJie.instance().open();
			}
			else if ("4" == action_jointype)
			{
				/*var cs:PacketCSMapSend = new PacketCSMapSend();
				cs.sendid = parseInt(sprite["data"]["action_para1"]);
				uiSend(cs);*/
				var cs:PacketCSOpenActTimeWaring=new PacketCSOpenActTimeWaring();
				cs.act_id=parseInt(sprite["data"]["action_id"]);
				cs.seek_id=parseInt(sprite["data"]["action_para1"]);
				cs.token=0;
				uiSend(cs);
			}
			else if ("5" == action_jointype)
			{
				var cs5:PacketCSEntryBossAction=new PacketCSEntryBossAction();
				cs5.action_id=parseInt(sprite["data"]["action_para1"]);
				uiSend(cs5);
			}
			else if ("6" == action_jointype)
			{
				//				ZhenYing.instance().requestCamp();
			}
			else if ("7" == action_jointype)
			{
				//CSEntryGuildBoss
				var cs7:PacketCSEntryGuildBoss=new PacketCSEntryGuildBoss();
				uiSend(cs7);
			}
			else if ("8" == action_jointype)
			{
				//var cs8:PacketCSAutoSend = new PacketCSAutoSend();
				//cs8.seekid = parseInt(sprite["data"]["action_para1"]);
				//uiSend(cs8);
				JiaZuModel.getInstance().requestEntryGuildHome(1);
			}
			else if ("9" == action_jointype)
			{
				JiaZuModel.getInstance().requestEntryGuildHome(2);
			}
			else if ("10" == action_jointype)
			{
				var cs10:PacketCSEntryGuildMelee=new PacketCSEntryGuildMelee();
				cs10.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs10);
			}
			else if ("11" == action_jointype)
			{
				//直接传送
				//var cs11:PacketCSAutoSend = new PacketCSAutoSend();
				//cs11.seekid=m["action_para1"];
				//DataKey.instance.send(cs11);
				JiaZuModel.getInstance().requestEntryGuildHome(3);
			}
			else if ("12" == action_jointype)
			{
				var cs12:PacketCSEntryCityAction=new PacketCSEntryCityAction();
				cs12.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs12);
			}
			else if ("13" == action_jointype)
			{
				var cs13:PacketCSEntryPKKinger=new PacketCSEntryPKKinger();
				cs13.action_id=parseInt(sprite["data"]["action_id"]);
				uiSend(cs13);
			}
			else if ("14" == action_jointype)
			{
				DiGongMap.instance().open(true);
			}
			else if ("50" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=20012;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("51" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=80005;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("52" == action_jointype)
			{
				//20012
				//★★★王志祥★★★ 18:04:15
				//狮王争霸
				HuoDongCommonEntry.GroupId=80004;
				HuoDongCommonEntry.getInstance().open(true);
			}
			else if ("60" == action_jointype)
			{
				//DuoMaoMaoBaoMing.instance.open(true);
			}
		}

		private function callbackByDuoRenHuoDong(itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTaskAndHuoDongItem(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			sprite["name"]="item" + (index + 1);
			//
			if (sprite.hasOwnProperty("bg"))
			{
				sprite["bg"].mouseEnabled=false;
			}
			//
			sprite["txt_action_name"].text=itemData["action_name"];
			sprite["txt_action_name"].mouseEnabled=false;
			sprite["txt_action_date"].text=itemData["action_date"];
			sprite["txt_action_date"].mouseEnabled=false;
			//sprite["txt_action_start"].text=itemData["action_start"];		
			//sprite["txt_action_end"].text=itemData["action_end"];		
//			sprite["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			sprite["uil"].mouseEnabled=false;
			sprite["kai_qi1"].visible=false;
			sprite["kai_qi2"].visible=false;
			sprite["kai_qi3"].visible=false;
			if (null != sprite["kai_qi4"])
				sprite["kai_qi4"].visible=false;
			//
			var now:Date=Data.date.nowDate;
			var action_start:String=itemData["action_start"];
			var action_end:String=itemData["action_end"];
			var action_start_spli:Array=action_start.split(":");
			var action_end_spli:Array=action_end.split(":");
			var action_start_hour:int=action_start_spli[0];
			var action_start_min:int=action_start_spli[1];
			var action_start_sec:int=action_start_spli[2];
			var action_end_hour:int=action_end_spli[0];
			var action_end_min:int=action_end_spli[1];
			var action_end_sec:int=action_end_spli[2];
			var start:Date=Data.date.nowDate;
			start.hours=action_start_hour;
			start.minutes=action_start_min;
			start.seconds=action_start_sec;
			var end:Date=Data.date.nowDate;
			end.hours=action_end_hour;
			end.minutes=action_end_min;
			end.seconds=action_end_sec;
			var myLvl:int=Data.myKing.level;
			var minLvl:int=parseInt(itemData["action_minlevel"]);
			var maxLvl:int=parseInt(itemData["action_maxlevel"]);
			if (myLvl >= minLvl && myLvl <= maxLvl)
			{
				sprite['txt_Condition'].htmlText="";
				StringUtils.setEnable(sprite);
			}
			else
			{
				sprite['txt_Condition'].htmlText=Lang.getLabel("40080_DayHuoDong_condition", [minLvl, maxLvl]);
				StringUtils.setUnEnable(sprite);
			}
			//
			//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
			//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
			if ("2" == itemData["sort"] || "3" == itemData["sort"])
			{
				sprite["kai_qi3"].visible=false;
				//开启时间
				if (now.time >= start.time && now.time <= end.time)
				{
					//开启
					sprite["kai_qi1"].visible=false;
					sprite["kai_qi2"].visible=true;
				}
				else if (now.time < start.time)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(1);
					sprite["kai_qi2"].visible=false;
				}
				else if (now.time > end.time)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(2);
					sprite["kai_qi2"].visible=false;
				}
			}
			else if ("41" == itemData["sort"])
			{
				//不限时间，次数的副本
				sprite["kai_qi3"].visible=false;
				//开启
				sprite["kai_qi1"].visible=false;
				sprite["kai_qi2"].visible=true;
			}
			else
			{
				sprite["kai_qi1"].visible=false;
				var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
				var jLen:int=limitList.length;
				var limit_id:int=itemData["limit_id"];
				var find:Boolean=false;
				for (var j:int=0; j < jLen; j++)
				{
					if (limitList[j].limitid == limit_id)
					{
						if (limitList[j].curnum == limitList[j].maxnum)
						{
							sprite["kai_qi2"].visible=false;
							sprite["kai_qi3"].visible=true;
						}
						else
						{
							sprite["kai_qi2"].visible=true;
							sprite["kai_qi3"].visible=false;
						}
						find=true;
						//mc["txt_limit"].htmlText =  limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						break;
					}
				} //end for
				if (!find)
				{
					sprite["kai_qi2"].visible=true;
					sprite["kai_qi3"].visible=false;
				}
			}
			//---------------------------------------------------------------
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByDuoRenHuoDong2);
			sprite["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByDuoRenHuoDong2);
			sprite["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByDuoRenHuoDong2);
			//----------------------------------------------------------------
			mc_content.addChild(sprite);
		}

		/**
		 *	每日活动
		 */
		private function callbackByDayHuoDong(_itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var itemData:Object = _itemData.enough;
			var sprite:*=ItemManager.instance().getHuoDongTaskAndHuoDongItem(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			sprite["name"]="item" + (index + 1);
			//
			if (sprite.hasOwnProperty("bg"))
			{
				sprite["bg"].mouseEnabled=false;
			}
			if (sprite.hasOwnProperty("back"))
			{
				sprite["back"].mouseEnabled=false;
			}
			sprite["txt_action_date"].mouseEnabled=false;
			sprite['txt_Condition'].mouseEnabled=false;
			sprite["txt_limit"].mouseEnabled=false;
			sprite["kai_qi1"].mouseEnabled=sprite["kai_qi1"].mouseChildren=false;
			sprite["kai_qi3"].mouseEnabled=sprite["kai_qi3"].mouseChildren=false;
			//
			//			sprite["txt_action_name"].text=itemData["action_name"];
			//			sprite["txt_action_name"].mouseEnabled=false;
			sprite["txt_action_date"].text=itemData["action_date"];
			sprite['txt_Condition'].htmlText=itemData["action_prize"];
			//sprite["txt_action_start"].text=itemData["action_start"];		
			//sprite["txt_action_end"].text=itemData["action_end"];		
//			sprite["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			sprite["uil"].mouseEnabled=sprite["uil"].mouseChildren=false;
			sprite["kai_qi1"].visible=false;
			sprite["kai_qi2"].visible=false;
			sprite["kai_qi3"].visible=false;
			if (null != sprite["kai_qi4"])
				sprite["kai_qi4"].visible=false;
			if (_itemData["ash"])
			{
				StringUtils.setEnable(sprite);
			}
			else
			{
				StringUtils.setUnEnable(sprite, true);
			}
			var time_cp:int=joinTime(itemData["action_start"], itemData["action_end"]);
			var myLvl:int=Data.myKing.level;
			//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
			//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
			var _curnum_:int=0;
			var _maxnum_:int=0;
			var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
			var jLen:int=limitList.length;
			var limit_id:int=itemData["limit_id"];
			var find:Boolean=false;
			var findLimit:StructLimitInfo2;
			for (var j:int=0; j < jLen; j++)
			{
				if (limitList[j].limitid == limit_id)
				{
					if (limitList[j].curnum == limitList[j].maxnum)
					{
						sprite["kai_qi2"].visible=false;
						sprite["kai_qi3"].visible=true;
					}
					else
					{
						sprite["kai_qi2"].visible=true;
						sprite["kai_qi3"].visible=false;
					}
					find=true;
					findLimit=limitList[j];
					_curnum_=limitList[j].curnum;
					_maxnum_=limitList[j].maxnum;
					sprite["txt_limit"].htmlText=limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
					if (limit_id == 0)
					{
						sprite["txt_limit"].htmlText="无";
					}
					break;
				}
			} //end for
			if ("2" == itemData["sort"] || "3" == itemData["sort"])
			{
				sprite["kai_qi3"].visible=false;
				//开启时间
				//if(now.time >= start.time &&
				//	now.time <= end.time)
				if (1 == time_cp)
				{
					//开启
					sprite["kai_qi1"].visible=false;
					sprite["kai_qi2"].visible=true;
					StringUtils.setEnable(sprite);
					if (myLvl < parseInt(itemData.action_minlevel))
					{
						sprite["kai_qi2"].visible=false;
						if (null != sprite["kai_qi4"])
						{
							sprite["kai_qi4"].visible=true;
							sprite["kai_qi4"].text=itemData.action_minlevel + Lang.getLabel("ji_ke_can_jia");
						}
					}
				}
				else if (0 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(1);
					sprite["kai_qi2"].visible=false;
					sprite["txt_action_date"].htmlText="<font color='#fff5d2'>" + itemData["action_date"] + "</font>";
					sprite['txt_Condition'].htmlText="<font color='#fff5d2'>" + itemData["action_prize"] + "</font>";
						//}else if(now.time > end.time)
				}
				else if (2 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(2);
					sprite["kai_qi2"].visible=false;
						//StringUtils.setEnable(sprite);
				}
			}
			else
			{
				sprite["kai_qi1"].visible=false;
				if (find)
				{
					if (findLimit.curnum == findLimit.maxnum)
					{
						sprite["kai_qi2"].visible=false;
						sprite["kai_qi3"].visible=true;
					}
					else
					{
						sprite["kai_qi2"].visible=true;
						sprite["kai_qi3"].visible=false;
					}
				}
				if (!find)
				{
					sprite["kai_qi2"].visible=true;
					sprite["kai_qi3"].visible=false;
				}
			}
			//
			sprite["txt_limit"].htmlText=_curnum_.toString() + "/" + _maxnum_.toString();
			if (limit_id == 0)
			{
				sprite["txt_limit"].htmlText="";
			}
			if (0 == time_cp)
			{
				sprite["txt_limit"].htmlText="<font color='#fff5d2'>" + _curnum_.toString() + "/" + _maxnum_.toString() + "</font>";
			}
			if (0 == time_cp && limit_id == 0)
			{
				sprite["txt_limit"].htmlText="<font color='#fff5d2'>" + "" + "</font>";
			}
			//---------------------------------------------------------------
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			sprite["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			sprite["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			//----------------------------------------------------------------
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
		}

		private function callbackByKuaFuHuoDong(itemData:Object, index:int, arr:Vector.<Object>):void
		{
			var sprite:*=ItemManager.instance().getHuoDongTaskAndHuoDongItem(itemData["action_id"]);
			super.itemEvent(sprite, itemData, true);
			sprite["name"]="item" + (index + 1);
			//
			if (sprite.hasOwnProperty("bg"))
			{
				sprite["bg"].mouseEnabled=false;
			}
			//
			//			sprite["txt_action_name"].text=itemData["action_name"];
			//			sprite["txt_action_name"].mouseEnabled=false;
			sprite["txt_action_date"].text=itemData["action_date"];
			sprite["txt_action_date"].mouseEnabled=false;
			//sprite["txt_action_start"].text=itemData["action_start"];		
			//sprite["txt_action_end"].text=itemData["action_end"];		
//			sprite["uil"].source=FileManager.instance.getActionDescIconById(itemData["res_id"]);
			ImageUtils.replaceImage(sprite,sprite['uil'],FileManager.instance.getActionDescIconById(itemData["res_id"]));
			sprite["uil"].mouseEnabled=false;
			sprite["kai_qi1"].visible=false;
			sprite["kai_qi2"].visible=false;
			sprite["kai_qi3"].visible=false;
			//
			StringUtils.setEnable(sprite);
			sprite['txt_Condition'].htmlText=itemData["action_prize"];
			//			if (itemData["ash"])
			//			{
			//				StringUtils.setUnEnable(sprite);
			//				sprite['txt_Condition'].htmlText=Lang.getLabel("40080_DayHuoDong_condition", [itemData.action_minlevel, itemData.action_maxlevel]);
			//			}
			var time_cp:int=joinTime(itemData["action_start"], itemData["action_end"]);
			//
			//时间段类活动(根据时间段判断,活动描述表的sort字段为2和3)
			//非时间做类活动(根据参与次数判断，活动描述表的sort字段为1和4)：
			if ("2" == itemData["sort"] || "3" == itemData["sort"])
			{
				sprite["kai_qi3"].visible=false;
				//开启时间
				//if(now.time >= start.time &&
				//	now.time <= end.time)
				if (1 == time_cp)
				{
					//开启
					sprite["kai_qi1"].visible=false;
					sprite["kai_qi2"].visible=true;
						//StringUtils.setEnable(sprite);
						//}else if(now.time < start.time)
				}
				else if (0 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(1);
					sprite["kai_qi2"].visible=false;
						//}else if(now.time > end.time)
				}
				else if (2 == time_cp)
				{
					sprite["kai_qi1"].visible=true;
					sprite["kai_qi1"].gotoAndStop(2);
					sprite["kai_qi2"].visible=false;
						//StringUtils.setEnable(sprite);
				}
			}
			else
			{
				sprite["kai_qi1"].visible=false;
				var limitList:Vector.<StructLimitInfo2>=Data.huoDong.getDayTaskAndDayHuoDongLimit();
				var jLen:int=limitList.length;
				var limit_id:int=itemData["limit_id"];
				var find:Boolean=false;
				for (var j:int=0; j < jLen; j++)
				{
					if (limitList[j].limitid == limit_id)
					{
						if (limitList[j].curnum == limitList[j].maxnum)
						{
							sprite["kai_qi2"].visible=false;
							sprite["kai_qi3"].visible=true;
						}
						else
						{
							sprite["kai_qi2"].visible=true;
							sprite["kai_qi3"].visible=false;
						}
						find=true;
						sprite["txt_limit"].htmlText=limitList[j].curnum.toString() + "/" + limitList[j].maxnum.toString();
						if (limit_id == 0)
						{
							sprite["txt_limit"].htmlText="无";
						}
						break;
					}
				} //end for
				if (!find)
				{
					sprite["kai_qi2"].visible=true;
					sprite["kai_qi3"].visible=false;
				}
			}
			//---------------------------------------------------------------
			sprite.removeEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			sprite["kai_qi2"].removeEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			sprite["kai_qi2"].addEventListener(MouseEvent.CLICK, itemClickByDayHuoDong2);
			//----------------------------------------------------------------
			mc_content.addChild(sprite);
			//悬浮信息
			//Lang.addTip(sprite,"hao_you_tip");
			//sprite.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, autoRefreshHandler);
			super.windowClose();
			if (null != HuoDongBridge.m_RewardOfAddMoney)
			{
				HuoDongBridge.m_RewardOfAddMoney(mc).stopTimer();
			}
			//HuoDongEventDispatcher.getInstance().checkReward();
		}

		override public function getID():int
		{
			return 1016;
		}
		//窗口第一次初始化的宽度和高度
		private var m_initW:int=-1;
		private var m_initH:int=-1;
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		private function replace():void
		{
			if (null == m_gPoint)
			{
				m_gPoint=new Point();
			}
			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}
			if (null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x=(mc.stage.stageWidth - m_initW) >> 1;
				m_gPoint.y=(mc.stage.stageHeight - m_initH) >> 1;
				m_lPoint=this.parent.globalToLocal(m_gPoint);
				mc.x=0;
				mc.y=0;
				this.x=m_lPoint.x;
				this.y=m_lPoint.y;
			}
		}

		public function actWeekOnline(p:PacketSCActWeekOnline2):void
		{
			//
			showWeekPrize();
		}

		public function showWeekPrize(e:DispatchEvent=null):void
		{
			if (12 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			mc["txt_user_serverday"].text=Data.huoDong.weekOnline.user_serverday.toString();
			mc["txt_onlineminute"].text=Data.huoDong.weekOnline.onlineminute.toString();
			mc["txt_last_rmb"].text=Data.huoDong.weekOnline.last_rmb.toString();
			mc["txt_last_coin"].text=Data.huoDong.weekOnline.last_coin.toString();
			mc["txt_cur_rmb"].text=Data.huoDong.weekOnline.cur_rmb.toString();
			mc["txt_cur_coin"].text=Data.huoDong.weekOnline.cur_coin.toString();
			mc["txt_unit_rmb_coin"].htmlText=Lang.getLabel("900001_HuoDongFuLi", [Data.huoDong.weekOnline.unit_rmb, Data.huoDong.weekOnline.unit_coin]);
		}
	}
}
