package ui.base.vip
{
	import common.config.GameIni;
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.net.process.PacketBaseProcess;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.huodong.HuoDong;
	import ui.base.npc.NpcShop;
	import ui.base.vip.Vip;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	
	
	/**
	 * 开服嘉年华-新
	 */ 
	public class KaiFuJiaNianHuaNew extends UIWindow 
	{
		public function get COL_MAX_BY_RESET():int
		{			
			return 3;
		}
		
		public function get COL_MAX():int
		{
			//if(4 == this.curPage)
//			{
//				return 1;
//			}
		
			return COL_MAX_BY_RESET;
		}
		
		public const maxPage:int = 3;//4;
		public const minPage:int = 1;
		
		public const AutoRefreshSecond:int = 3;
		private var curAutoRefresh:int=0;
				
		private static var _instance:KaiFuJiaNianHuaNew;
		
		public static function getInstance():KaiFuJiaNianHuaNew
		{
			if(null == _instance)
			{
				_instance=new KaiFuJiaNianHuaNew();
			}
			
			return _instance;
		}
		override public function open(must:Boolean=false, type:Boolean=true):void{
			//屏蔽，此功能不再开
		}
		public function KaiFuJiaNianHuaNew()
		{
			super(getLink(WindowName.win_kai_fu_jia_nian_hua_new));
		}		
		
		public function initCalc():void
		{
			todayIsDiJiTian = this.diJiTian();
			tomorrowIsDiJiTian = todayIsDiJiTian + 1;
		}
		
		
		override protected function init():void 
		{
			super.init();
			
			curPage = 1;
			
			initCalc();		
			
			if(todayIsDiJiTian > 3 && todayIsDiJiTian <= 6)
			{
				curPage = 2;
			}
			
			if(todayIsDiJiTian > 6 && todayIsDiJiTian <= 9)
			{
				curPage = 3;
			}
			
//			if(todayIsDiJiTian > 9)
//			{
//				curPage = 4;
//			}
				
			this.uiRegister(PacketSCGetServerStartFirstPrizeInfo.id,SCGetServerStartFirstPrizeInfo);
			this.uiRegister(PacketSCGetServerStartPrizeInfo.id,SCGetServerStartPrizeInfo);
			this.uiRegister(PacketSCSetServerStartFirstPrize.id,SCSetServerStartFirstPrize);
			
			this.uiRegister(PacketSCHaveServerStartPrizeInfo.id,SCHaveServerStartPrizeInfo);
			this.uiRegister(PacketSCSetServerStartPrize.id,SCSetServerStartPrize);
			
			
			
			mc["leftArrow"].buttonMode = true;
			mc["leftArrow"].mouseChildren = false;
			mc["leftArrow"].removeEventListener(MouseEvent.CLICK,leftArrowClick);
			mc["leftArrow"].addEventListener(MouseEvent.CLICK,leftArrowClick);
			
			mc["rightArrow"].buttonMode = true;
			mc["rightArrow"].mouseChildren = false;
			mc["rightArrow"].removeEventListener(MouseEvent.CLICK,rightArrowClick);
			mc["rightArrow"].addEventListener(MouseEvent.CLICK,rightArrowClick);
			
			
			//
			reset();
			
			//上面的信息
			var cs:PacketCSGetServerStartFirstPrizeInfo = new PacketCSGetServerStartFirstPrizeInfo();
			
			this.uiSend(cs);
			
			//下面的信息
			var cs2:PacketCSGetServerStartPrizeInfo = new PacketCSGetServerStartPrizeInfo();
			
			this.uiSend(cs2);
			
			//
			curAutoRefresh = 0;
			
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_TEN_SECOND,autoRefreshHandler);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_TEN_SECOND,autoRefreshHandler);
						
			//test
			/*
			var sm2:PacketSCGetServerStartPrizeInfo2 = new PacketSCGetServerStartPrizeInfo2();
			sm2.info = 1;
			DataKey.instance.receive(sm2);
			*/
			
			//test
			/*
			 *
			var sm:PacketSCGetServerStartFirstPrizeInfo2 = new PacketSCGetServerStartFirstPrizeInfo2();
			
			sm.arrItemserverstartinfolist = new Vector.<StructStartServerInfo2>();
			
			//
			var sm_1:StructStartServerInfo2 = new StructStartServerInfo2(); 
			
			sm_1.arrIteminfolist = new Vector.<StructStartServerNameInfo2>();
			sm_1.arrItemcurlist = new Vector.<StructStartServerNameInfo2>();
			
			var sm_1_2:StructStartServerNameInfo2 = new StructStartServerNameInfo2();
			sm_1_2.name = "xxx";
			
			sm_1.arrItemcurlist.push(sm_1_2);
			
			for(var j:int =0;j<10;j++)
			{
				sm.arrItemserverstartinfolist.push(sm_1);
			}
			DataKey.instance.receive(sm);
			*/
				
			//
			/* 
			var sm_1:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_1.state = 1;
			sm.arrItemserverstartinfolist.push(sm_1);
			
			var sm_2:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_2.state = 1;
			sm.arrItemserverstartinfolist.push(sm_2);
			
			var sm_3:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_3.state = 2;
			sm.arrItemserverstartinfolist.push(sm_3);
			
			var sm_4:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_4.state = 2;
			sm.arrItemserverstartinfolist.push(sm_4);
			
			var sm_5:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_5.state = 2;
			sm.arrItemserverstartinfolist.push(sm_5);
			
			var sm_6:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_6.state = 2;
			sm.arrItemserverstartinfolist.push(sm_6);
			
			var sm_7:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_7.state = 2;
			sm.arrItemserverstartinfolist.push(sm_7);
			
			var sm_8:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_8.state = 2;
			sm.arrItemserverstartinfolist.push(sm_8);
			
			var sm_9:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_9.state = 2;
			sm.arrItemserverstartinfolist.push(sm_9);
			
			var sm_10:StructStartServerInfo2 = new StructStartServerInfo2();
			sm_10.state = 2;
			sm.arrItemserverstartinfolist.push(sm_10);
			
			DataKey.instance.receive(sm);
			*/
			
			
			
			
		}
		
		private function autoRefreshHandler(e:WorldEvent):void
		{
			curAutoRefresh++;
				
			if(curAutoRefresh >=AutoRefreshSecond)
			{
				
				curAutoRefresh = 0;
				
				//重新计算第几天
				initCalc();
				
				//
				//this.reset();
				this.refresh();
					
			}
			
			
			
		}	
		
		public function get CurrentRealPage():int
		{
			if(1 == this.curPage)
			{
				return 0;
			}
			
			if(2 == this.curPage)
			{
				return 3;
			}
			
			if(3 == this.curPage)
			{
				return 6;
			}
			
			if(4 == this.curPage)
			{
				return 9;
			}
		
			return 0;
		}
		
		public function reset():void
		{
			for(var j:int=1;j<=COL_MAX_BY_RESET;j++)
			{
				//mc["col" + j.toString()].gotoAndStop(CurrentRealPage + j);
				mc["col" + j.toString()].visible = false;			
				
				//mc["col" + j.toString()]["txt_action_name"].text = "";				
				mc["col" + j.toString()]["mc_action_name"].visible = false;
			
				//特殊
				//mc["col" + j.toString()]["item1"].alpha = 0;
								
				//特效边框
				if(null != mc["col" + j.toString()]["mc_light"])
				{
					mc["col" + j.toString()]["mc_light"].stop();
					mc["col" + j.toString()]["mc_light"].visible = false;
					mc["col" + j.toString()]["mc_light"].mouseEnabled = false;
					mc["col" + j.toString()]["mc_light"].mouseChildren = false;
				}
				
				//mc["col" + j.toString()]["mc_linqu"].visible = false;
				
				mc["col" + j.toString()]["mc_day_end"].visible = false;
				mc["col" + j.toString()]["mc_day_end"].mouseEnabled = false;
				//
				//mc["col" + j.toString()]["btnQmjl1"].visible = false;
				//mc["col" + j.toString()]["btnQmjl1"]["txt_qmjl"].text = "";
				
				//mc["col" + j.toString()]["btnQmjl2"].visible = false;
				//mc["col" + j.toString()]["btnQmjl3"].visible = false;
				
				mc["col" + j.toString()]["txt_tiao_jian"].text = "";
				(mc["col" + j.toString()]["txt_tiao_jian"] as TextField).mouseEnabled = false;
				
			}
			
			
			
			
		}
		
		public function refresh():void
		{
			reset();
			
			//左右箭头
			if(this.minPage == this.curPage)
			{
				mc["leftArrow"].gotoAndStop(2);
				mc["rightArrow"].gotoAndStop(1);
			}
			
			if(this.maxPage == this.curPage)
			{
				mc["leftArrow"].gotoAndStop(1);
				mc["rightArrow"].gotoAndStop(2);
			}
			
			for(var j:int=1;j<=COL_MAX;j++)
			{
				mc["col" + j.toString()].visible = true;
				//mc["col" + j.toString()].gotoAndStop(CurrentRealPage + j);
				
				//不受today, tomorrow影响
				var bag:StructBagCell2=new StructBagCell2();
				
				//职业 1 天斗 2 玄道 3 仙羽
				if(1 == Data.myKing.metier)
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_1"];
					
					
				}else if(2 == Data.myKing.metier)
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_2"];
					
				}else if(3 == Data.myKing.metier)
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_3"];
					
				}else if(4 == Data.myKing.metier)
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_4"];
					
				}
				else if(5 == Data.myKing.metier)
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_5"];
					
				}else
				{
					bag.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["item_6"];
				}
				
				
				Data.beiBao.fillCahceData(bag);
