package ui.view.view4.pkmatch
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import flash.display.Sprite;
	
	import model.pkmatch.PKMatchEvent;
	import model.pkmatch.PKMatchModel;
	
	import netc.Data;
	import netc.packets2.StructPk_Player_List2;
	
	import nets.packets.PacketWCGetPlayerPkList;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.view.view5.saloon.SaloonTopList;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	/**
	 * 个人 PK 赛 主窗口 
	 * @author steven guo
	 * 
	 */	
	public class PKMatchWindow extends UIWindow
	{
		private static var m_instance:PKMatchWindow = null;
		
		private var m_model:PKMatchModel = null;
		
		//每页个数
		private static const TOTAL_PAGE_NUM:int = 12;
		
		
		/**
		 * 战报滚动条内容面板 
		 */		
		private var mc_scrollPanel:Sprite;
		
		/**
		 * 显示item 列表对象 
		 */		
		private var m_itemList:Array;
		
		private var m_leftPageIndex:int = 1;
		private var m_rightPageIndex:int = 1;
		
		/**
		 * 当前战报选择 
		 */		
		private var m_zhanbao_selectIndex:int = 1;
		
		
		
		public function PKMatchWindow()
		{
			//super(getLink(WindowName.win_PK_Match));
			
			m_model = PKMatchModel.getInstance();
		}
		
		/**
		 * 获得单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():PKMatchWindow
		{
			if (null == m_instance)
			{
				m_instance= new PKMatchWindow();
			}
			
			return m_instance;
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			m_model.removeEventListener(PKMatchEvent.PK_MATCH_EVENT,_processEvent);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onGameClockListener);
			
			//当关闭窗口的时候就停止告知服务器停止发送消息
			//m_model.requestCWSetPkUpdate(1,2);
			m_model.requestCWSetPkUpdate(2,2);
			m_model.requestCWSetPkUpdate(3,2);
		}
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			//如果没有设置临时阵营，要先选择临时阵营
//			if(ZhenYing.instance().camp==0){
//				super.winClose();
//				ZhenYing.instance().open(true);
//				return;
//			}
				
			PKMatchModel.getInstance();
			
			_initCom();
			
			
			m_model.addEventListener(PKMatchEvent.PK_MATCH_EVENT,_processEvent);
			
				//repaint();
			
			//告诉服务器开启信息发送
			m_model.requestCWSetPkUpdate(1,1);
			m_model.requestCWSetPkUpdate(2,1);
			m_model.requestCWSetPkUpdate(3,1);
			
			//向服务器请求获得总 太乙 通天 的总积分
			m_model.requestTotalNumber();
			
			//向服务器请求个人信息
			m_model.requestPersonalInfo();
			
			//向服务器请求 太乙 通天 参战人员列表
			m_model.requestSoldiers(2,1);
			m_model.requestSoldiers(3,1);
			
			mcHandler({name:"db"+m_zhanbao_selectIndex});
			
			
			//开启剩余时间倒计时
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onGameClockListener);
			
			_repaintBtnEnter();
			
			Lang.addTip(mc['btn_jiang23'],"40095_PKMatchWindow_jiangli",200);
			
		}

		
		private function _initCom():void
		{
			if(null == mc_scrollPanel)
			{
				mc_scrollPanel = new Sprite();
				
				m_itemList = [];
				
				for(var i:int = 0; i<PKMatchModel.SCROLL_LIST_MAX_NUM_ZHANBAO; ++i)
				{
					//mc_scrollPanel.addChild(_getItem());
					m_itemList[i] = _getItem();
				}
				
				//进行布局
				//CtrlFactory.getUIShow().showList2(mc_scrollPanel,1,303,20);
				
				mc["sp_zbao"].source=mc_scrollPanel;
			}
//			else
//			{
//				_clearMcContent(mc_scrollPanel);
//			}
			
			super.sysAddEvent(mc["mc_page_left"],MoreLessPage.PAGE_CHANGE,_changePageLeftListener);
			super.sysAddEvent(mc["mc_page_right"],MoreLessPage.PAGE_CHANGE,_changePageRightListener);
			
			mc['txt_time__'].visible = false;
			mc['btn_jiang23'].visible = false;
			
			_repaintZhangBao();
			
			_repaintPersonalInfo();
			
			_repaintLeftList();
			
			_repaintRightList();
			
			_repaintBtnPrize();
		}
		
	
		private var m_currentLeftPageIndex:int = 1;
		
		private function _changePageLeftListener(e:DispatchEvent=null):void
		{
			//当前页面索引值
			var _cPage:int = e.getInfo.count;
			
			if(m_currentLeftPageIndex != _cPage)
			{
				m_currentLeftPageIndex = _cPage;
				m_model.requestSoldiers(2,_cPage);
				
				return ;
			}
			
			
			
			var _left:PacketWCGetPlayerPkList = m_model.getLeftInfo();
			
			var _player:StructPk_Player_List2 = null;
			var _playerListLength:int = _left.arrIteminfo_list.length;
			var _str:String = null;
			for(var i:int=0; i<TOTAL_PAGE_NUM ; ++i)
			{
				_player = null;
				_str = "";
				if(i < _playerListLength)
				{
					_player = _left.arrIteminfo_list[i];
				}
				
				if(null != _player)
				{
					mc['left_hero'+i].visible = true;
					
					//[待]
					if(1 == _player.state)
					{
						_str +="<font color='#00ff00'>["+Lang.getLabelArr("arrPKMatch")[10]+"]</font>";
					}
					//[战]
					else if(2 ==  _player.state)
					{
						_str +="<font color='#ff0000'>["+Lang.getLabelArr("arrPKMatch")[11]+"]</font>";
					}
					
					_str +=  "<font color='#ec8929'>"+_player.username;
					
					//显示玩家等级 
					_str +=  " Lv"+_player.level+"</font>";
					
					
					mc['left_hero'+i]['txt_time'].htmlText =_str;
				}
				else
				{
					mc['left_hero'+i].visible = false;
				}
			}
		}
		
		private var m_currentRightPageIndex:int = 1;
		private function _changePageRightListener(e:DispatchEvent=null):void
		{
			//当前页面索引值
			var _cPage:int = e.getInfo.count;
			
			if(m_currentRightPageIndex != _cPage)
			{
				m_currentRightPageIndex = _cPage;
				m_model.requestSoldiers(3,_cPage);
				
				return ;
			}
			
			var _right:PacketWCGetPlayerPkList = m_model.getRightInfo();
			
			var _player:StructPk_Player_List2 = null;
			var _playerListLength:int = _right.arrIteminfo_list.length;
			var _str:String = null;
			for(var i:int=0; i<TOTAL_PAGE_NUM ; ++i)
			{
				_player = null;
				_str = "";
				if(i < _playerListLength)
				{
					_player = _right.arrIteminfo_list[i];
				}
				
				if(null != _player)
				{
					mc['right_hero'+i].visible = true;
					
					//[待]
					if(1 == _player.state)
					{
						_str +="<font color='#00ff00'>[待]</font>";
					}
						//[战]
					else if(2 ==  _player.state)
					{
						_str +="<font color='#ff0000'>[战]</font>";
					}
					
					_str +=  "<font color='#21fff7'>"+_player.username;
					//显示玩家等级 
					_str +=  " Lv"+_player.level+"</font>";
					
					mc['right_hero'+i]['txt_time'].htmlText =_str;
				}
				else
				{
					mc['right_hero'+i].visible = false;
				}
			}
		}
		
		
		/**
		 * 将指定显示容器内的显示对象从显示列表中移除。
		 * @param mc
		 * 
		 */		
		private function _clearMcContent(mc:Sprite):void
		{
			if(null != mc)
			{
				while(mc.numChildren>0)mc.removeChildAt(0);
			}
		}
		
		/**
		 * 处理鼠标的点击事件  
		 * @param target
		 * 
		 */		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			
			if(0 == name.indexOf("db1"))
			{
				//全部战报
				m_zhanbao_selectIndex = 1;
				mc["db1"].selected = true;
				
				_repaintZhangBao();
			}
			else if(0 == name.indexOf("db2"))
			{
				//个人战报
				m_zhanbao_selectIndex = 2;
				mc["db2"].selected = true;
				
				_repaintZhangBao();
			}
			else if(0 == name.indexOf("f_0"))
			{
				mc["f_0"].selected = !mc["f_0"].selected;
				m_model.setNeedGuaJi(mc["f_0"].selected);
			}
			else if(0 == name.indexOf("btn_Canzhan"))
			{
				//var _i:int = 0;
				m_model.requestEnterWar();
			}
			else if(0 == name.indexOf("btn_TingZhi"))
			{
				m_model.requestCSPlayerLeavePk();
			}
			else if(0 == name.indexOf("mc_page_left"))
			{
				
			}
			else if(0 == name.indexOf("mc_page_right"))
			{
				
			}
			else if(0 == name.indexOf("btnJiFenBang"))
			{
				if(!PKMatchJiFen.getInstance().isOpen)
				{
					PKMatchJiFen.getInstance().open(true);
				}
			}
			else if(0 == name.indexOf("btn_jiang23"))
			{
				SaloonTopList.getInstance().saloon_id = 2;
				SaloonTopList.getInstance().open();
			}
			//日排行榜和周排行榜奖励数据可读取“排行榜奖励(pub_top_prize)”中的sort字段，sort=2是日排名奖励；sort=3是周排名奖励。
			else if(0 == name.indexOf("btnWeek_prize"))
			{
				SaloonTopList.getInstance().saloon_id = 3;
				SaloonTopList.getInstance().open();
			}
			else if(0 == name.indexOf("btnDay_prize"))
			{
				SaloonTopList.getInstance().saloon_id = 2;
				SaloonTopList.getInstance().open();
			}
			else if(0 == name.indexOf("btnEvery_prize"))
			{
				//
			}
		}
		
		
		public function repaint(type:int=-1):void
		{
			if(type <= -1)
			{
				_repaintTotalNumber();
				_repaintPersonalInfo();
			}
			else
			{
				switch(type)
				{
					case 0:
						_repaintTotalNumber();
						break;
					case 1:
						_repaintPersonalInfo();
						break;
					default:
						break;
				}
			}
			
			
		}
		
		
		private function _repaintTotalNumber():void
		{
			var _jifen_0:int =  m_model.getTotalNumber_TT();
			var _jifen_1:int =  m_model.getTotalNumber_TY();
			//总积分
			mc["tf_jifen_0"].text = _jifen_0.toString();
			mc["tf_jifen_1"].text = _jifen_1.toString();
			//剩余时间
			mc["tf_RemainingTime"].text = StringUtils.getStringDayTime( m_model.getRemainingTime() * 1000 );
			
			if(_jifen_0 == _jifen_1)
			{
				return  ;
			}
			else if(_jifen_0 > _jifen_1)
			{
				
			}
			else
			{
				
			}
		}
		
		private function _onGameClockListener(e:WorldEvent=null):void
		{
			//剩余时间
			mc["tf_RemainingTime"].text = StringUtils.getStringDayTime( m_model.getRemainingTime() * 1000 );
		}
		
		private function _repaintPersonalInfo():void
		{
			
			//mc["tf_king_name"].text = DataCenter.myKing.name;
			if(1 == Data.myKing.campid)
			{
				mc["txt_king_name"].text = Data.myKing.name;
			}
			//正派
			else if(2 == Data.myKing.campid)
			{
				mc["txt_king_name"].text = '['+Lang.getLabel('pub_zheng_pai')+']'+Data.myKing.name;
			}
			//邪派
			else if(3 == Data.myKing.campid)
			{
				mc["txt_king_name"].text = '['+Lang.getLabel('pub_xie_pai')+']'+Data.myKing.name;
			}
			
			
			mc["tf_king_0"].text  = m_model.getNo();
			mc["tf_king_1"].text = m_model.getCWin();
			mc["tf_king_2"].text = m_model.getRank();
			mc["tf_king_3"].text = m_model.getMaxWin();
			mc["tf_king_4"].text = m_model.getRenown();
			
//			mc["uil"].source = FileManager.instance.getHeadIconXById(Data.myKing.Icon);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(Data.myKing.Icon));
			mc["tf_king_level"].text = Data.myKing.level+Lang.getLabel('pub_ji');
			
		}
		
		private function _repaintZhangBao():void
		{
			//mc.numChildren
			var _all:Array = null;
			
			if(1 == m_zhanbao_selectIndex)
			{
				//全部战报
				_all = m_model.getAllZhanBaoList();
			}
			else
			{
				//个人战报
				_all = m_model.getPersonalZhanBaoList();
			}
			
			
			
			if(mc.numChildren != _all.length)
			{
				_clearMcContent(mc_scrollPanel);
			}
			
			var _length:int = _all.length;
			for(var i:int = 0 ; i<_length ; ++i)
			{
				mc_scrollPanel.addChild(m_itemList[i]);
				
				m_itemList[i].setPKNews(_all[i]);
			}
			
			CtrlFactory.getUIShow().showList2(mc_scrollPanel,1,303,20);
			
			mc["sp_zbao"].source=mc_scrollPanel;
			mc["sp_zbao"].position = 100;
		}
		
		/**
		 * 参战  or  离开按钮 
		 * 
		 */		
		private function _repaintBtnEnter():void
		{
			//参战状态
			if(PKMatchModel.getInstance().getEntering())
			{
				mc['btn_Canzhan'].visible = false;
				mc['btn_TingZhi'].visible = true;
			}
			else 
			{
				mc['btn_Canzhan'].visible = true;
				mc['btn_TingZhi'].visible = false;
			}
		}
		
		/**
		 * 更新双方参赛选手的个数 
		 * 
		 */		
		private function _repaintHeroNumber():void
		{
			//mc['tf_Number_TT'].htmlText = "<font color='#ec8929'>通天教参战英雄("+m_model.getNumber_TT()+"人)</font>";
			//mc['tf_Number_TY'].htmlText = "<font color='#21fff7'>太乙教参战英雄("+m_model.getNumber_TY()+"人)</font>";
			mc['tf_Number_TT'].htmlText = Lang.getLabel("40095_PKMatchWindow_0",[m_model.getNumber_TT()]);
			mc['tf_Number_TY'].htmlText = Lang.getLabel("40095_PKMatchWindow_1",[m_model.getNumber_TY()]);    
		}
		
		private function _repaintLeftList():void
		{
			var _left:PacketWCGetPlayerPkList = m_model.getLeftInfo();
			
			if(null != _left)
			{
				m_leftPageIndex = _left.page;
				
				mc["mc_page_left"].setMaxPage(m_leftPageIndex,_left.total_page);
			}
			
		}
		
		private function _repaintRightList():void
		{
			var _right:PacketWCGetPlayerPkList = m_model.getRightInfo();
			
			if(null != _right)
			{
				m_rightPageIndex = _right.page;
				
				mc["mc_page_right"].setMaxPage(m_rightPageIndex,_right.total_page);
			}
			
		}
		
		private function _repaintBtnPrize():void
		{
			mc['btnWeek_prize'].buttonMode = true;
			mc['btnDay_prize'].buttonMode = true;
			mc['btnEvery_prize'].buttonMode = true;
			mc['Pk_Watch_HuoDong'].buttonMode = true;
			
			
			Lang.addTip(mc['btnWeek_prize'],"btnWeek_prize_tip",220);
			Lang.addTip(mc['btnDay_prize'],"btnDay_prize_tip",220);
			Lang.addTip(mc['btnEvery_prize'],"btnEvery_prize_tip",220);
			Lang.addTip(mc['Pk_Watch_HuoDong'],"Pk_Watch_HuoDong_tip",220);
		}
		
		
		
		private function _getItem():PKMatchWindowScrollPanelItem
		{
			var c:Class=GamelibS.getswflinkClass("jing_ji_chang", "win_PK_Match_item");
			var sp:Sprite=new c() as Sprite;
			
			var _item:PKMatchWindowScrollPanelItem = new PKMatchWindowScrollPanelItem(sp);
			_item.mouseChildren=false;
			return _item;
			
		}
		
		
		
		/**
		 * 出来PK模块的消息 
		 * @param e
		 * 
		 */		
		private function _processEvent(e:PKMatchEvent):void
		{
			var _sort:int = e.sort;
			
			switch(_sort)
			{
				case PKMatchEvent.PK_EVENT_SORT_PERSONAL_INFO:           // 请求个人的用户信息
					_repaintPersonalInfo();
					break;
				case PKMatchEvent.PK_EVENT_SORT_NOTIFY_PERSONAL_INFO:    // 后台通知个人信息更新
					_repaintPersonalInfo();
					break;
				case PKMatchEvent.PK_EVENT_SORT_TOTAL_NUMBER:            // 获得太乙和通天的总积分消息类型
					_repaintTotalNumber();
					_repaintHeroNumber();
					break;
				case PKMatchEvent.PK_EVENT_LEFT_HERO_LIST:               //  左边 太乙(正派) 参赛人员列表
					_repaintLeftList();
					break;
				case PKMatchEvent.PK_EVENT_RIGHT_HERO_LIST:             //  右边 通天 (邪派) 参赛人员列表
					_repaintRightList();
					break;
				case PKMatchEvent.PK_EVENT_NOTIFY_WAR_INFO:              //  后台主动通知战报信息更新
					_repaintZhangBao();
					break;
				case PKMatchEvent.PK_EVENT_NOTIFY_ENTER_WAR:             //  后台通知玩家请求参战成功
					_repaintBtnEnter();
					break;
				case PKMatchEvent.PK_EVENT_NOTIFY_LEAVE_WAR:             //  后台通知玩家请求离开战斗成功
					_repaintBtnEnter();
					break;
				default:
					break;
			}
			
			
		}
		
		override public function get height():Number{
			return 536;
		}
		
	}
	
	
	
}



