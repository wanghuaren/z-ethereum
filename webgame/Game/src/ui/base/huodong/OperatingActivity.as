package ui.base.huodong
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Manage_ActionResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSGetGift;
	import nets.packets.PacketCSLevelQQGift;
	import nets.packets.PacketCSLevelQQGiftToRmb;
	import nets.packets.PacketCSRankAwardRequire;
	import nets.packets.PacketCSRankTopAward;
	import nets.packets.PacketSCGetGift;
	import nets.packets.PacketSCLevelQQGift;
	import nets.packets.PacketSCLevelQQGiftToRmb;
	import nets.packets.PacketSCRankAwardRequire;
	import nets.packets.PacketSCRankTopAward;
	
	import ui.base.paihang.PaiHang;
	import ui.base.vip.DuiHuan;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.view.view1.ExchangeCDKey;
	import ui.view.view6.GameAlert;
	
	import world.FileManager;

	/**
	 * 运营活动中的 "运营活动" , 需要活动主窗口传进来UI
	 * @author steven guo
	 *
	 */
	public class OperatingActivity
	{
		private static var m_instance:OperatingActivity;

		private static const MAX_SCROLLPANEL_NUM:int=17;

		private var m_ui:MovieClip=null;
		
		public function get is_m_ui_null():Boolean
		{
			if(null == m_ui)
			{
				return true;
			}
			
			return false;
		}

		/**
		 * 缓存滚动条item对象
		 */
		private var m_mapOAScrollPanelItem:HashMap;

		/**
		 * 滚动条内容面板
		 */
		private var mc_scrollPanel:Sprite;

		private var m_scrollList:Array;

		//默认的OperatingActivity索引
		private var m_defaultOAIndex:int=0;

		public function OperatingActivity()
		{
			m_mapOAScrollPanelItem=new HashMap();

			DataKey.instance.register(PacketSCRankTopAward.id, _responseRankTopAward);

			DataKey.instance.register(PacketSCRankAwardRequire.id, _responseRankTopAwardByType);

		}


		public static function getInstance():OperatingActivity
		{
			if (null == m_instance)
			{
				m_instance=new OperatingActivity();
			}

			return m_instance;
		}

		public function setDefaultOAIndex(index:int):void
		{
			m_defaultOAIndex=index;
		}

		public function setUI(ui:Sprite):void
		{
			m_ui=ui as MovieClip;

			m_ui.addFrameScript(5, _onFrameScriptListener);

			_initCom();
		}

		public function _onFrameScriptListener():void
		{
			//_countKaiFu();
			//_selected(m_defaultOAIndex);
			_countKaiFu();
			_selected(m_defaultOAIndex);
		}
		
		private var _starServerTime:String = null;
		private var _starServerTimeDate:Date;
		private var _starServerTimeDateString:String
		private var _30Day:Date;
		private var _30DayString:String;
		private var _31Day:Date;
		private var _28Day:Date;
		private var _28DayString:String;
		
		
		
		//计算开服时间相关
		private function _countKaiFu():void
		{
			//开服时间
			
			if(_starServerTime == null)
			{
				_starServerTime = GameIni.starServerTime();
			}
			
			if(null == _starServerTimeDate)
			{
				_starServerTimeDate = StringUtils.changeStringTimeToDate(_starServerTime);
			}
			
			//开服之后21天时间
			_30Day = StringUtils.addDay(_starServerTimeDate,21);
			
			//开服之后22天时间
			_31Day = StringUtils.addDay(_starServerTimeDate,22);
			
			//开服之后19天时间
			_28Day = StringUtils.addDay(_starServerTimeDate,19);
			 
			 
			
			//计算是否在领取奖励的时间之内
			var _today:Date = Data.date.nowDate;
			var _todayTime:Number = _today.getTime();
			
			if(_todayTime >= _28Day.getTime() && _todayTime < _31Day.getTime())
			{
				this.m_isInGet = true;
				
			}
			else
			{
				this.m_isInGet = false;
			}
			
			if(_todayTime >= _starServerTimeDate.getTime() && _todayTime < _31Day.getTime())
			{
				m_isInKaiFuHuoDong = true;
			}
			else
			{
				m_isInKaiFuHuoDong = false;
			}
		}

		/**
		 * 初始化组件
		 *
		 */
		private function _initCom():void
		{
			DataKey.instance.register(PacketSCLevelQQGift.id,_responePacketSCLevelQQGift);    
			DataKey.instance.register(PacketSCLevelQQGiftToRmb.id,_responePacketSCLevelQQGiftToRmb);       
			
			
			
			if (null == mc_scrollPanel)
			{
				mc_scrollPanel=new Sprite();
			}
			else
			{
				_clearMcContent(mc_scrollPanel);
			}
			//获得pub_manage_action表格数据
			var _Pub_Manage_ActionXml:TablesLib=XmlManager.localres.getManageActionXml;

			m_scrollList=[];


			for (var i:int=0; i < MAX_SCROLLPANEL_NUM; ++i)
			{
				m_scrollList[i]=_getOperatingActivityScrollPanelItem(i);

//				0       充值返利              40001
//				1   Q币大放送            40004
//				2       充值送魔纹          40002
//				3       充VIP送大礼       40003		
//				4       首充大礼               10001
//				5       新手礼包               20001
//				6	冲级狂人	     30001
//				7	PK第一人	     30002
//				8	最耀星魂	     30003
//				9	炼骨第一人	 30004
//				10	富甲天下	     30005
//				11	境界至尊	     30006
//				12	神兵天将	     30007
//				13	重铸天神	     30008
//				14	魔纹狂人	     30009
//				15	战神降临	     30010
//				16	圣诞活动	     40005

				switch (i)
				{
					case 0: //充值返利              40001
						m_scrollList[i].setActivityID(40001);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(40001));
						break;
					case 1: //Q币大放送            40004
						m_scrollList[i].setActivityID(40004);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(40004));
						break;
					case 2: //充值送魔纹          40002
						m_scrollList[i].setActivityID(40002);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(40002));
						break;
					case 3: //充VIP送大礼       40003		
						m_scrollList[i].setActivityID(40003);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(40003));
						break;
					case 4: // 首充大礼               10001
						m_scrollList[i].setActivityID(10001);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(10001));
						break;
					case 5: //新手礼包                 20001
						m_scrollList[i].setActivityID(20001);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(20001));
						break;
					case 6:
						//冲级狂人	     30001
						m_scrollList[i].setActivityID(30001);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30001));
						break;
					case 7: //PK第一人	     30002
						m_scrollList[i].setActivityID(30002);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30002));
						break;
					case 8: //最耀星魂	     30003
						m_scrollList[i].setActivityID(30003);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30003));
						break;
					case 9: //炼骨第一人	     30004
						m_scrollList[i].setActivityID(30004);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30004));
						break;
					case 10: //富甲天下	     30005
						m_scrollList[i].setActivityID(30005);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30005));
						break;
					case 11: //境界至尊	     30006
						m_scrollList[i].setActivityID(30006);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30006));
						break;
					case 12: //神兵天将	     30007
						m_scrollList[i].setActivityID(30007);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30007));
						break;
					case 13: //重铸天神	     30008
						m_scrollList[i].setActivityID(30008);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30008));
						break;
					case 14: //魔纹狂人	     30009
						m_scrollList[i].setActivityID(30009);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30009));
						break;
					case 15: //战神降临	     30010
						m_scrollList[i].setActivityID(30010);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(30010));
						break;
					case 16: //圣诞活动，彩蛋	     40005
						m_scrollList[i].setActivityID(40005);
						m_scrollList[i].setData(_Pub_Manage_ActionXml.getResPath(40005));  
						break;
					default:
						break;
				}



				mc_scrollPanel.addChild(m_scrollList[i]);
			}

			//进行布局
			CtrlFactory.getUIShow().showList2(mc_scrollPanel, 1, 152, 76);

			m_ui["f6_sp6"].source=mc_scrollPanel;

			_selected(m_defaultOAIndex);
		}

		public function repaint():void
		{
			_selected(m_defaultOAIndex);

		}

		/**
		 * 处理鼠标点击事件
		 * @param target
		 *
		 */
		public function mcHandler(target:Object):void
		{
			var _item:OperatingActivityScrollPanelItem=null;

			_item=target as OperatingActivityScrollPanelItem;


			if (null != _item)
			{
				_selected(_item.getID());
			}
			else
			{
				switch (m_currentSelected)
				{
					case 4: //首充大礼   
						if (target.name.indexOf("btn_chong_zhi") >= 0)
						{
							//充值
							Vip.getInstance().pay();
						}
						else if (target.name.indexOf("btn_ling_jiang") >= 0)
						{
							//领奖
							VipGift.getInstance().requestGetGift(1, _giftReturnCallback);

						}
						break;
					case 1: //QQ
						break;
					case 2: //充VIP送大礼
					
					case 0: //充值返利
						if (target.name.indexOf("btn_chong_zhi") >= 0)
						{
							//充值
							Vip.getInstance().pay();
						}
						break;
					case 5: //新手礼包
						if (target.name.indexOf("btn_ling_jiang") >= 0)
						{
							//开启 cdk 兑换窗口
							ExchangeCDKey.instance.open(true);
						}

						break;
					case 2: //星魂排名赛
						if (target.name.indexOf("btn_kan_bang") >= 0)
						{
							PaiHang.getInstance().open(true);
						}
						else if (target.name.indexOf("btn_ling_jiang") >= 0)
						{
							_requestRankTopAward(1);
						}
						break;
					case 3: // 伙伴排名赛
//						if (target.name.indexOf("btn_kan_bang") >= 0)
//						{
//							PaiHang.getInstance().setDefaultFocus(2);
//							PaiHang.getInstance().open(true);
//						}
						if (target.name.indexOf("btn_chong_zhi") >= 0)
						{
							Vip.getInstance().pay();
						}
						else if (target.name.indexOf("btn_ling_jiang") >= 0)
						{
//							_requestRankTopAward(1);


//							var _p:PacketCSGetGift=new PacketCSGetGift();
//							_p.extend=0;
//							_p.viplevel=1;
//							DataKey.instance.send(_p);

							VipGift.getInstance().requestGetGift(1, _giftReturnCallback);
						}
						break;
//					case 4: // 战力排名赛
//						if (target.name.indexOf("btn_kan_bang") >= 0)
//						{
//							PaiHang.getInstance().setDefaultFocus(1);
//							PaiHang.getInstance().open(true);
//						}
//						else if (target.name.indexOf("btn_ling_jiang") >= 0)
//						{
////							_requestRankTopAward(1);
//							ExchangeCDKey.instance.open();
//						}
//						break;
					default:
						break;
				}
			}
		}

		private var m_currentSelected:int=0;

		private function _selected(id:int):void
		{

			if (id < 0 || id >= MAX_SCROLLPANEL_NUM)
			{
				return;
			}
			
			if(16 == id && !Data.huoDong.isAtOpenActIds(40005))
			{
				return ;
			}

			for (var i:int=0; i < MAX_SCROLLPANEL_NUM; ++i)
			{
				if (i == id)
				{
					m_scrollList[i].focus();
				}
				else
				{
					m_scrollList[i].unFocus();
				}

				m_scrollList[i].updata();
			}

			_repaintLeftContent(id);

			m_currentSelected=id;

		}
		

		/**
		 * 根绝左边列表选择按钮，更新右边内容。
		 * @param id
		 *
		 */
		private function _repaintLeftContent(id:int):void
		{
			_do_responePacketSCLevelQQGift = false;
			
			if (5 != (m_ui as MovieClip).currentFrame)
			{
				return;
			}

			var _data:Pub_Manage_ActionResModel=null;
			var _item:OperatingActivityScrollPanelItem=m_scrollList[id] as OperatingActivityScrollPanelItem;

			if (null == _item)
			{
				return;
			}

			_data=_item.getData() as Pub_Manage_ActionResModel;

			m_ui["txt_action_title"].htmlText=_data.action_title1;
			m_ui["txt_action_desc"].htmlText=_data.action_desc;
			
			m_ui["txt_time"].htmlText=_data.action_time;

			var _stringTxtRulesPattern:RegExp=/__xinshouka__/;
			var _stringTxtRules:String=_data.action_rule;
			trace(_stringTxtRules);
			m_ui["txt_rules"].htmlText=_stringTxtRules.replace(_stringTxtRulesPattern, GameIni.getCardPage());
			m_ui["txt_type"].htmlText=_data.draw;

			_repaintStars(_data.action_star);


			m_ui['mc_song_qb'].visible = false;
			m_ui['mc_jiang_li'].visible = true;
			
			if (m_mapOAScrollPanelItem.containsKey(1))
			{
				var _oaItem:OperatingActivityScrollPanelItem = m_mapOAScrollPanelItem.get(1) as OperatingActivityScrollPanelItem;
				if(null != _oaItem)
				{
					_oaItem.setEffectFangSong(this.m_isInKaiFuHuoDong);
				}
			}
			_visibleSomeTF(true);
			

			//根据不同的活动分类，页面的表现形式也是不同的
			switch (_data.sort)
			{
				case 1:
					_repaintSort_1(_data);
					break;
				case 2:
					_repaintSort_2(_data);
					break;
				case 3:
					_repaintSort_3(_data);
					break;
				case 4:
					_repaintSort_4(_data);
					_visibleSomeTF(false);
					break;
				case 5:
					_repaintSort_5(_data);
					_visibleSomeTF(false);
					break;
				case 6:
					_repaintSort_6(_data);
					_visibleSomeTF(false);
					break;
				case 7:
					_repaintSort_7(_data);
					break;
				case 8:
					_repaintSort_8(_data);
					_visibleSomeTF(false);
					break;
				default:
					break;

			}
		}

		private function _repaintSort_1(_data:Pub_Manage_ActionResModel):void
		{
			//通过掉落 ID 查询获得的奖励
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=null;

			//掉落中的道具
			var _cSelectedRewardListItem:Pub_ToolsResModel=null;

			m_ui["mc_jiang_li"].gotoAndStop(1);

//			m_ui["mc_jiang_li"]["pic0"]["uil"].source=FileManager.instance.getOperatingActivityItemIconById(10001);
			ImageUtils.replaceImage(m_ui["mc_jiang_li"]["pic0"],m_ui["mc_jiang_li"]["pic0"]['uil'],FileManager.instance.getOperatingActivityItemIconById(10001));
			_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(_data.action_prize) as Vector.<Pub_DropResModel>;

			var _sprite0:*=null;
			var _bagCell0:StructBagCell2=null;

			//一共六个奖励格子 ,先初始化一下。
			for (var _i:int=0; _i < 6; ++_i)
			{
				_sprite0=m_ui["mc_jiang_li"]["pic" + (_i + 1)];
				_sprite0["data"]=null;
				_sprite0.mouseChildren=false;
				m_ui["mc_jiang_li"]["pic" + (_i + 1)]["uil"].source=null;
				m_ui["mc_jiang_li"]["pic" + (_i + 1)]["r_num"].text="";
				CtrlFactory.getUIShow().removeTip(_sprite0);
				ItemManager.instance().setEquipFace(_sprite0, false);
			}


			for (var i:int=0; i < _cSelectedRewardList.length; ++i)
			{
				_cSelectedRewardListItem=XmlManager.localres.getToolsXml.getResPath(_cSelectedRewardList[i].drop_item_id) as Pub_ToolsResModel;
				m_ui["mc_jiang_li"]["pic" + (i + 1)]["uil"].source=FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon);
				m_ui["mc_jiang_li"]["pic" + (i + 1)]["r_num"].text="" + StringUtils.changeToTenThousand(_cSelectedRewardList[i].drop_num);

				_sprite0=m_ui["mc_jiang_li"]["pic" + (i + 1)];
				_sprite0["data"]=null;
				_sprite0.mouseChildren=false;

				if (null != _cSelectedRewardListItem)
				{
					_bagCell0=new StructBagCell2();
					_bagCell0.itemid=_cSelectedRewardListItem.tool_id;
					Data.beiBao.fillCahceData(_bagCell0);
					_sprite0["data"]=_bagCell0;

					CtrlFactory.getUIShow().addTip(_sprite0);
					ItemManager.instance().setEquipFace(_sprite0, true);
				}

			}

			//VipGift.getInstance().isGetVipGift(1)   //该接口可以判断首冲礼包是否可领
			if (Data.myKing.Vip <= 0 || !VipGift.getInstance().isGetVipGift(1))
			{
				StringUtils.setUnEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
			}
			else
			{
				StringUtils.setEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
			}

		}

		private function _repaintSort_2(_data:Pub_Manage_ActionResModel):void
		{
			//通过掉落 ID 查询获得的奖励
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=null;

			//掉落中的道具
			var _cSelectedRewardListItem:Pub_ToolsResModel=null;

			//直接开启兑换 cdk 
			m_ui["mc_jiang_li"].gotoAndStop(2);

			StringUtils.setEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
			m_ui["mc_jiang_li"]["btn_ling_jiang"].visible = true;

//			m_ui["mc_jiang_li"]["pic0"]["uil"].source=FileManager.instance.getOperatingActivityItemIconById(20001);
			ImageUtils.replaceImage(m_ui["mc_jiang_li"]["pic0"],m_ui["mc_jiang_li"]["pic0"]['uil'],FileManager.instance.getOperatingActivityItemIconById(20001));
			_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(_data.action_prize) as Vector.<Pub_DropResModel>;

			var _sprite1:*=null;
			var _bagCell1:StructBagCell2=null;

			//一共六个奖励格子 ,先初始化一下。
			for (var _n:int=0; _n < 6; ++_n)
			{
				_sprite1=m_ui["mc_jiang_li"]["pic" + (_n + 1)];
				_sprite1["data"]=null;
				_sprite1.mouseChildren=false;
				m_ui["mc_jiang_li"]["pic" + (_n + 1)]["uil"].source=null;
				m_ui["mc_jiang_li"]["pic" + (_n + 1)]["r_num"].text="";
				CtrlFactory.getUIShow().removeTip(_sprite1);
				ItemManager.instance().setEquipFace(_sprite1, false);
			}

			for (var n:int=0; n < _cSelectedRewardList.length; ++n)
			{
				_cSelectedRewardListItem=XmlManager.localres.getToolsXml.getResPath(_cSelectedRewardList[n].drop_item_id) as Pub_ToolsResModel;
//				m_ui["mc_jiang_li"]["pic" + (n + 1)]["uil"].source=FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon);
				ImageUtils.replaceImage(m_ui["mc_jiang_li"]["pic" + (n + 1)],m_ui["mc_jiang_li"]["pic" + (n + 1)]['uil'],FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon));
				m_ui["mc_jiang_li"]["pic" + (n + 1)]["r_num"].text="" + StringUtils.changeToTenThousand(_cSelectedRewardList[n].drop_num);

				_sprite1=m_ui["mc_jiang_li"]["pic" + (n + 1)];
				_sprite1["data"]=null;
				_sprite1.mouseChildren=false;

				if (null != _cSelectedRewardListItem)
				{
					_bagCell1=new StructBagCell2();
					_bagCell1.itemid=_cSelectedRewardListItem.tool_id;
					Data.beiBao.fillCahceData(_bagCell1);
					_sprite1["data"]=_bagCell1;

					CtrlFactory.getUIShow().addTip(_sprite1);
					ItemManager.instance().setEquipFace(_sprite1, true);
				}


			}
		}

		private function _repaintSort_3(_data:Pub_Manage_ActionResModel):void
		{
			m_ui["mc_jiang_li"].gotoAndStop(3);

			if (_data.prize_1)
			{
				m_ui["mc_jiang_li"]["btn_kan_bang"].visible=true;
			}
			else
			{
				m_ui["mc_jiang_li"]["btn_kan_bang"].visible=false;
			}

			m_ui["mc_jiang_li"]["btn_ling_jiang"].visible=false;
			m_ui["mc_jiang_li"]["txt_content1"].htmlText=_data.prize_desc;
		}

		private function _repaintSort_4(_data:Pub_Manage_ActionResModel):void
		{
			m_ui["mc_jiang_li"].gotoAndStop(4);
			m_ui["mc_jiang_li"]["btn_chong_zhi"].visible=true;

		}

		private function _repaintSort_5(_data:Pub_Manage_ActionResModel):void
		{
			m_ui["mc_jiang_li"].gotoAndStop(5);
			m_ui["mc_jiang_li"]["btn_chong_zhi"].visible=true;
		}
		
		private function _repaintSort_8(_data:Pub_Manage_ActionResModel):void
		{
			m_ui["mc_jiang_li"].gotoAndStop(9);
			m_ui["mc_jiang_li"]["btn_chong_zhi"].visible=true;
		}
		

		private function _repaintSort_6(_data:Pub_Manage_ActionResModel):void
		{
			m_ui["mc_jiang_li"].gotoAndStop(6);
			//m_ui["mc_jiang_li"]["btn_chong_zhi"].visible = true;
			if (null != m_ui["mc_jiang_li"] && null != m_ui["mc_jiang_li"]["mc_page"])
			{
				_sysAddEvent(m_ui["mc_jiang_li"]["mc_page"], MoreLessPage.PAGE_CHANGE, _changePageListener);

				m_ui["mc_jiang_li"]["mc_page"].setMaxPage(1, 3);
			}
		}
		
		private var m_alert:GameAlert;
		//是否在领取时间内
		private var m_isInGet:Boolean = false;
		//是否在开服时间内
		private var m_isInKaiFuHuoDong:Boolean = false;
		private function _onGetQBListener(e:MouseEvent = null):void
		{
			
			if(null == m_alert)
			{
				m_alert = new GameAlert();
			}
			var _kinglevel:int = Data.myKing.level;
			if(_kinglevel >= 90)
			{
//				if(m_isInKaiFuHuoDong)
//				{
//					m_alert.ShowMsg(Lang.getLabel("40066_getQB_1",[GameIni.url_qq,GameIni.url_tel]),2);
//				}
//				else
//				{
//					m_alert.ShowMsg(Lang.getLabel("40066_getQB_3",[_starServerTimeDateString+"-"+_30DayString]),2);
//				}
				
				if(m_isInGet)
				{
					m_alert.ShowMsg(Lang.getLabel("40066_getQB_1",[GameIni.url_qq,GameIni.url_tel]),2);
				}
				else
				{
					m_alert.ShowMsg(Lang.getLabel("40066_getQB_3",[_28DayString+"-"+_30DayString]),2);
				}
			}
			else
			{
				m_alert.ShowMsg(Lang.getLabel("40066_getQB_2"),2);
			}
			
		}
		
		private function _onExchangeYBListener(e:MouseEvent = null):void
		{
			var _p:PacketCSLevelQQGiftToRmb = null;
			if(null == m_alert)
			{
				m_alert = new GameAlert();
			}
			
			if(m_isInGet)
			{
				if(m_YBNum <= 0)
				{
					
					//没有可兑换的元宝
					m_alert.ShowMsg(Lang.getLabel("40067_getYB_1"),2)
				}
				else
				{
					_p = new PacketCSLevelQQGiftToRmb();
					DataKey.instance.send(_p);
				}
			}
			else
			{
				m_alert.ShowMsg(Lang.getLabel("40066_getQB_3",[_28DayString+"-"+_30DayString]),2);
			}
			
			
			
		}
		
		private var m_YBNum:int;
		private function _repaintSort_7(_data:Pub_Manage_ActionResModel):void
		{
			//提取QB按钮事件
			m_ui["mc_song_qb"]["btnGetQB"].addEventListener(MouseEvent.CLICK,_onGetQBListener);
			
			//兑换元宝事件
			m_ui["mc_song_qb"]["btnGetYB"].addEventListener(MouseEvent.CLICK,_onExchangeYBListener);
			
			m_ui['mc_song_qb'].visible = true;
			m_ui['mc_jiang_li'].visible = false;
			
			_do_responePacketSCLevelQQGift = true;
			
			//请求当前玩加升级获得QB
			var _p:PacketCSLevelQQGift = new PacketCSLevelQQGift();
			DataKey.instance.send(_p);
		}
		
		private var _do_responePacketSCLevelQQGift:Boolean = false;
		private function _responePacketSCLevelQQGift(p:IPacket):void
		{
			if(!_do_responePacketSCLevelQQGift)
			{
				return ;
			}
			
			_do_responePacketSCLevelQQGift = false;
			
			var _p:PacketSCLevelQQGift = p as PacketSCLevelQQGift;
			

			_starServerTimeDate = StringUtils.iDateToDate(_p.start_date);
			
			_countKaiFu();
			//_selected(m_defaultOAIndex);
			
			
			_starServerTimeDateString =  _starServerTimeDate.getFullYear()+Lang.getLabel("pub_nian")+
				(_starServerTimeDate.getMonth()+1)+Lang.getLabel("pub_yue")+_starServerTimeDate.getDate()+Lang.getLabel("pub_ri")+"00:00";
			
			
			_30DayString = _30Day.getFullYear()+Lang.getLabel("pub_nian")+
				(_30Day.getMonth()+1)+Lang.getLabel("pub_yue")+_30Day.getDate()+Lang.getLabel("pub_ri")+"23:59";
			
			
			
			
			_28DayString = _28Day.getFullYear()+Lang.getLabel("pub_nian")+
				(_28Day.getMonth()+1)+Lang.getLabel("pub_yue")+_28Day.getDate()+Lang.getLabel("pub_ri")+"00:00";
			
			//根据服务器返回值计算当前Q币个数
			var _QBNum:int = _p.num;
			
			//根据Q币个数计算可兑换的元宝
			m_YBNum = _QBNum * 5;
			
			m_ui['mc_song_qb']['txt_time'].htmlText = _starServerTimeDateString + " - " + _30DayString;
			m_ui['mc_song_qb']['txt_time2'].htmlText = _28DayString + " - " + _30DayString;
			
			m_ui['mc_song_qb']['txt_qq_bi'].htmlText = _QBNum+"/1450" ;
			m_ui['mc_song_qb']['txt_yuan_bao'].htmlText = m_YBNum ; 

			
		}
		
		
		private function _responePacketSCLevelQQGiftToRmb(p:IPacket):void
		{
			var _p:PacketSCLevelQQGiftToRmb = p as PacketSCLevelQQGiftToRmb;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
			m_YBNum = 0;
			m_ui['mc_song_qb']['txt_qq_bi'].htmlText = 0+"/1450" ;
			m_ui['mc_song_qb']['txt_yuan_bao'].htmlText = 0+"";
		}
		
		/**
		 * 根据当前人物等级计算兑换的QB个数 
		 * @param level
		 * 
		 */		
		private function _countQB(level:int):int
		{
			//区间
			var _interzone:int = level / 10;
			//余数
			var _remainder:int = level % 10;
			
			var _retQB:int = 0;
			
			for(var i:int = 1 ; i <= _interzone ; ++i)
			{
				_retQB += _countEveryInterzoneQB(i) * 10;
			}
			
			_retQB += _countEveryInterzoneQB( _interzone + 1 ) * _remainder;
			
			if(level >= 90)
			{
				_retQB = 1450;
			}
			
			return _retQB;
		}
		
		private function _countEveryInterzoneQB(_interzone:int):int
		{
			//每级的QB个数
			var _everyLevel:int = _interzone;
			
			return _everyLevel;
		}
		

		private function _changePageListener(e:DispatchEvent=null):void
		{
			//当前页面索引值
			var _cPage:int=e.getInfo.count;

			m_ui["mc_jiang_li"].gotoAndStop(5 + _cPage);
		}

		private function _sysAddEvent(target:EventDispatcher, type:String, func:Function):void
		{
			target.addEventListener(type, func);
		}

		private function _onLinkOverListener(e:MouseEvent):void
		{
			trace(" 1 _onLinkOverListener ... ...");
			var _tf:TextField=e.target as TextField;

			if (null != _tf)
			{
				_tf.dispatchEvent(new TextEvent(TextEvent.LINK));
			}

		}

		private function _onLinkClickListener(e:TextEvent):void
		{
			trace(" 2 _onLinkClickListener ... ..." + e.text);
		}

		private function _repaintStars(action_star:int):void
		{
			for (var i:int=1; i <= 5; ++i)
			{
				if (i <= action_star)
				{
					m_ui["action_star" + i].visible=true;
				}
				else
				{
					m_ui["action_star" + i].visible=false;
				}
			}
		}
		
		private function _visibleSomeTF(b:Boolean):void
		{
			m_ui['tf_liangqu_fangshi'].visible = b;
			m_ui['tf_jiangpin_xingji'].visible = b;
			m_ui['txt_type'].visible = b;
			for (var i:int=1; i <= 5; ++i)
			{
				m_ui["action_star" + i].visible=b;
			}
		}
		
		/**
		 * 通过掉落ID 获得 排名奖励的字符串
		 * @param dropID
		 * @return
		 *
		 */
		private function _createMingCiJiangLi(dropID:int):String
		{
			var _ret:String="";

			//通过掉落 ID 查询获得的奖励
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=null;

			//掉落中的道具
			var _cSelectedRewardListItem:Pub_ToolsResModel=null;

			_cSelectedRewardList=XmlManager.localres.getDropXml.getResPath2(dropID) as Vector.<Pub_DropResModel>;

			var _length:int=_cSelectedRewardList.length;
			for (var i:int=0; i < _length; ++i)
			{
				_cSelectedRewardListItem=XmlManager.localres.getToolsXml.getResPath(_cSelectedRewardList[i].drop_item_id) as Pub_ToolsResModel;

				_ret+="<font color='#" + ResCtrl.instance().arrColor[_cSelectedRewardListItem.tool_color] + "'><a href='event:myTxt'>" + _cSelectedRewardListItem.tool_name + "×" + StringUtils.changeToTenThousand(_cSelectedRewardList[i].drop_num) + "</a></font>";

				if (i < (_length - 1))
				{
					_ret+=" ";
				}
			}

			return _ret;
		}


		/**
		 * 获得条目对象实例
		 */
		private function _getOperatingActivityScrollPanelItem(id:int):Sprite
		{
			if (m_mapOAScrollPanelItem.containsKey(id))
			{
				return m_mapOAScrollPanelItem.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("huo_dong", "OperatingActivityScrollPanelItem");
				
				if(null == c)
				{
					c=GamelibS.getswflinkClass("fuli", "OperatingActivityScrollPanelItem");
					
				}
				
				
				var sp:Sprite=new c() as Sprite;

				var _item:OperatingActivityScrollPanelItem=new OperatingActivityScrollPanelItem(sp);
				_item.setID(id);
				_item.mouseChildren=false;

				m_mapOAScrollPanelItem.put(id, _item);
				return _item;
			}
		}

		/**
		 * 将指定显示容器内的显示对象从显示列表中移除。
		 * @param mc
		 *
		 */
		private function _clearMcContent(mc:Sprite):void
		{
			if (null != mc)
			{
				while (mc.numChildren > 0)
					mc.removeChildAt(0);
			}
		}

		/**
		 * 领取礼包的返回消息处理
		 * @param p
		 *
		 */
		private function _giftReturnCallback(p:PacketSCGetGift):void
		{
			if (0 != p.tag)
			{
				return;
			}

			if (5 == m_currentSelected || 3 == m_currentSelected)
			{
				StringUtils.setUnEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
			}
		}

		/**
		 * 向服务器请求该玩家是否是领取奖励:1是领取奖励，0是请求奖励数据
		 * @param award_get
		 *
		 */
		private function _requestRankTopAward(award_get:int):void
		{
			var _p:PacketCSRankTopAward=new PacketCSRankTopAward();
			_p.award_get=award_get;

			DataKey.instance.send(_p);

		}

		/**
		 * 服务器返回领取排名奖励，或者返回查询排名奖励
		 *
		 */
		private function _responseRankTopAward(p:PacketSCRankTopAward):void
		{
			Lang.showResult(p);

			if (0 != p.tag)
			{
				return;
			}


			if (1 == p.award_get)
			{
				//请求领取
				StringUtils.setUnEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
			}
			//			else if(0 == p.award_get)
			//			{
			//				//请求查询
			//			}

		}

		/**
		 * 向服务器 请求 查询该 排名奖励是否可领
		 * @param sort
		 *
		 */
		private function _requestRankTopAwardByType(sort:int):void
		{
			var _p:PacketCSRankAwardRequire=new PacketCSRankAwardRequire();
			_p.sort=sort;

			DataKey.instance.send(_p);
		}



		private function _responseRankTopAwardByType(p:PacketSCRankAwardRequire):void
		{


			//是否需要处理当前的领奖按钮
			var _isNeed:Boolean=false;

			switch (m_currentSelected)
			{
				case 2: // 星魂排行
					if (5 == p.sort)
					{
						_isNeed=true;
					}
					break;
				case 3: // 伙伴排行
					if (2 == p.sort)
					{
						_isNeed=true;
					}
					break;
				case 4: // 战力值排行
					if (1 == p.sort)
					{
						_isNeed=true;
					}
					break;
				case 1: // 等级排行
					if (3 == p.sort)
					{
						_isNeed=true;
					}
					break;
				default:
					break
			}


			if (_isNeed && (6 == (m_ui as MovieClip).currentFrame))
			{
				if(null == m_ui["mc_jiang_li"] && null ==  m_ui["mc_jiang_li"]["btn_ling_jiang"])
				{
					if (1 == p.allow)
					{
						//可领
						StringUtils.setEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
					}
					else if (0 == p.allow)
					{
						//不可领
						StringUtils.setUnEnable(m_ui["mc_jiang_li"]["btn_ling_jiang"]);
					}
				}
				
				
			}
		}

	}
}