//				mc["col" + j.toString()]["item1"]["uil"].source=bag.iconBig;//icon;
				ImageUtils.replaceImage(mc["col" + j.toString()]["item1"],mc["col" + j.toString()]["item1"]["uil"],bag.iconBig);
				mc["col" + j.toString()]["item1"].data=bag;
				CtrlFactory.getUIShow().addTip(mc["col" + j.toString()]["item1"]);
				//强制修改数据，紫色弄得像橙色
				bag.toolColor = 5;
				
				//强制把装备前缀 仙品-神品
				bag.itemname=bag.itemname.replace(XmlRes.getEquipColorFont(4),XmlRes.getEquipColorFont(5));
				
				//
				if(1 == Data.myKing.metier)
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_1"];
					
					
				}else if(2 == Data.myKing.metier)
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_2"];
					
				}else if(3 == Data.myKing.metier)
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_3"];
					
				}else if(4 == Data.myKing.metier)
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_4"];
					
				}
				else if(5 == Data.myKing.metier)
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_5"];
					
				}else
				{
					bag.effect =XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["colour_lv_6"];
				}
//				
				ItemManager.instance().setToolTipByData(mc["col" + j.toString()]["item1"],bag,1);
				
				//
				//var bag_qmjl:StructBagCell2 = new StructBagCell2();				
				//bag_qmjl.itemid=XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).item_all;
				//Data.beiBao.fillCahceData(bag_qmjl);
				
				//mc["col" + j.toString()]["item2"]["uil"].source=bag_qmjl.icon;
				//mc["col" + j.toString()]["item2"].data=bag_qmjl;
				//CtrlFactory.getUIShow().addTip(mc["col" + j.toString()]["item2"]);
				
				
				if(isToday(CurrentRealPage + j))
				{
					mc["col" + j.toString()]["mc_light"].visible = true;					
					mc["col" + j.toString()]["mc_light"].play();
					
					mc["col" + j.toString()]["mc_light"].mouseEnabled = false;
					mc["col" + j.toString()]["mc_light"].mouseChildren = false;
					
				}else
				{
					mc["col" + j.toString()]["mc_light"].visible = false;
					mc["col" + j.toString()]["mc_light"].stop();
					
					mc["col" + j.toString()]["mc_light"].mouseEnabled = false;
					mc["col" + j.toString()]["mc_light"].mouseChildren = false;
					
				}
				
				//
				mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(1);
				if(isYesterdayOrBefore(CurrentRealPage + j))
				{
					mc["col" + j.toString()]["mc_day_end"].visible = true;
				}
				
				//
				//
				if(isTodayOrTomorrow(CurrentRealPage + j) ||
					isYesterdayOrBefore(CurrentRealPage + j)
				)
				{
					//
					mc["col" + j.toString()]["txt_tiao_jian"].htmlText = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j)["action_name_desc"];
					
					mc["col" + j.toString()]["mc_open"].visible = false;
					
				}else
				{
					//
					mc["col" + j.toString()]["txt_tiao_jian"].text = "";
					
					mc["col" + j.toString()]["mc_open"].visible = true;
				}
				
				//
				if(isTodayOrTomorrow(CurrentRealPage + j) ||
					isYesterdayOrBefore(CurrentRealPage + j)
				)
				{
					//mc["col" + j.toString()]["txt_action_name"].text = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).action_name;
					
					
					mc["col" + j.toString()]["mc_action_name"].visible = true;
					mc["col" + j.toString()]["mc_action_name"].gotoAndStop(
						
						(CurrentRealPage + j)
						//parseInt(XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).action_name)
					
					);
						
					//
					if(null != SSFPI)
					{
						var state:int = SSFPI.arrItemserverstartinfolist[CurrentRealPage + j - 1].state;
						
						if(0 == state)
						{
							mc["col" + j.toString()]["mc_linqu"].gotoAndStop(2);
							
						}else if(1 == state)
						{
							mc["col" + j.toString()]["mc_linqu"].gotoAndStop(3);
							
							if(null != mc["col" + j.toString()]["mc_linqu"]["mc_linqu_now_effect"]){
								//mc["col" + j.toString()]["mc_linqu"]["mc_linqu_now_effect"].mouseEnabled = false;
							}
								
						
						}else if(2 == state)
						{
							mc["col" + j.toString()]["mc_linqu"].gotoAndStop(4);
						
						}
						
						
						var peopleList:Vector.<StructStartServerNameInfo2> = SSFPI.arrItemserverstartinfolist[CurrentRealPage + j - 1].arrIteminfolist;
						
						if(peopleList.length == 0)
						{
							if(isToday(CurrentRealPage + j))
							{
								mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
								
								//mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(3);
								
								var paiHangList:Vector.<StructStartServerNameInfo2> = SSFPI.arrItemserverstartinfolist[CurrentRealPage + j - 1].arrItemcurlist;
								
								var isFirst:Boolean = false;
								
								if(j == 1 && this.curPage == 1)
								{
									isFirst = true;
								}
								
								if(paiHangList.length == 0)
								{
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(4);
									
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(1);
									
									
									//
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = "";
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = "";
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = "";
									
									
									
								}else if(paiHangList.length == 1 && !isFirst)
								{				
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(3);
									
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									//
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = "";
									
								}
								else if(paiHangList.length == 1 && isFirst)
								{
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(5);
									
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang2"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang3"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang4"].text = "";
									
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people4"].text = "";
									
								}								
								else if(paiHangList.length == 2 && !isFirst)
								{
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(3);
									
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang2"].text = XmlRes.GetJobNameById(paiHangList[1].metier) + "：";
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = paiHangList[1].name;
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang3"].text = "";
									
									
								}
								else if(paiHangList.length == 2 && isFirst)
								{
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(5);
									
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang2"].text = XmlRes.GetJobNameById(paiHangList[1].metier) + "：";
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = paiHangList[1].name;
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang3"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang4"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = "";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people4"].text = "";
									
								}								
								else if(paiHangList.length >= 3 && !isFirst)
								{
									
									
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(3);
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									//mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang2"].text = XmlRes.GetJobNameById(paiHangList[1].metier) + "：";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang3"].text = Lang.getLabel("pub_di_san_m") + "：";
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = paiHangList[1].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = paiHangList[2].name;
									
								}else if(paiHangList.length >= 3 && isFirst)
								{
									mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(5);
									mc["col" + j.toString()]["mc_huo_jiang_people_title"].gotoAndStop(2);
									
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang1"].text = XmlRes.GetJobNameById(paiHangList[0].metier) + "：";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang2"].text = XmlRes.GetJobNameById(paiHangList[1].metier) + "：";
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang3"].text = XmlRes.GetJobNameById(paiHangList[2].metier) + "：";
									
									if(paiHangList.length == 4){
										mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang4"].text = XmlRes.GetJobNameById(paiHangList[3].metier) + "：";
									}else
									{
										mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang4"].text = '';
									}
									
									//
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people1"].text = paiHangList[0].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people2"].text = paiHangList[1].name;
									mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people3"].text = paiHangList[2].name;
									
									if(paiHangList.length == 4){
										mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people4"].text = paiHangList[3].name;
									}else
									{
										mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_pai_hang_people4"].text = '';
									}
								
								}
							
							}else
							{							
								mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(1);
							}
						
						}else
						{
							mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(2);
							
							var isFirst:Boolean = false;
							
							if(j == 1 && this.curPage == 1)
							{
								isFirst = true;
							}
							
							if(peopleList.length == 0)
							{
								
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job1"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job2"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job4"].text = "";
								
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people1"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people2"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people4"].text = "";
								
							
							}else if(peopleList.length == 1)
							{								
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job1"].text = XmlRes.GetJobNameById(peopleList[0].metier) + "：";
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people1"].text = peopleList[0].name;
								
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job2"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job4"].text = "";
								
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people2"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people4"].text = "";
								
							}else if(peopleList.length == 2)
							{
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job1"].text = XmlRes.GetJobNameById(peopleList[0].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job2"].text = XmlRes.GetJobNameById(peopleList[1].metier) + "：";
							
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people1"].text = peopleList[0].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people2"].text = peopleList[1].name;
								
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job4"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people3"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people4"].text = "";
								
							}else if(peopleList.length == 3)
							{
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job1"].text = XmlRes.GetJobNameById(peopleList[0].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job2"].text = XmlRes.GetJobNameById(peopleList[1].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job3"].text = XmlRes.GetJobNameById(peopleList[2].metier) + "：";
							
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people1"].text = peopleList[0].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people2"].text = peopleList[1].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people3"].text = peopleList[2].name;
								
								
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job4"].text = "";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people4"].text = "";
							}							
							else if(peopleList.length == 4)
							{
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job1"].text = XmlRes.GetJobNameById(peopleList[0].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job2"].text = XmlRes.GetJobNameById(peopleList[1].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job3"].text = XmlRes.GetJobNameById(peopleList[2].metier) + "：";
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_job4"].text = XmlRes.GetJobNameById(peopleList[3].metier) + "：";
								
								//
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people1"].text = peopleList[0].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people2"].text = peopleList[1].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people3"].text = peopleList[2].name;
								mc["col" + j.toString()]["mc_huo_jiang_people"]["txt_huo_jiang_people4"].text = peopleList[3].name;
								
							}
							
						}
							
						
					}
					
					//
					if(null != SSPI)
					{
						//CurrentRealPage + j - 1
						var infoArr:Array = SSPI.infoArr;
						
						var AN:int = getTwoWei(CurrentRealPage + j);
						
						var A1:String = infoArr[AN - 1];
						var A2:String = infoArr[AN];
						var A3:String = A2 + A1;
						
						//00 未完成  01 可领取 10 领取过 
						if(A3 == "00")
						{
							//mc["col" + j.toString()]["btnQmjl1"].visible = true;
							//mc["col" + j.toString()]["btnQmjl1"]["txt_qmjl"].text = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).condition1;
							
							//
							//mc["col" + j.toString()]["btnQmjl2"].visible = false;
							//mc["col" + j.toString()]["btnQmjl3"].visible = false;
						
						}else if(A3 == "01" &&
						
							todayIsDiJiTian > (CurrentRealPage + j)
							
						)
						{
							//mc["col" + j.toString()]["btnQmjl1"].visible = false;
							
							//
							//mc["col" + j.toString()]["btnQmjl2"].visible = true;
							//mc["col" + j.toString()]["btnQmjl3"].visible = false;
						
						}else if(A3 == "10")
						{
							//mc["col" + j.toString()]["btnQmjl1"].visible = false;
							
							//
							//mc["col" + j.toString()]["btnQmjl2"].visible = false;
							//mc["col" + j.toString()]["btnQmjl3"].visible = true;
						
						}else
						{
							//mc["col" + j.toString()]["btnQmjl1"].visible = true;
							//mc["col" + j.toString()]["btnQmjl1"]["txt_qmjl"].text = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).condition1;
							
							//
							//mc["col" + j.toString()]["btnQmjl2"].visible = false;
							//mc["col" + j.toString()]["btnQmjl3"].visible = false;
						}
						
						
						
					
					}
					
					
					
					
					
					
					
					
					
					
					
					
				}
				else
				{
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					
					//
					//mc["col" + j.toString()]["txt_action_name"].text = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).action_default_name;
									
					mc["col" + j.toString()]["mc_action_name"].visible = true;
					mc["col" + j.toString()]["mc_action_name"].gotoAndStop(
						
						(CurrentRealPage + j)
						//parseInt(XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).action_name)
						
					);
					
					//灰色活动详情
					mc["col" + j.toString()]["mc_linqu"].gotoAndStop(1);
					
					//
					mc["col" + j.toString()]["mc_huo_jiang_people"].gotoAndStop(1);
					
					if(null != SSPI)
					{
						
						//mc["col" + j.toString()]["btnQmjl1"].visible = true;
						//mc["col" + j.toString()]["btnQmjl1"]["txt_qmjl"].text = XmlManager.localres.JnhXml.getResPath(CurrentRealPage + j).condition2;
						//
						//mc["col" + j.toString()]["btnQmjl2"].visible = false;
						//mc["col" + j.toString()]["btnQmjl3"].visible = false;
						
					}
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					//-----------------------------------------------------------------------------------------------------------------
					
				}
				
				
			
			
			}	
			
			
			
			
			
			
			
		}
		
		public function getTwoWei(n:int):int
		{
			return n*2 - 1;
		
		
		}
		
		public function leftArrowClick(e:MouseEvent):void
		{
			//this.curPage = 1;
			this.curPage--;
			
			if(this.curPage < this.minPage)
			{
				this.curPage = this.minPage;
			}
			
			//reset();
			this.refresh();
		}
		
		public function rightArrowClick(e:MouseEvent):void
		{
			//this.curPage = 2;
			this.curPage++;
			
			if(this.curPage > this.maxPage)
			{
				this.curPage = this.maxPage;
			}
			
			//reset();
			this.refresh();
		
		}
		
		/**
		 * 获得开服嘉年华奖励第一信息返回
		 */ 
		public var SSFPI:PacketSCGetServerStartFirstPrizeInfo2;
		public function SCGetServerStartFirstPrizeInfo(p:PacketSCGetServerStartFirstPrizeInfo2):void
		{
			SSFPI = p;
			//reset();
			this.refresh();
		}
		
		/**
		 * 获得开服嘉年华参与奖励
		 */ 
		public function SCSetServerStartPrize(p:PacketSCSetServerStartPrize2):void
		{
			if(0 != p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(p.tag));
				return ;
			}
			
			var cs:PacketCSGetServerStartFirstPrizeInfo = new PacketCSGetServerStartFirstPrizeInfo();
			
			this.uiSend(cs);
			
			var cs2:PacketCSGetServerStartPrizeInfo = new PacketCSGetServerStartPrizeInfo();
			
			this.uiSend(cs2);
		}
		
		
		/**
		 * 获得开服嘉年华奖励参与信息返回
		 */ 
		public var SSPI:PacketSCGetServerStartPrizeInfo2;
		public function SCGetServerStartPrizeInfo(p:PacketSCGetServerStartPrizeInfo2):void
		{
			SSPI = p;
			//reset();
			this.refresh();
		}
		
		public function SCSetServerStartFirstPrize(p:PacketSCSetServerStartFirstPrize2):void
		{
			if(0 != p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(p.tag));
				return ;
			}
			var cs:PacketCSGetServerStartFirstPrizeInfo = new PacketCSGetServerStartFirstPrizeInfo();
			
			this.uiSend(cs);
			//reset();
			this.refresh();
		
		}
		
		/**
		 * 获得是否有领取奖励信息
		 */ 
		public function SCHaveServerStartPrizeInfo(p:PacketSCHaveServerStartPrizeInfo2):void
		{
			
		}
		
		public function isToday(n:int):Boolean
		{
			//test
			//return true;
			
			if(todayIsDiJiTian == n)
			{
				return true;
			}
		
			return false;
		}
		
		public function isYesterdayOrBefore(n:int):Boolean
		{
			if(todayIsDiJiTian > n)
			{
				return true;
			}
		
			return false;
		}
		
		public function isTodayOrTomorrow(n:int):Boolean
		{
			if(todayIsDiJiTian == n)
			{
				return true;
			}
			
			if(tomorrowIsDiJiTian == n)
			{
				return true;
			}
			
			return false;
		}
				
		public var todayIsDiJiTian:int = 1; 
		public var tomorrowIsDiJiTian:int = 2;
		public function diJiTian():int
		{
			//test
			//return 10;
			
			//
			var oldDateStr:String = GameIni.starServerTime();			
			var oldDate:Date = StringUtils.changeStringTimeToDate(oldDateStr);			
			
			//
			var nowDate:Date = Data.date.nowDate;						
			nowDate.hours = 0;
			nowDate.minutes = 0;
			nowDate.seconds = 0;
			nowDate.milliseconds = 0;
					
			
			var days:Number = (nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			
			/*MsgPrint.printTrace("oldDate:" + oldDateStr + 
				" nowDate" + nowDate.toString() + 
				" days:" + days.toString(),MsgPrintType.WINDOW_REFRESH);*/
						
			return days + 1;
		
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
						
			//有任何点击都将重置倒计时
			curAutoRefresh = 0;
			
			//
			var target_name:String = target.name;
			
			var pn:String;
			
			if(target_name == "mc_linqu")
			{
				if(target.currentFrame == 3)
				{
					target_name = "mc_linqu_now";
				}
			}
			
			switch (target_name)
			{
								
				case "mc_linqu_more":
										
					pn = target.parent.parent.name;
					
					var col_day:int =  int(pn.replace("col",""));
					
					var day:int =CurrentRealPage + col_day;
					
					//				0       充值返利              40001
					//				1   Q币大放送            40004
					//				2       充值送魔纹          40002
					//				3       充VIP送大礼       40003		
					//				4       首充大礼               10001
					//				5       新手礼包               20001
					//				6	冲级狂人	     30001
					//				7	PK第一人	     30002	
					//				8	魔纹狂人	     30009
					//				9	炼骨第一人	 30004
					//				10	富甲天下	     30005
					//				11	境界至尊	     30006
					//				12	最耀星魂	     30003					
					//				13	重铸天神	     30008
					//				14	神兵天将	     30007
					//				15	战神降临	     30010
					//				16	圣诞活动	     40005
					
					if(1 == day)
					{
						//冲级狂人
						//HuoDongFuLi.instance().setType(5,true,6);
						
					
					}else if(2 == day)
					{
						//PK第一人
						//HuoDongFuLi.instance().setType(5,true,7);
						
					}else if(3 == day)
					{
						//魔纹狂人
						//HuoDongFuLi.instance().setType(5,true,8);
						
					}else if(4 == day)
					{
						//炼骨第一人
						//HuoDongFuLi.instance().setType(5,true,9);
						
					}else if(5 == day)
					{
						//富甲天下
						//HuoDongFuLi.instance().setType(5,true,10);
						
					}else if(6 == day)
					{
						//境界至尊
						//HuoDongFuLi.instance().setType(5,true,11);
						
					}else if(7 == day)
					{
						//最耀星魂
						//HuoDongFuLi.instance().setType(5,true,12);
						
					}else if(8 == day)
					{
						//重铸天神
						//HuoDongFuLi.instance().setType(5,true,13);
						
					}else if(9 == day)
					{
						//神兵天将
						//HuoDongFuLi.instance().setType(5,true,14);
						
					}else if(10 == day)
					{
						//战神降临
						//HuoDongFuLi.instance().setType(5,true,15);
						
					}					
					
					
					break;
				
				case "mc_linqu_now":
				case "mc_linqu_now_effect":
					var cs:PacketCSSetServerStartFirstPrize = new PacketCSSetServerStartFirstPrize();
					
					pn = target.parent.name;
					
					var col_day1:int;
					
					//
					if(pn.indexOf("col") >= 0)
					{
						col_day1 =  int(pn.replace("col",""));
						
						cs.day =CurrentRealPage + col_day1;
						this.uiSend(cs);
					}
					else{
					pn = target.parent.parent.name;
					
					col_day1 =  int(pn.replace("col",""));
					
					cs.day =CurrentRealPage + col_day1;
					this.uiSend(cs);
					
					}
					break;
				
				case "btnQmjl2":
//					var cs_qmjl:PacketCSSetServerStartPrize = new PacketCSSetServerStartPrize();
//					var pn_qmjl:String = target.parent.name;
//					
//					var col_day2:int = int(pn_qmjl.replace("col",""));
//					
//					cs_qmjl.day =CurrentRealPage + col_day2;
//					this.uiSend(cs_qmjl);
					break;
			
				default:
					break;
			}
		
		}
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_TEN_SECOND,autoRefreshHandler);
			
			mc["leftArrow"].removeEventListener(MouseEvent.CLICK,leftArrowClick);
			
			mc["rightArrow"].removeEventListener(MouseEvent.CLICK,rightArrowClick);
			
			super.windowClose();
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}