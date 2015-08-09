package ui.frame
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.utils.clock.GameClock;
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.load.Loadres;
	import fl.managers.FocusManager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import scene.body.Body;
	import ui.base.beibao.BeiBao;
	import ui.view.view4.smartimplement.SmartImplementTopList;
	import ui.view.view4.yunying.ZhiZunHotSale;
	import world.FileManager;
	import world.WorldEvent;

	/**
	 * 窗口管理
	 *
	 * 角色窗体         1000
	 * 包裹窗体         1001
	 * 技能窗体         1002
	 * 伙伴窗体         1003
	 * 星魂窗体         1004
	 * 星魂包裹         1005
	 * 境界窗体         1006
	 * 任务窗体         1007
	 * 成就窗体         1008
	 * 好友窗体         1009
	 * 帮派窗体         1010
	 * 组队窗体         1011
	 * 炼丹炉             1012
	 * 阵营窗体         1013
	 * 强化窗体         1014
	 * 重铸窗体         1015
	 * 活动窗体         1016
	 * 帮助窗体         1017
	 * 炼制窗体         1018
	 * 商店窗体         1019
	 * 仓库窗体         1020
	 * 挂机                 1021
	 * 聊天窗体         1022
	 * 排行榜窗体     1024
	 * 系统设置窗体 1025
	 * GM邮箱窗体    1027
	 * 地图窗体         1028
	 * 聚英阁楼         1029
	 * 神秘商店         1030
	 * NPC商店          1031
	 * 兑换商店         1032
	 * 魔纹窗口         1033
	 * 魔纹装备窗口 1034
	 * 魔纹封印选择 1035
	 * 经验找回         1036
	 * npc商店购买  1037
	 * 魔天万界         1038
	 * 挑战神器         1039
	 * 卡片界面         1040
	 * 升级装备材料获得说明 1041
	 * 炼丹材料获得说明 1042
	 * 玄仙宝典主窗口 1043
	 * 玄仙宝典辅助窗口 1044
	 * 魔纹合成材料获得说明 1045
	 * 四神器排行     1046
	 * 角色详细信息 1047
	 * 魔天万界排行榜 1048
	 * 角色查看       1049
	 * 角色查看详细信息 1050
	 * 装备强化合成 1051
	 * 魔纹热卖         1052
	 * NPC Shop 热卖         1053
	 * 坐骑神兽魂器合成         1054
	 * 坐骑       1055
	 * 神铁碎片窗口  1056
	 * 神器                  1057
	 * 神翼                  1058
	 * 神翼进阶               1059
	 * 摆摊               1060
	 * 宠物主面板                     1061
	 * 宠物列表面板                 1062
	 * 宠物 ，技能学习            1063
	 * 宠物强化面板                 1064
	 * 宠物属性                         1065
	 * 宠物 ，详细属性面板    1066
	 * 宠物 ，洗资质                1067
	 * 坐骑总面板    1068
	 * 坐骑进阶面板    1069
	 * 宠物 ，详细属性面板    1070
	 * 摆摊信息        1071
	 * 充值        1072
	 * 我要变强 1073
	 * 宠物根骨丹合成面板  1074
	 * 武林宝典导航  1075
	 * 武林宝典内容  1076
	 * 天工开物      1077
	 * 天工开物图谱  1078
	 * 装备分解 1079
	 * 帮派捐 1080
	 * 装备合成 1081
	 * 装备合成图谱 1082
	 * 积分兑换 1083
	 * 积分兑换列表 1084
	 *
	 * 寻宝1085
	 * 寻宝仓库1086
	 * 交易 1087
	 * @author steven guo
	 *
	 */
	public class UIWindowManager
	{
		private static var m_instance:UIWindowManager;
		private var m_windowList:Array;
		/**
		 * 当前并存的窗口列表
		 */
		private var m_cTogetherList:Array;
		/**
		 * focus
		 */
		private var _focusManager:FocusManager;

		public function GetFocusManager():FocusManager
		{
			if (null == _focusManager)
			{
				if (null != PubData.mainUI)
				{
					if (null != PubData.mainUI.stage)
					{
						_focusManager=new FocusManager(PubData.mainUI.stage);
					}
				}
			}
			return _focusManager;
		}

		public function UIWindowManager()
		{
			m_windowList=[];
		}

		public static function getInstance():UIWindowManager
		{
			if (null == m_instance)
			{
				m_instance=new UIWindowManager();
			}
			return m_instance;
		}

		/**
		 * 注册窗口到窗口管理器中，方便管理。
		 * @param wd
		 *
		 */
		public function add(wd:UIWindow):void
		{
			if (null == wd)
			{
				return;
			}
			var _id:int=wd.getID();
			m_windowList[_id]=wd;
			wd.addEventListener(Event.ADDED_TO_STAGE, _onAddToStageListener);
			wd.addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStageListener);
		}

		/**
		 * 将窗口从管理器中移除
		 * @param wd
		 *
		 */
		public function del(wd:UIWindow):void
		{
			if (null == wd)
			{
				return;
			}
			wd.removeEventListener(Event.ADDED_TO_STAGE, _onAddToStageListener);
			wd.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStageListener);
			var _id:int=wd.getID();
			m_windowList[_id]=null;
			delete m_windowList[_id];
		}

		private function _onAddToStageListener(e:Event):void
		{
			var _wd:UIWindow=e.target as UIWindow;
			if (null == _wd)
			{
				return;
			}
			var _id:int=_wd.getID();
			_handleAdd(_id);
		}

		private function _onRemovedFromStageListener(e:Event):void
		{
			var _wd:UIWindow=e.target as UIWindow;
			if (null == _wd)
			{
				return;
			}
			var _id:int=_wd.getID();
			_handleRemove(_id);
		}

		/**
		 * 将窗口添加到 舞台 上的时候如何处理
		 * @param id
		 *
		 */
		private function _handleAdd(id:int):void
		{
			var _wd:UIWindow=null;
			var _wd2:UIWindow=null; //相关窗口
			var _w0:UIWindow=null;
			var _w1:UIWindow=null;
			var _w2:UIWindow=null;
			var _w3:UIWindow=null;
			var _w4:UIWindow=null;
			var _w5:UIWindow=null;
			var _w6:UIWindow=null;
			var _w7:UIWindow=null;
			var _w8:UIWindow=null;
			switch (id)
			{
				case 1000: // 角色窗体    -----  除包裹．好友．聊天面板外互斥其他窗体
					for each (_wd in m_windowList)
					{
						if (1000 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID() && 1019 != _wd.getID() && 1049 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
//					if(BeiBao.getInstance().isOpen)
//					{
//						BeiBao.getInstance().moveToTop();	
//					}
//					else
//					{
//						UIMovieClip.currentObjName=null;
//						BeiBao.getInstance().open();
//					}
					_w0=(m_windowList[1000] as UIWindow);
					_w1=(m_windowList[1047] as UIWindow);
					if (BeiBao.getInstance().isOpen)
					{
						_w2=(m_windowList[1001] as UIWindow);
						together([_w0, _w1, _w2]);
					}
					else
					{
//						together([_w0, _w1]);
					}
					break;
				case 1001: //包裹窗体         1001
					//并存窗体(角色、商店、仓库与包裹)
					//与包裹窗体并排并存
					_wd=(m_windowList[1000] as UIWindow);
					_wd2=(m_windowList[1001] as UIWindow);
					var _wd3:UIWindow=(m_windowList[1032] as UIWindow); // 兑换商店
					var _wd4:UIWindow=(m_windowList[1020] as UIWindow); // 仓库
					var _wd5:UIWindow=(m_windowList[1019] as UIWindow);
					var _wd6:UIWindow=(m_windowList[1080] as UIWindow);
					var _wd7:UIWindow=(m_windowList[1071] as UIWindow);
					var _wd8:UIWindow=(m_windowList[1087] as UIWindow);
					if (_wd && _wd.isOpen)
					{
						_w0=(m_windowList[1000] as UIWindow);
						_w1=(m_windowList[1047] as UIWindow);
						_w2=(m_windowList[1001] as UIWindow);
						together([_w0, _w1, _w2]);
					}
					else if (_wd3 && _wd3.isOpen)
					{
						together([_wd3, _wd2]);
					}
					else if (_wd4 && _wd4.isOpen)
					{
						together([_wd4, _wd2]);
					}
					else if (_wd5 && _wd5.isOpen)
					{
						together([_wd5, _wd2]);
					}
					else if (_wd6 && _wd6.isOpen)
					{
						together([_wd6, _wd2]);
					}
					else if (_wd7 && _wd7.isOpen)
					{
						together([_wd7, _wd2]);
					}
					else if (_wd8 && _wd8.isOpen)
					{
						together([_wd8, _wd2]);
					}
//					_w0 = (m_windowList[1001] as UIWindow);
//					_w1 = (m_windowList[1001] as UIWindow);
//					if(_w0 && _w1 && _w0.isOpen && _w1.isOpen)
//					{
//						together([_w0, _w1]);
//					}
					break;
				case 1002: //技能窗体         1002
					for each (_wd in m_windowList)
					{
						if (1002 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1003: //伙伴窗体         1003
					for each (_wd in m_windowList)
					{
						if (1003 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
//					if(BeiBao.getInstance().isOpen)
//					{
//						BeiBao.getInstance().moveToTop();	
//					}
//					else
//					{
//						UIMovieClip.currentObjName=null;
//						BeiBao.getInstance().open();
//					}
					//与包裹窗体并排并存
//					_wd = (m_windowList[1003] as UIWindow);
//					_wd2 = (m_windowList[1001] as UIWindow);
//					together([_wd,_wd2]);
					break;
				case 1004: //星魂窗体         1004
					for each (_wd in m_windowList)
					{
						if (1004 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 1005 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1005: //星魂包裹         1005
					for each (_wd in m_windowList)
					{
						if (1005 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 1004 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1006: //境界窗体         1006
					for each (_wd in m_windowList)
					{
						if (1006 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1007: //任务窗体         1007
					for each (_wd in m_windowList)
					{
						if (1007 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1008: //成就窗体         1008
					for each (_wd in m_windowList)
					{
						if (1008 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1009: //好友窗体         1009
					break;
				case 1010: //帮派窗体         1010
					for each (_wd in m_windowList)
					{
						if (1010 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1011: // 组队窗体         1011
					for each (_wd in m_windowList)
					{
						if (1011 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1012: //炼丹炉             1012
					for each (_wd in m_windowList)
					{
						if (1012 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 1015 != _wd.getID() && 1006 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					_wd=(m_windowList[1015] as UIWindow);
					_wd2=(m_windowList[1012] as UIWindow);
					together([_wd, _wd2]);
					break;
				case 1013: //阵营窗体         1013
					for each (_wd in m_windowList)
					{
						if (1013 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1014: //强化窗体         1014
					for each (_wd in m_windowList)
					{
						if (1014 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1015: // 重铸窗体         1015
					for each (_wd in m_windowList)
					{
						if (1015 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 1012 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					_wd=(m_windowList[1015] as UIWindow);
					_wd2=(m_windowList[1012] as UIWindow);
					together([_wd, _wd2]);
					break;
				case 1016: //活动窗体         1016
					for each (_wd in m_windowList)
					{
						if (1016 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1017: //帮助窗体         1017
//					for each( _wd in m_windowList) 
//					{ 
//						if(1017 !=  _wd.getID()  &&
//							1001 !=  _wd.getID() &&
//							1009 !=  _wd.getID() &&
//							0 !=  _wd.getID() )
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					break;
				case 1018: //炼制窗体         1018
					for each (_wd in m_windowList)
					{
						if (1018 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1019: //商店
//					for each( _wd in m_windowList) 
//					{ 
//						if(1019 !=  _wd.getID()  &&
//							1001 !=  _wd.getID() &&
//							1009 !=  _wd.getID() &&
//							1033 !=  _wd.getID() &&
//							1034 !=  _wd.getID() &&
//							1035 !=  _wd.getID() &&
//							0 !=  _wd.getID() )
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					if (BeiBao.getInstance().isOpen)
					{
						BeiBao.getInstance().moveToTop();
					}
					else
					{
						UIMovieClip.currentObjName=null;
						BeiBao.getInstance().open();
					}
//					if (ZhiZunHotSale.getInstance().isOpen)
//					{
//						ZhiZunHotSale.getInstance().moveToTop();
//					}
//					else
//					{
//						ZhiZunHotSale.getInstance().open();
//						
//					}
					//与包裹窗体并排并存
					_w0=(m_windowList[1019] as UIWindow);
					_wd=(m_windowList[1001] as UIWindow);
					_wd2=(m_windowList[1064] as UIWindow);
					together([_w0, _wd, _wd2]);
					break;
				case 1020: // 仓库窗体         1020
					for each (_wd in m_windowList)
					{
						if (1020 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID() && 1087 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					if (BeiBao.getInstance().isOpen)
					{
						BeiBao.getInstance().moveToTop();
					}
					else
					{
						UIMovieClip.currentObjName=null;
						BeiBao.getInstance().open();
					}
					//与包裹窗体并排并存
					_wd=(m_windowList[1020] as UIWindow);
					_wd2=(m_windowList[1001] as UIWindow);
					_w3=(m_windowList[1064] as UIWindow); //至尊特权
					together([_wd, _wd2, _w3]);
					break;
				case 1021: //挂机
					for each (_wd in m_windowList)
					{
						if (1021 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1024: //排行榜窗体     1024
					for each (_wd in m_windowList)
					{
						if (1024 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1025: // 系统设置窗体 1025
					for each (_wd in m_windowList)
					{
						if (1025 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1027: // GM邮箱窗体    1027
					for each (_wd in m_windowList)
					{
						if (1027 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1028: //地图窗体         1028
					for each (_wd in m_windowList)
					{
						if (1028 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1029: //聚英阁楼         1029
					for each (_wd in m_windowList)
					{
						if (1029 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1033:
					for each (_wd in m_windowList)
					{
						if (1033 != _wd.getID() && 1001 != _wd.getID() && 1009 != _wd.getID() && 1034 != _wd.getID() && 1052 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
//					if (MoWenZhuangBeiWindow.getInstance().isOpen)
//					{
//						MoWenZhuangBeiWindow.getInstance().moveToTop();
//					}
//					else
//					{
//						UIMovieClip.currentObjName=null;
//						MoWenZhuangBeiWindow.getInstance().open();
//					}
//					if(MoWenHotSale.getInstance().isOpen)
//					{
//						MoWenHotSale.getInstance().moveToTop();
//					}
//					else
//					{
//						UIMovieClip.currentObjName=null;
//						MoWenHotSale.getInstance().open();
//					}
//					if(MoWenCailiaoDesc.instance().isOpen)
//					{
//						MoWenCailiaoDesc.instance().moveToTop();	
//					}
//					else
//					{
//						UIMovieClip.currentObjName=null;
//						MoWenCailiaoDesc.instance().open();
//					}
					//与包裹窗体并排并存
//					_w0 = (m_windowList[1052] as UIWindow);
//					_wd = (m_windowList[1033] as UIWindow);
//					together([_w0,_wd,_wd2]);
					break;
				case 1034:
//					for each( _wd in m_windowList) 
//					{ 
//						if(1034 !=  _wd.getID()  &&
//							1001 !=  _wd.getID() &&
//							1009 !=  _wd.getID() &&
//							1033 !=  _wd.getID() &&
//							0 !=  _wd.getID() )
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					break;
				case 1035:
//					for each( _wd in m_windowList) 
//					{ 
//						if(1035 !=  _wd.getID()  &&
//							1001 !=  _wd.getID() &&
//							1009 !=  _wd.getID() &&
//							1033 !=  _wd.getID() &&
//							0 !=  _wd.getID() )
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					break;
				case 1036:
					for each (_wd in m_windowList)
					{
						if (1036 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1038:
					for each (_wd in m_windowList)
					{
						if (1038 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1039:
					for each (_wd in m_windowList)
					{
						if (1039 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					if (!SmartImplementTopList.getInstance().isOpen)
					{
						SmartImplementTopList.getInstance().open(true);
					}
					_w0=(m_windowList[1046] as UIWindow);
					_w1=(m_windowList[1039] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1040:
					for each (_wd in m_windowList)
					{
						if (1040 != _wd.getID() && 0 != _wd.getID() && 1060 != _wd.getID())
						{
							if (null != _wd && _wd.isOpen)
							{
								_wd.winClose();
							}
						}
					}
					break;
				case 1041:
//					for each( _wd in m_windowList) 
//					{ 
//						if( 1012 !=  _wd.getID() &&
//							1041 !=  _wd.getID() &&
//							0 !=  _wd.getID())
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					_wd=(m_windowList[1041] as UIWindow);
					_wd2=(m_windowList[1012] as UIWindow);
					together([_wd, _wd2]);
					break;
				case 1042:
//					for each( _wd in m_windowList) 
//					{ 
//						if( 1012 !=  _wd.getID() &&
//							1042 !=  _wd.getID() &&
//							0 !=  _wd.getID())
//						{
//							if(null != _wd && _wd.isOpen)
//							{
//								_wd.winClose();
//							}
//						}
//					}
					_wd=(m_windowList[1042] as UIWindow);
					_wd2=(m_windowList[1012] as UIWindow);
					together([_wd, _wd2]);
					break;
				case 1044:
					_wd=(m_windowList[1044] as UIWindow);
					_wd2=(m_windowList[1043] as UIWindow);
					together([_wd, _wd2]);
					break;
//				case 1045:
//					_w0 = (m_windowList[1045] as UIWindow);
//					_w1 = (m_windowList[1033] as UIWindow);
//					_w2 = (m_windowList[1034] as UIWindow);
//					
//					together([_w0,_w1,_w2]);
//					break;
				case 1047:
					_w0=(m_windowList[1000] as UIWindow);
					_w1=(m_windowList[1047] as UIWindow);
					if (BeiBao.getInstance().isOpen)
					{
						_w2=(m_windowList[1001] as UIWindow);
						together([_w0, _w1, _w2]);
					}
					else
					{
						together([_w0, _w1]);
					}
					break;
				case 1048:
					_wd=(m_windowList[1038] as UIWindow);
					_wd2=(m_windowList[1048] as UIWindow);
					together([_wd, _wd2]);
					break;
				case 1050:
					_w0=(m_windowList[1049] as UIWindow);
					_w1=(m_windowList[1050] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1051:
					_w0=(m_windowList[1051] as UIWindow);
					_w1=(m_windowList[1012] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1054:
					_w0=(m_windowList[1054] as UIWindow);
					_w1=(m_windowList[1055] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1056:
					_w0=(m_windowList[1057] as UIWindow);
					_w1=(m_windowList[1056] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1059:
					_w0=(m_windowList[1058] as UIWindow);
					_w1=(m_windowList[1059] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1060:
					_w0=(m_windowList[1071] as UIWindow);
					_w1=(m_windowList[1060] as UIWindow);
					_w2=(m_windowList[1001] as UIWindow);
//					_w3 = (m_windowList[1020] as UIWindow);
//					if(null != _w3 && _w3.isOpen)
//					{
//						_w3.winClose();
//					}
					together([_w0, _w1, _w2]);
					break;
				case 1062:
					_w0=(m_windowList[1062] as UIWindow);
					_w1=(m_windowList[1061] as UIWindow);
					_w2=(m_windowList[1065] as UIWindow);
					together([_w0, _w1, _w2]);
					break;
				case 1064:
					_w0=null; //(m_windowList[1001] as UIWindow); //背包
					_w1=(m_windowList[1065] as UIWindow); //VIP界面
					_w2=(m_windowList[1066] as UIWindow); //充值
					_w3=(m_windowList[1064] as UIWindow); //至尊特权
					_w4=(m_windowList[1019] as UIWindow); //NPC 商店
					_w5=(m_windowList[1072] as UIWindow);
					_w6=(m_windowList[1079] as UIWindow); //装备分解
					_w7=(m_windowList[1020] as UIWindow); //仓库
					_w8=(m_windowList[1080] as UIWindow); //仓库
					if (null != _w0 && _w0.isOpen && null != _w4 && _w4.isOpen)
					{
						together([_w4, _w0, _w3]);
					}
					else if (null != _w0 && _w0.isOpen && null != _w7 && _w7.isOpen)
					{
						together([_w7, _w0, _w3]);
					}
					else if (null != _w6 && _w6.isOpen && null != _w0 && _w0.isOpen)
					{
						together([_w6, _w0, _w3]);
					}
					else if (null != _w8 && _w8.isOpen && null != _w0 && _w0.isOpen)
					{
						together([_w8, _w0, _w3]);
					}
					else if (null != _w0 && _w0.isOpen)
					{
						together([_w0, _w3]);
					}
					else if (null != _w1 && _w1.isOpen)
					{
						together([_w1, _w3]);
					}
					else if (null != _w2 && _w2.isOpen)
					{
						together([_w2, _w3]);
					}
					else if (null != _w5 && _w5.isOpen)
					{
						together([_w5, _w3]);
					}
					break;
				case 1065:
					_w0=(m_windowList[1062] as UIWindow);
					_w1=(m_windowList[1061] as UIWindow);
					_w2=(m_windowList[1065] as UIWindow);
					together([_w0, _w1, _w2]);
					break;
				case 1066:
					//_w0=(m_windowList[1062] as UIWindow);
					_w1=(m_windowList[1061] as UIWindow);
					//_w2=(m_windowList[1065] as UIWindow);
					_w3=(m_windowList[1066] as UIWindow);
					together([_w1, _w3]);
					break;
				case 1069:
					_w0=(m_windowList[1068] as UIWindow);
					_w1=(m_windowList[1069] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1070:
					_w0=(m_windowList[1061] as UIWindow);
					_w1=(m_windowList[1070] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1071:
					_w0=(m_windowList[1071] as UIWindow);
					_w1=(m_windowList[1060] as UIWindow);
					_w2=(m_windowList[1001] as UIWindow);
					//					_w3 = (m_windowList[1020] as UIWindow);
					//					if(null != _w3 && _w3.isOpen)
					//					{
					//						_w3.winClose();
					//					}
					together([_w0, _w1, _w2]);
				case 1073:
					_w0=(m_windowList[1000] as UIWindow);
					_w1=(m_windowList[1076] as UIWindow);
					_w2=(m_windowList[1073] as UIWindow);
					_w3=(m_windowList[1075] as UIWindow);
					_wd=m_windowList[1076];
					if (null != _wd)
					{
						_wd.winClose();
					}
					together([_w0, _w3, _w2]);
					break;
				case 1074:
					_w0=(m_windowList[1061] as UIWindow);
					_w1=(m_windowList[1074] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1075:
//					_wd=m_windowList[1073];
//					if (null != _wd)
//					{
//						_wd.winClose();
//					}
					break;
				case 1076:
					_w0=(m_windowList[1075] as UIWindow);
					_w1=(m_windowList[1076] as UIWindow);
					_w2=(m_windowList[1073] as UIWindow);
					_wd=m_windowList[1073];
					if (null != _wd)
					{
						_wd.winClose();
					}
					together([_w0, _w1]);
					break;
				case 1078:
					_w0=(m_windowList[1077] as UIWindow);
					_w1=(m_windowList[1078] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1079:
					_w0=(m_windowList[1079] as UIWindow);
					_w1=(m_windowList[1001] as UIWindow);
					_w2=(m_windowList[1064] as UIWindow);
					together([_w0, _w1, _w2]);
					break;
				case 1082:
					_w0=(m_windowList[1081] as UIWindow);
					_w1=(m_windowList[1082] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1084:
					_w0=(m_windowList[1083] as UIWindow);
					_w1=(m_windowList[1084] as UIWindow);
					together([_w0, _w1]);
					break;
				case 1086:
					_w0=(m_windowList[1085] as UIWindow);
					_w2=(m_windowList[1001] as UIWindow);
					_w1=(m_windowList[1086] as UIWindow);
					together([_w0, _w2, _w1]);
					break;
				case 1087:
					_w1=(m_windowList[1087] as UIWindow);
					_w2=(m_windowList[1001] as UIWindow);
					together([_w1, _w2]);
					break;
				case 1091:
					_w0=(m_windowList[1090] as UIWindow);
					_w2=(m_windowList[1091] as UIWindow);
					together([_w0, _w2]);
					break;
				default:
					break;
			}
		}

		/**
		 *
		 * @param id
		 *
		 */
		private function _handleRemove(id:int):void
		{
			var _wd:UIWindow=null;
			var _wd2:UIWindow=null; //相关窗口
			switch (id)
			{
				case 1000: // 角色窗体
					_wd=m_windowList[1001];
					if (null != _wd && _wd.isOpen)
					{
						_wd.winClose();
					}
					break;
				case 1003:
					_wd=m_windowList[1001];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1019:
					_wd=m_windowList[1037];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1053];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1033:
					_wd=m_windowList[1034];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1035];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1052];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1012:
					_wd=m_windowList[1015];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1041];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1042];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1051];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1043:
					_wd=m_windowList[1044];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1039:
					_wd=m_windowList[1046];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1038:
					_wd=m_windowList[1048];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1055:
					_wd=m_windowList[1054];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1058:
					_wd=m_windowList[1059];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1061:
					_wd=m_windowList[1062];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1063];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1064];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1065];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1066];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1067];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1070];
					if (null != _wd)
					{
						_wd.winClose();
					}
					_wd=m_windowList[1074];
					if (null != _wd)
					{
						_wd.winClose();
					}
					break;
				case 1079:
				default:
					break;
			}
			//当前并排的窗口是否发生了变化
			var _isChangeCurrentTogether:Boolean=false;
			//当前关闭的窗口
			var _wdCurrentClose:UIWindow;
			var _wdAtTogetherList:UIWindow;
			_wdCurrentClose=m_windowList[id];
			if (null == _wdCurrentClose || _wdCurrentClose.getID() <= 0 || null == m_cTogetherList || m_cTogetherList.length <= 0)
			{
				return;
			}
			var _length:int=m_cTogetherList.length;
			for (var i:int=0; i < _length; ++i)
			{
				_wdAtTogetherList=m_cTogetherList[i] as UIWindow;
				if (null == _wdAtTogetherList)
				{
					continue;
				}
				if (_wdAtTogetherList.getID() == _wdCurrentClose.getID() || (!_wdAtTogetherList.isOpen))
				{
					m_cTogetherList[i]=null;
					delete m_cTogetherList[i];
					_isChangeCurrentTogether=true;
				}
			}
			if (_isChangeCurrentTogether)
			{
				together(m_cTogetherList);
			}
		}

		/**
		 * 同时并排打开窗口
		 * @param list
		 *
		 */
		public function together(list:Array):void
		{
			m_cTogetherList=list;
			if (null == list || list.length <= 1)
			{
				return;
			}
			var _startY:int=0;
			var _tempStartY:int=0;
			var _stageW:int;
			var _stageH:int;
			var _gap:int=-4; //窗口之间的间隙
			var _totalW:int=0; //总宽度
			var _wd:UIWindow=null;
			for (var i:int=0; i < list.length; ++i)
			{
				_wd=list[i];
				if (null != _wd)
				{
					if (!_wd.isOpen)
					{
						continue;
					}
					if (_stageW <= 0 && _stageH <= 0)
					{
						_stageW=_wd.stage.stageWidth;
						_stageH=_wd.stage.stageHeight;
					}
					_totalW+=_wd.getRealWidth() + _gap;
					_tempStartY=(_stageH - _wd.getRealHeight()) >> 1;
					//_tempStartY = (_stageH - _wd.height) >> 1;
					if (_startY <= 0 || _tempStartY < _startY)
					{
						_startY=_tempStartY;
					}
				}
			}
			_totalW=_totalW - _gap;
			var _startX:int=(_stageW - _totalW) >> 1;
			for (var n:int=0; n < list.length; ++n)
			{
				_wd=list[n];
				if (null != _wd)
				{
					if (!_wd.isOpen)
					{
						continue;
					}
					if (_startY <= 0)
					{
						_startY=(_stageH - _wd.getRealHeight()) >> 1;
							//_startY=(_stageH - _wd.height) >> 1;
					}
					_wd.moveTo(_startX, _startY);
					_startX+=_wd.getRealWidth() + _gap;
						//_startX+=_wd.width + _gap;
				}
			}
		}
		/************界面窗体加载中，请稍候 @andy 2012-05-16****************************/
		/**
		 *	窗体名字，统一管理，以后请大家写在这里
		 */
		private var mc_loading:MovieClip;
		private var WaitingName:String=null;
		private var waitingOpenFunc:Function=null;
		private var waitingOpenFunc2:Function=null;
		private var waitTime:int=0;

		public function preLoad(mcName:String):void
		{
//			var load:Object=Body.instance.sortLoadUI(WindowName.getFlaName(mcName));
		}
		private var _ldUi:Loadres;

		public function get ldUI():Loadres
		{
			if (null == _ldUi)
			{
				_ldUi=Loadres.getInstance().getItem;
			}
			return _ldUi;
		}

		public function sortLoadUI(swfName2:String):Loadres
		{
			if ("" == swfName2 || null == swfName2)
			{
				return null;
			}
			//info2自动加载，会调顺序
			if (ldUI.sort(swfName2))
			{
				return ldUI;
			}
			//info3手动触发加载
			var sUrl2:String=FileManager.instance.getUI(swfName2);
			var sArr2:Array=[sUrl2];
			var ld:Loadres=Loadres.getInstance().getItem;
			ld.loading_remain3();
			ld.load(sArr2);
			return ld;
		}

		/**
		 *
		 */
		public function setWaiting(mcName:String, func:Function):void
		{
			if (mc_loading == null)
				mc_loading=GamelibS.getswflink("game_utils", "win_waiting") as MovieClip;
			if (PubData.AlertUI != null && mc_loading != null)
			{
				//如果没有打开，则该界面优先级提高
				var load:Object=sortLoadUI(WindowName.getFlaName(mcName));
				//2013-03-11 andy 防止同时打开两个窗体在同一个fla文件
				waitingOpenFunc2=null;
				if (WindowName.getFlaName(mcName) == WindowName.getFlaName(WaitingName))
				{
					waitingOpenFunc2=func;
					return;
				}
				if (load != null && mc_loading.parent == null)
				{
					WaitingName=mcName;
					waitingOpenFunc=func;
					waitTime=0;
					mc_loading["txt_percent"].text="0%";
					mc_loading.gotoAndStop(1);
					(load as Loadres).addEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgress);
					GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, coolTime);
					GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND100, coolTime);
					PubData.AlertUI.addChild(mc_loading);
					mc_loading.x=(GameIni.MAP_SIZE_W - mc_loading.width) / 2;
//					mc_loading.y=(GameIni.MAP_SIZE_H - mc_loading.height) / 2;
					mc_loading.y=GameIni.MAP_SIZE_H - mc_loading.height * 2;
				}
			}
		}

		/**
		 *	定时检测，窗体是否已经加载成功
		 *  延时加载给予30秒时间，超过30秒放弃等待加载
		 */
		private function coolTime(we:WorldEvent=null):void
		{
			waitTime++;
			if (GamelibS.isApplicationClass(WaitingName) || waitTime == 300)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, coolTime);
				if (mc_loading != null && mc_loading.parent != null)
					PubData.AlertUI.removeChild(mc_loading);
				if (waitingOpenFunc != null)
				{
					waitingOpenFunc();
				}
				if (waitingOpenFunc2 != null)
				{
					waitingOpenFunc2();
				}
			}
		}

		private function loadProgress(e:DispatchEvent):void
		{
			if (mc_loading != null)
			{
				var percent:int=e.getInfo[0];
				mc_loading["txt_percent"].text=percent + "%";
				mc_loading.gotoAndStop(percent);
				if (percent >= 100)
				{
					coolTime();
					(e.target as Loadres).removeEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgress);
				}
			}
			else
			{
			}
		}
	}
}
