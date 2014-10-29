package ui.view.gerenpaiwei
{
	
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import display.components.CmbArrange;
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.gerenpaiwei.GRPW_Event;
	import model.gerenpaiwei.GRPW_Model;
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructSHGroupMemberInfo2;
	import netc.packets2.StructSHJoinInfo2;
	import netc.packets2.StructSHRankInfo2;
	import netc.packets2.StructSHTotalUserInfo2;
	
	import nets.packets.PacketCSRoleChangeMap;
	
	import scene.manager.SceneManager;
	
	import ui.base.beibao.BeiBao;
	import ui.base.npc.NpcShop;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.view.view2.other.ControlButton;
	import ui.view.view6.GameAlert;
	
	import world.FileManager;
	
	/**
	 * 个人排位赛  顶级竞技赛事  今日战况 战报信息
	 * 
	 * @author steven guo
	 * 
	 */	
	public class GRPW_P_1
	{
		
		
		private var m_ui_0:* = null;
		private var m_ui_1:* = null;
		
		private var m_prizeSmallPanel:* = null;
		
		private var m_idx:int = 0;
		
		private var m_model:GRPW_Model = null;
		
		//滚动条
		//private var m_sp1_p_1_0:* = null;
		
		public function GRPW_P_1(ui_0:*,ui_1:*,prizeSmallPanel:*)
		{
			m_ui_0 = ui_0;
			//m_ui_0['cb_zuidui_0'].selected = true;
			m_ui_1 = ui_1;
			//m_sp1_p_1_0 = sp1_p_1_0;
			m_prizeSmallPanel = prizeSmallPanel;
			m_model = GRPW_Model.getInstance();
		}
		
		
		private var m_alert:GameAlert = null;
		
		public function mcHandler(target:Object):void
		{
			var target_name:String = target.name;
			
			var __ui:* = _getUI();
			
			if( target_name.indexOf('jingJiSai_lingqu_')>=0)
			{
				var t:int = int(target_name.replace('jingJiSai_lingqu_',''));
				m_model.requestCSGetSHPrize(t+1);
			}else if(target_name.indexOf('paiweisai_lingqu_')>=0)
			{
				var td:int = int(target_name.replace('paiweisai_lingqu_',''));
				m_model.requestCSGetSHPrize(td+1);
			}
			
			switch(target_name)
			{
				case "btnAddTimes":
					
					if(null == m_alert)
					{
						m_alert = new GameAlert();
					}
					
					m_alert.ShowMsg(Lang.getLabel("40097_GRPW_add_tiaozhan_num"),4,null,
						function(param:int=1):void
						{
							if(param == 1)
							{
								m_model.requestCSAddFightCount();
							}
						}
						
					);
					
					
					break;
				case "hot_cb_zuidui_0":
					__ui['cb_zuidui_0'].selected = !__ui['cb_zuidui_0'].selected;
					_onCb_zuidui();
					break;
				case "hot_cb_zuidui_1":
					__ui['cb_zuidui_1'].selected = !__ui['cb_zuidui_1'].selected;
					_onCb_zuidui();
					break;
				case "hot_cb_zuidui_2":
					__ui['cb_zuidui_2'].selected = !__ui['cb_zuidui_2'].selected;
					_onCb_zuidui();
					break;
				case "cbox_zhanbao_all":
					__ui['cbox_zhanbao_all'].selected = true ;
					__ui['cbox_zhanbao_self'].selected = false;
					_repaint_zhanbao();
					break;
				case "cbox_zhanbao_self":
					__ui['cbox_zhanbao_self'].selected = true ;
					__ui['cbox_zhanbao_all'].selected = false;
					_repaint_zhanbao();
					break;
				case "btn_ls":  //每日连胜奖
					//					m_model.requestCSGetSHPrize(1);
					break;
				case "btn_mrcy":  //每日参与奖
					//					m_model.requestCSGetSHPrize(2);
					break;
				case "jingjisai_tuichu":  //退出队伍
					m_model.requestCSQuitSH();
					break;
				case "jingjisai_baoming":  //报名参加
					m_model.requestCSSignSH();
					break;
				case "btn_jjcy":  //积极参与奖
					//					m_model.requestCSGetSHPrize(3);
					break;
				default:
					
					//					else if((target as DisplayObject).parent.name ==  "btn_mrcy")
					//					{
					//						m_model.requestCSGetSHPrize(2);
					//					}
					//					else if((target as DisplayObject).parent.name ==  "btn_jjcy")
					//					{
					//						m_model.requestCSGetSHPrize(3);
					//					}
					break;
			}
		}
		
		private function _onCb_zuidui():void
		{
			if(1 == _getIdx())
			{
				var __ui:* = _getUI();
			}
		}
		
		
		/**0 非活动时间 1活动时间 */
		private function _getIdx():int
		{
			//m_idx = ControlButton.getInstance().getData("arrGeRenPaiWei");
			m_idx = m_model.getState();
			return m_idx;
		}
		
		
		public function set visible(b:Boolean):void
		{
			
			//m_idx = 1;
			
			//活动进行中...
			if(1 == _getIdx())
			{
				m_ui_0.visible = b;
				m_ui_1.visible = false;
			}
				//活动未开启
			else
			{
				m_ui_0.visible = false;
				m_ui_1.visible = b;
			}
			
			if(b)
			{
				_init();
			}
			
		}
		
		private function _getUI():*
		{
			var __ui:* = null;
			if(1 == _getIdx())
			{
				__ui = m_ui_0;
			}
			else
			{
				__ui = m_ui_1;
			}
			
			return __ui;
		}
		
		private function _processEvent(e:GRPW_Event):void
		{
			
			var _sort:int = e.sort;
			
			var __ui:* = _getUI();
			
			switch(_sort)
			{
				case GRPW_Event.GRPW_EVENT_SORT_SHRank:
					__ui["tf_selfNo"].text = m_model.getSelfNo();
					if(0 == _getIdx()){
						_repaint_SHRank();
					}else{
						__ui['cbox_zhanbao_all'].selected = true ;
					}
					break;
				case GRPW_Event.GRPW_EVENT_SORT_FIGHT_COUNT:
					_repaint_remainder();
					break;
				case GRPW_Event.GRPW_EVENT_SORT_TODAY:
					_repaint_today();
					break;
				case GRPW_Event.GRPW_EVENT_SORT_ZHANBAO_SELF:
					if(1 == _getIdx())
					{
						if(!__ui['cbox_zhanbao_all'].selected)
						{
							_repaint_zhanbao();
						}
					}
					break;
				case GRPW_Event.GRPW_EVENT_SORT_ZHANBAO_ALL:
					if(1 == _getIdx())
					{
						
						if(__ui['cbox_zhanbao_all'].selected)
						{
							_repaint_zhanbao();
						}
					}
					break;
				case GRPW_Event.GRPW_EVENT_SORT_PRIZE:
					if(1 != _getIdx())
					{
						_repaint_prizes();
					}
					
					_repaintPrizeSmallPanel();
					break;
				case GRPW_Event.GRPW_EVENT_SORT_DUI_WU:
					if(1 == _getIdx()&&m_model.isBaoMing)
					{
						//						__ui["canzhan_tuichu"].gotoAndStop(1); 
						_repaint_DuiWu();
					}
					break;
				case GRPW_Event.GRPW_EVENT_SORT_AllRank:
					_data_duanwei =-1;
					_data_zhiye =-1;
					_repaint_page_p_1_1();
					break;
				case GRPW_Event.GRPW_EVENT_SORT_FIGHT_Rank:
					if(1 == _getIdx())
					{
						//						_repaint_sp1_p_1_0();
					}
					break;
				case GRPW_Event.GRPW_EVENT_SORT_IS_CANSAI:
					if(1 == _getIdx())
					{
						setCanZhanDuiWu();
					}
					break;
				default:
					break;
			}
		}
		/**
		 *s设置参赛队伍 组队 2帧页面 
		 * 
		 */
		private function setCanZhanDuiWu():void
		{
			var __ui:* = _getUI();
			if(m_model.isBaoMing)
			{
				__ui["canzhan_tuichu"].gotoAndStop(1); 
				m_model.requestCSGetSHGroupInfo();//获得个人赛队伍数据-
			}else{
				__ui["canzhan_tuichu"].gotoAndStop(2);
				
			}
		}
		private function _init():void
		{
			m_model.addEventListener(GRPW_Event.GRPW_EVENT,_processEvent);
			
			//			var _cmb_zhiye_0:CmbArrange = m_ui_0['mc_cmb_zhiye'] as CmbArrange;
			//			_cmb_zhiye_0.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_zhiye_0);
			//			_cmb_zhiye_0.addItems = [
			//				{label: Lang.getLabel("pub_quan_bu"), data: -1} ,
			//				{label: XmlRes.GetJobNameById(1), data: 0} ,
			//				{label: XmlRes.GetJobNameById(2), data: 1} , 
			//				{label: XmlRes.GetJobNameById(3), data: 2} 
			//			];
			var _cmb_zhiye_2:CmbArrange = m_ui_0['mc_cmb_zhiye'] as CmbArrange;
			_cmb_zhiye_2.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_zhiye_1);
			_cmb_zhiye_2.addItems = [
				{label: XmlRes.GetJobNameById(0), data: -1} ,
				{label: XmlRes.GetJobNameById(1), data: 1} , 
				{label: XmlRes.GetJobNameById(3), data: 3} ,
				{label: XmlRes.GetJobNameById(4), data: 4} ,
				{label: XmlRes.GetJobNameById(6), data: 6} 
			];
			
			var _cmb_zhiye_1:CmbArrange = m_ui_1['mc_cmb_zhiye'] as CmbArrange;
			_cmb_zhiye_1.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_zhiye_1);
			_cmb_zhiye_1.addItems = [
				{label: XmlRes.GetJobNameById(0), data: -1} ,
				{label: XmlRes.GetJobNameById(1), data: 1} , 
				{label: XmlRes.GetJobNameById(3), data: 3} ,
				{label: XmlRes.GetJobNameById(4), data: 4} ,
				{label: XmlRes.GetJobNameById(6), data: 6}   
			];
			
			//			var _cmb_duanwei_0:CmbArrange = m_ui_0['mc_cmb_duanwei'] as CmbArrange;
			//			_cmb_duanwei_0.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_duanwei_0);
			//			_cmb_duanwei_0.addItems = [
			//				{label: Lang.getLabel("pub_quan_bu"), data: -1} ,
			//				{label: Lang.getLabelArr("arrGRPW_DuanWei")[0], data: 0} ,
			//				{label: Lang.getLabelArr("arrGRPW_DuanWei")[1], data: 1} , 
			//				{label: Lang.getLabelArr("arrGRPW_DuanWei")[2], data: 2} ,
			//				{label: Lang.getLabelArr("arrGRPW_DuanWei")[3], data: 3} 
			//			];
			var _cmb_duanwei_2:CmbArrange = m_ui_0['mc_cmb_duanwei'] as CmbArrange;
			_cmb_duanwei_2.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_duanwei_1);  
			_cmb_duanwei_2.addItems = [
				{label: "  "+Lang.getLabel("pub_duan_wei"), data: -1} ,
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[0], data: 0} ,
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[1], data: 1} , 
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[2], data: 2} ,
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[3], data: 3}      
			];
			var _cmb_duanwei_1:CmbArrange = m_ui_1['mc_cmb_duanwei'] as CmbArrange;
			_cmb_duanwei_1.addEventListener(DispatchEvent.EVENT_COMB_CLICK,_cmbClickHandler_duanwei_1);  
			_cmb_duanwei_1.addItems = [
				{label: "  "+Lang.getLabel("pub_duan_wei"), data: -1} ,
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[0], data: 0} ,
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[1], data: 1} , 
				{label: "  "+Lang.getLabelArr("arrGRPW_DuanWei")[2], data: 2} ,
				{label:"  "+ Lang.getLabelArr("arrGRPW_DuanWei")[3], data: 3}      
			];
			
			//向服务器请求数据
			
			m_model.requestCSGetSignSH();     //-是否报名-
			m_model.requestCSGetSHRank();     	//-  个人赛排名情况
			m_model.requestCSGetSHFightCount();	//获得个人赛比赛次数
			m_model.requestCSGetNowSH();//今日个人赛比赛结果
			m_model.requestCSGetSHPrizeInfo();//获得个人赛比赛奖励信息  
//			m_model.requestCSGetSHPrizeInfo();
			m_model.requestCSGetSHAllRank();//获得个人赛比赛排名数据
			if(1 != _getIdx())
			{
				
			}
			else
			{
				
				m_model.requestCSGetSHJoinList();//活动开始
				
			}
			
			
			_onCb_zuidui();
			_repaint_zhanbao();
			
			
			var __ui:* = _getUI();
			
			__ui["guize_txt"].htmlText = Lang.getLabel("40097_arrGRPW_Action_Desc_guize0");
			__ui["guize_txt"].height =	__ui["guize_txt"].textHeight + 10;    
			__ui["guize_slider"].source = __ui["guize_txt"];
			
			if(1 != _getIdx())
			{
				
				for(var i:int = 0 ; i < page_num; ++i)
				{
					__ui['item_'+i]['tf_paiming'].text = "";
					__ui['item_'+i]['tf_name'].text = "";
					__ui['item_'+i]['tf_level'].text = "";
					__ui['item_'+i]['tf_zhiwu'].text = "";
					__ui['item_'+i]['tf_jifen'].text = "";
					__ui['item_'+i]['tf_duanwei'].text = "";
					
					__ui['item_'+i]['mcQQYellowDiamond'].visible = false;
				}
			}
			else
			{
				setCanZhanDuiWu();
				
			}
			
			
			
			
			
		}
		
		/*
		private function _cmbClickHandler_zhiye_0(e:DispatchEvent=null):void
		{
		var _cmb_zhiye_0:CmbArrange = m_ui_0['mc_cmb_zhiye'] as CmbArrange;
		var _data_0:* = _cmb_zhiye_0.curData;
		
		var _cmb_zhiye_1:CmbArrange = m_ui_0['mc_cmb_zhiye'] as CmbArrange;
		var _data_1:* = _cmb_zhiye_1.curData;
		
		_repaint_sp1_p_1_0(m_model.getArrItemjoinlistFilter(_data_0,_data_1));
		}
		
		
		
		private function _cmbClickHandler_duanwei_0(e:DispatchEvent=null):void
		{
		var _cmb_duanwei_0:CmbArrange = m_ui_0['mc_cmb_duanwei'] as CmbArrange;
		var _data_0:* = _cmb_duanwei_0.curData;
		
		var _cmb_duanwei_1:CmbArrange = m_ui_0['mc_cmb_duanwei'] as CmbArrange;
		var _data_1:* = _cmb_duanwei_1.curData;
		
		//向服务器发消息
		//m_model.requestCSGetSHAllRank(m_currPage,_data_0,_data_1);
		_repaint_page_p_1_1();
		}
		
		*/
		private function _cmbClickHandler_zhiye_1(e:DispatchEvent=null):void
		{
		
//						var _cmb_zhiye_0:CmbArrange = m_ui_1['mc_cmb_zhiye'] as CmbArrange;
//						var _data_0:* =	e.getInfo.data;;
//						
//						var _cmb_zhiye_1:CmbArrange = m_ui_1['mc_cmb_zhiye'] as CmbArrange;
//						var _data_1:* = 	e.getInfo.data;;
			_data_zhiye= e.getInfo.data;
			_repaint_page_p_1_1();
		}
		
		
		private function _cmbClickHandler_duanwei_1(e:DispatchEvent=null):void
		{
//						var _cmb_duanwei_0:CmbArrange = m_ui_1['mc_cmb_duanwei'] as CmbArrange;
//						var _data_0:* = _cmb_duanwei_0.curData;
//			//			
//						var _cmb_duanwei_1:CmbArrange = m_ui_1['mc_cmb_duanwei'] as CmbArrange;
//						var _data_1:* = _cmb_duanwei_1.curData;
			
			//向服务器发消息
			//m_model.requestCSGetSHAllRank(m_currPage,_data_0,_data_1);
			_data_duanwei = e.getInfo.data;
			_repaint_page_p_1_1();
		}
		
		//个人赛排名情况 第一帧
		private function _repaint_SHRank():void
		{
			var __ui:* = _getUI();
			
			var _arrItemrank_info:Vector.<StructSHRankInfo2> = m_model.getArrItemrank_info();
			var _info:StructSHRankInfo2 = null;
			
			for(var i:int = 0 ;i < 5 ; ++i)
			{
				if(i >= _arrItemrank_info.length)
				{
					//					__ui['SHRank_'+i].visible = false;
					__ui['SHRank_'+i]['headIcon']['uil'].source = null;
					__ui['SHRank_'+i]['tf_name'].text = "";
					__ui['SHRank_'+i]['tf_PaiMing'].text = "";
					__ui['SHRank_'+i]['dengji'].text = "";
					__ui['SHRank_'+i]['mcQQYellowDiamond'].visible = false;
				}
				else
				{
					_info = _arrItemrank_info[i];
					//					__ui['SHRank_'+i].visible = true;
//					__ui['SHRank_'+i]['headIcon']['uil'].source = FileManager.instance.getHeadIconSById(_info.icon);
					ImageUtils.replaceImage(__ui['SHRank_'+i]['headIcon'],__ui['SHRank_'+i]['headIcon']["uil"],FileManager.instance.getHeadIconSById(_info.icon));
					__ui['SHRank_'+i]['tf_name'].text = _info.name;
					__ui['SHRank_'+i]['tf_PaiMing'].text = _info.no;
					__ui['SHRank_'+i]['dengji'].text = _info.level;
					__ui['SHRank_'+i]['mcQQYellowDiamond'].visible = true;
					
					YellowDiamond.getInstance().handleYellowDiamondMC2(__ui['SHRank_'+i]['mcQQYellowDiamond'],_info.qqyellowvip);
				}
				
			}
			
			__ui["tf_selfNo"].text = m_model.getSelfNo();
		}
		private static const DUIWURS:int = 3;//队伍人数
		//队伍显示
		private function _repaint_DuiWu():void
		{
			var __ui:* = _getUI();
			var _arrItemrank_info:Vector.<StructSHGroupMemberInfo2> = m_model.duiwu;
			var _info:StructSHGroupMemberInfo2 = null;
			for(var i:int = 0 ;i < DUIWURS ; ++i)
			{
				if(i >= _arrItemrank_info.length)
				{
					__ui['canzhan_tuichu']['SHRank_'+i]['headIcon']['uil'].source = null;
					__ui['canzhan_tuichu']['SHRank_'+i]['tf_name'].text = "";
					__ui['canzhan_tuichu']['SHRank_'+i]['tf_PaiMing'].text = "";
					__ui['canzhan_tuichu']['SHRank_'+i]['dengji'].text = "";
					//					__ui['canzhan_tuichu']['SHRank_'+i]['metier'].text ="";
					__ui['canzhan_tuichu']['SHRank_'+i]['mcQQYellowDiamond'].visible = false;
				}
				else
				{
					_info = _arrItemrank_info[i];
//					__ui['canzhan_tuichu']['SHRank_'+i]['headIcon']['uil'].source = FileManager.instance.getHeadIconSById(_info.icon);
					ImageUtils.replaceImage(__ui['canzhan_tuichu']['SHRank_'+i]['headIcon'],__ui['canzhan_tuichu']['SHRank_'+i]['headIcon']["uil"],FileManager.instance.getHeadIconSById(_info.icon));
					__ui['canzhan_tuichu']['SHRank_'+i]['tf_name'].text = _info.name;
					__ui['canzhan_tuichu']['SHRank_'+i]['dengji'].text = _info.level;
					//					__ui['canzhan_tuichu']['SHRank_'+i]['metier'].text = _info.metier;
					__ui['canzhan_tuichu']['SHRank_'+i]['tf_PaiMing'].text = _info.no;
					__ui['canzhan_tuichu']['SHRank_'+i]['mcQQYellowDiamond'].visible = true;
					
						YellowDiamond.getInstance().handleYellowDiamondMC2(__ui['canzhan_tuichu']['SHRank_'+i]['mcQQYellowDiamond'],_info.qqyellowvip);
				}
				
			}
			
			__ui["tf_selfNo"].text = m_model.getSelfNo();
		}
		
		//今日还可挑战3次
		private function _repaint_remainder():void
		{
			var __ui:* = _getUI();
			__ui["tf_remainder_num"].text = Lang.getLabel("40096_remainder_num",[m_model.getRemainder()]);   
		}
		
		private function _repaint_today():void
		{
			var __ui:* = _getUI();
			
			//获胜
			__ui['tf_today_huosheng'].text = m_model.getWin();
			//战败
			__ui['tf_today_zhanbai'].text = m_model.getLost();
			//最高连胜
			__ui['tf_today_liansheng'].text = m_model.getWinMax();
			//称号(根据策划案子中的积分算出来)
			__ui['tf_today_chenghao'].text = m_model.getChengHao();
			//在获得 XX 积分 获得 XX 称号
			__ui['tf_today_chenghao_zai'].htmlText = m_model.getNeedCoin_NextLevel();
			//当前积分
			__ui['txt_wodejifen'].text = m_model.getCoin();
		}
		
		
		
		/**
		 * 战报信息 
		 * 
		 */		
		private function _repaint_zhanbao():void
		{
			if(1 != _getIdx())
			{
				return ;
			}
			
			
			var __ui:* = _getUI();
			
			__ui['tf_zhanbao'].htmlText = "";
			
			var _list:Vector.<String> = null ; //m_model.getSelfList();
			
			if(__ui['cbox_zhanbao_all'].selected)
			{
				_list = m_model.getAllList();
			}
			else
			{
				_list = m_model.getSelfList();
			}
			
			if(null == _list || _list.length <= 0)
			{
				return ;
			}
			
			var _str:String = "";
			
			for(var i:int = 0 ; i < _list.length ; ++i)
			{
				_str += _list[i] + "<br>";
			}
			
			__ui['tf_zhanbao'].htmlText = _str;
			__ui['tf_zhanbao'].scrollV = __ui['tf_zhanbao'].numLines;
		}
		
		private var mc_content_sp1_p_1_0:Sprite = null;
		
		//每页多少个条目
		private static const page_num_p_1_0:int = 15;
		//当前页
		private var m_currPage_p_1_0:int = 1;
		//一共多少页
		private var m_totalPage_p_1_0:int = 0;
		
		/**
		 * 个人赛参赛列表  (参赛过程中....) 
		 * 
		 */		
		private function _repaint_sp1_p_1_0(list:Vector.<StructSHJoinInfo2>=null):void
		{
			//			var __ui:* = _getUI();
			//			
			//			//列表内容容器
			//			if(null == mc_content_sp1_p_1_0)
			//			{
			//				mc_content_sp1_p_1_0 = new Sprite();
			//			}
			//			
			//			clearMC_content_sp1_p_1_0();
			//			
			//			var _list:Vector.<StructSHJoinInfo2> = list;//
			//			var _data:StructSHJoinInfo2 = null;
			//			var _sprite:*= null;
			//			for(var i:int = 0 ;i < _list.length ; ++i )
			//			{
			//				_sprite = ItemManager.instance().getGRPW_sp1_p_1_0_Item(i);
			//				_sprite.index = i;
			//				mc_content_sp1_p_1_0.addChild(_sprite);
			//				
			//				_data = _list[i];
			//				_sprite['tf_paiming'].text = i;
			//				_sprite['tf_name'].text = _data.name;
			//				_sprite['tf_level'].text = _data.level;
			//				_sprite['tf_zhiwu'].text = _data.metier;
			//				//_sprite['tf_jifen'].text = _data.
			//				_sprite['tf_duanwei'].text = m_model.conutDuanWei(100);
			//				
			//				
			//				YellowDiamond.getInstance().handleYellowDiamondMC2(_sprite['mcQQYellowDiamond'], _data.qqyellowvip);
			//			}
			//			
			//			
			//			CtrlFactory.getUIShow().showList2(mc_content_sp1_p_1_0, 1, 367, 18);    
			//			
			//			
			//			//__ui["sp_paiming"].source=mc_content_sp1_p_1_0;
			//			//__ui["sp_paiming"].position=0;
			//			mc_content_sp1_p_1_0.x=0;
			
			var __ui:* = _getUI();
			
			//m_currPage = m_model.getPage();
			
			var _list:Vector.<StructSHJoinInfo2> = m_model.getArrItemjoinlist(); //list;
			
			if(null == _list || _list.length <= 0)
			{
				m_currPage_p_1_0 = 0;
				m_totalPage_p_1_0 = 0;
			}
			else
			{
				if(m_currPage_p_1_0 <= 0)
				{
					m_currPage_p_1_0 = 1;
				}
				
				m_totalPage_p_1_0 = _list.length / page_num_p_1_0 + 1;
				
				if(m_currPage_p_1_0 > m_totalPage_p_1_0)
				{
					m_currPage_p_1_0 = m_totalPage_p_1_0;
				}
			}
			
			__ui["mc_page"].addEventListener(MoreLessPage.PAGE_CHANGE,_page_p_1_0);
			__ui["mc_page"].setMaxPage(m_currPage_p_1_0,m_totalPage_p_1_0);
			
		}
		
		
		//		private function clearMC_content_sp1_p_1_0():void
		//		{
		//			if (null != mc_content_sp1_p_1_0)
		//			{
		//				while (mc_content_sp1_p_1_0.numChildren > 0)
		//					mc_content_sp1_p_1_0.removeChildAt(0);
		//			}
		//		}
		//		
		
		/**
		 *参赛过程中 
		 * @param e
		 * 
		 */
		private function _page_p_1_0(e:DispatchEvent=null):void
		{
			m_currPage_p_1_0 = e.getInfo.count;
			
			var __ui:* = _getUI();
			
			var _list:Vector.<StructSHTotalUserInfo2> = m_model.getArrItemuserinfo(_data_zhiye,_data_duanwei);
//			var _list:Vector.<StructSHJoinInfo2> = m_model.getArrItemjoinlist();
			var _info:StructSHTotalUserInfo2 = null;
			var _ti:int = 0;
			
			for(var i:int = 0 ; i < page_num; ++i)
			{
				if(m_currPage_p_1_0 <= 0 )
				{
					__ui['item_'+i]['tf_paiming'].text = "";
					__ui['item_'+i]['tf_name'].text = "";
					__ui['item_'+i]['tf_level'].text = "";
					__ui['item_'+i]['tf_zhiwu'].text = "";
					__ui['item_'+i]['tf_jifen'].text = "";
					__ui['item_'+i]['tf_duanwei'].text = "";
					
					__ui['item_'+i]['mcQQYellowDiamond'].visible = false;
				}
				else
				{
					_ti = (m_currPage_p_1_0 - 1) * page_num + i;
					
					if(_ti >= _list.length)
					{
						__ui['item_'+i]['tf_paiming'].text = "";
						__ui['item_'+i]['tf_name'].text = "";
						__ui['item_'+i]['tf_level'].text = "";
						__ui['item_'+i]['tf_zhiwu'].text = "";
						__ui['item_'+i]['tf_jifen'].text = "";
						__ui['item_'+i]['tf_duanwei'].text = "";
						
						__ui['item_'+i]['mcQQYellowDiamond'].visible = false;
					}
					else
					{
						__ui['item_'+i]['tf_paiming'].text = _list[_ti].no + "";
						__ui['item_'+i]['tf_name'].text = _list[_ti].name;
						__ui['item_'+i]['tf_level'].text = _list[_ti].level;
						__ui['item_'+i]['tf_zhiwu'].text = XmlRes.GetJobNameById(_list[_ti].metier);
						__ui['item_'+i]['tf_jifen'].text = _list[_ti].coin;
						__ui['item_'+i]['tf_duanwei'].text = m_model.conutDuanWei( _list[_ti].coin );
						
						__ui['item_'+i]['mcQQYellowDiamond'].visible = true;
						YellowDiamond.getInstance().handleYellowDiamondMC2(__ui['item_'+i]['mcQQYellowDiamond'],_list[_ti].qqyellowvip);
					}
				}
			}
		}
		
		
		
		//每页多少个条目
		private static const page_num:int = 10;
		//当前页
		private var m_currPage:int = 1;
		//一共多少页
		private var m_totalPage:int = 0;
		
		//职业
		private var _data_zhiye:int = -1;
		//段位
		private var _data_duanwei:int = -1;
		
		/**
		 * 个人赛参赛列表  (非参赛过程中....) 
		 * 
		 */		
		private function _repaint_page_p_1_1():void
		{
			var __ui:* = _getUI();
			
			//m_currPage = m_model.getPage();
			//			if(0 == _getIdx())//1 活动开始  0 没有活动
			//			{
			var _cmb_zhiye:CmbArrange = m_ui_1['mc_cmb_zhiye'] as CmbArrange;
//			_data_zhiye = int(_cmb_zhiye.curData);
			
			var _cmb_duanwei:CmbArrange = m_ui_1['mc_cmb_duanwei'] as CmbArrange;
//			_data_duanwei = int( _cmb_duanwei.curData );
			
			
			
			
			var _list:Vector.<StructSHTotalUserInfo2> = m_model.getArrItemuserinfo(_data_zhiye,_data_duanwei);
			//			}
			if(null == _list || _list.length <= 0)
			{
				m_currPage = 0;
				m_totalPage = 0;
			}
			else
			{
				if(m_currPage <= 0)
				{
					m_currPage = 1;
				}
				
				m_totalPage = _list.length / page_num + 1;
				
				if(m_currPage > m_totalPage)
				{
					m_currPage = m_totalPage;
				}
			}
			
			__ui["mc_page"].addEventListener(MoreLessPage.PAGE_CHANGE,_page_p_1_1);
			__ui["mc_page"].setMaxPage(m_currPage,m_totalPage);
			
			//super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,changePage);
		}
		
		/**
		 *非活动页面 
		 * @param e
		 * 
		 */
		private function _page_p_1_1(e:DispatchEvent=null):void
		{
			m_currPage = e.getInfo.count;
			
			var __ui:* = _getUI();
			
			var _list:Vector.<StructSHTotalUserInfo2> = m_model.getArrItemuserinfo(_data_zhiye,_data_duanwei);
			var _info:StructSHTotalUserInfo2 = null;
			var _ti:int = 0;
			
			
			for(var i:int = 0 ; i < page_num; ++i)
			{
				if(m_currPage <= 0 )
				{
					__ui['item_'+i]['tf_paiming'].text = "";
					__ui['item_'+i]['tf_name'].text = "";
					__ui['item_'+i]['tf_level'].text = "";
					__ui['item_'+i]['tf_zhiwu'].text = "";
					__ui['item_'+i]['tf_jifen'].text = "";
					__ui['item_'+i]['tf_duanwei'].text = "";
					
					__ui['item_'+i]['mcQQYellowDiamond'].visible = false;
				}
				else
				{
					_ti = (m_currPage - 1) * page_num + i;
					
					if(_ti >= _list.length)
					{
						__ui['item_'+i]['tf_paiming'].text = "";
						__ui['item_'+i]['tf_name'].text = "";
						__ui['item_'+i]['tf_level'].text = "";
						__ui['item_'+i]['tf_zhiwu'].text = "";
						__ui['item_'+i]['tf_jifen'].text = "";
						__ui['item_'+i]['tf_duanwei'].text = "";
						
						__ui['item_'+i]['mcQQYellowDiamond'].visible = false;
					}
					else
					{
						__ui['item_'+i]['tf_paiming'].text = _list[_ti].no;
						__ui['item_'+i]['tf_name'].text = _list[_ti].name;
						__ui['item_'+i]['tf_level'].text = _list[_ti].level;
						__ui['item_'+i]['tf_zhiwu'].text = XmlRes.GetJobNameById(_list[_ti].metier);
						__ui['item_'+i]['tf_jifen'].text = _list[_ti].coin;
						__ui['item_'+i]['tf_duanwei'].text = m_model.conutDuanWei( _list[_ti].coin );
						__ui['item_'+i]['mcQQYellowDiamond'].visible = true;
						YellowDiamond.getInstance().handleYellowDiamondMC2(__ui['item_'+i]['mcQQYellowDiamond'],_list[_ti].qqyellowvip);
					}
				}
			}
			
			
		}
		
		/*
		
		
		60102501	每日连胜奖	
		60102502	每日参与奖	
		60102503	积极参与奖	
		
		策划部-贺云峰 10:37:56
		60101850	个人排位赛获胜奖	
		60101851	个人排位赛参与奖	
		60101852	个人排位赛累计参与奖
		
		*/
		
		//每日连胜奖励掉落ID
		//		private static const DROP_PRIZE_LS:int = 60101850;
		//每日参与奖励掉落ID
		//		private static const DROP_PRIZE_MRCY:int = 60101851;
		//积极参与奖励掉落ID
		//		private static const DROP_PRIZE_JJCY:int = 60101852;
		
		private static const prizeArrId:Array = [60102551,60102552,60102553,
			60102554,60102555,60102556,
			60102557,60102558,60102559];
		private static const _chagnciShengArr:Array = [5,10,30,10,30,50,5,20,30]
		/**
		 *设置奖励 左边
		 * 
		 */
		private function _repaint_prizes():void
		{
			
			var __ui:* = _getUI();
			for(var i:int =0;i<prizeArrId.length;i++){
				_repaint_prize(i,prizeArrId[i],"")
			}
			for(var k:int=0;k<_chagnciShengArr.length;k++)
			{
						var _bit:int = BitUtil.getBitByPos(m_model.m_prize,k+2);
						if(k<6){
							if(_bit==1){
								__ui["paiweisai_lingqu_"+k].visible = false;
								continue;
							}else{
								__ui["paiweisai_lingqu_"+k].visible = true;
							}
						}
				if(k==0||k==3){//今天胜利 次数
					__ui["changci_"+k].htmlText =String(m_model.today_win)+"/"+String( _chagnciShengArr[k]);
				
					if(m_model.today_win>= _chagnciShengArr[k])
					{
						StringUtils.setEnable(__ui["paiweisai_lingqu_"+k]);
					}else{
						StringUtils.setUnEnable(__ui["paiweisai_lingqu_"+k]);
					}
				}else if(k==1){//今天参加次数
					__ui["changci_"+k].htmlText =String(m_model.today_join)+"/"+String( _chagnciShengArr[k]);
					if(m_model.today_join>= _chagnciShengArr[k])
					{
						StringUtils.setEnable(__ui["paiweisai_lingqu_"+k]);
					}else{
						StringUtils.setUnEnable(__ui["paiweisai_lingqu_"+k]);
					}
				}else if(k==2){//本周参加次数
					__ui["changci_"+k].htmlText =String(m_model.cur_week_join)+"/"+String( _chagnciShengArr[k]);
					if(m_model.cur_week_join>= _chagnciShengArr[k])
					{
						StringUtils.setEnable(__ui["paiweisai_lingqu_"+k]);
					}else{
						StringUtils.setUnEnable(__ui["paiweisai_lingqu_"+k]);
					}
					
				}else if(k==5||k==4){//本周胜利次数
					__ui["changci_"+k].htmlText =String(m_model.cur_week_win)+"/"+String( _chagnciShengArr[k]);
					if(m_model.cur_week_win>= _chagnciShengArr[k])
					{
						StringUtils.setEnable(__ui["paiweisai_lingqu_"+k]);
					}else{
						StringUtils.setUnEnable(__ui["paiweisai_lingqu_"+k]);
					}
				}else{
					trace("chao chu suo yin fan wei")
				}
			}
			//			__ui['tf_prize_0'].htmlText = Lang.getLabel("40097_GRPW_prize_0",[m_model.num1]);
			//			__ui['tf_prize_1'].htmlText = Lang.getLabel("40097_GRPW_prize_1",[m_model.num2]);
			//			__ui['tf_prize_2'].htmlText = Lang.getLabel("40097_GRPW_prize_2",[m_model.num3]);
			
		}
		
		private function _repaint_prize(idx:int,dropID:int,uipanle:String):void
		{
			var _DropResModel:Pub_DropResModel = null;
			var _ToolsResModel:Pub_ToolsResModel = null;
			var _DropResModelList:Vector.<Pub_DropResModel> = null;
			var __ui:* = _getUI();
			var bag:StructBagCell2=new StructBagCell2();
			_DropResModelList = GameData.getDropXml().getResPath2(dropID) as Vector.<Pub_DropResModel>;
			
			if(null == _DropResModelList)
			{
				return ;
			}
			
			_DropResModel = null;
			_ToolsResModel = null;
			
			
			_DropResModel = _DropResModelList[0];
			if(null != _DropResModel)
			{
				_ToolsResModel = GameData.getToolsXml().getResPath(_DropResModel.drop_item_id) as Pub_ToolsResModel;
				//m_ui['item'+i]['r_num'].text = StringUtils.changeToTenThousand(_DropResModel.drop_num);
				//__item['txt_num'].text = "×"+StringUtils.changeToTenThousand(_DropResModel.drop_num);
				bag.itemid = _DropResModel.drop_item_id;
				bag.num = 1;
				Data.beiBao.fillCahceData(bag);
				if(uipanle == "mcPrizeSmallPanel"){
					if(m_prizeSmallPanel["pic_ls_"+idx]!=null){
						m_prizeSmallPanel["pic_ls_"+idx].data = bag;
//						m_prizeSmallPanel["pic_ls_"+idx]['uil'].source=bag.icon;
						ImageUtils.replaceImage(m_prizeSmallPanel["pic_ls_"+idx],m_prizeSmallPanel["pic_ls_"+idx]["uil"],bag.icon);
						CtrlFactory.getUIShow().addTip(m_prizeSmallPanel["pic_ls_"+idx]);
					}
				}else{
					if(__ui["pic_ls_"+idx]!=null){
						__ui["pic_ls_"+idx].data = bag;
//						__ui["pic_ls_"+idx]['uil'].source=bag.icon;
						ImageUtils.replaceImage(__ui["pic_ls_"+idx],__ui["pic_ls_"+idx]["uil"],bag.icon);
						CtrlFactory.getUIShow().addTip(__ui["pic_ls_"+idx]);
					}
				}
				
			}
			
			if(null != _ToolsResModel)
			{
				//	_addTip(__ui["pic_ls_"+idx],_ToolsResModel.tool_id);
			}
			else
			{
				//CtrlFactory.getUIShow().removeTip(__ui["pic_ls_"+idx]);
			}
			
			
		}
		
		
		/**
		 *右边的奖励界面 
		 * 
		 */
		private function _repaintPrizeSmallPanel():void
		{
			var __ui:* = _getUI();
			
			//
			if(1 != _getIdx())
			{
				m_prizeSmallPanel.visible = false;
			}
			else
			{
				m_prizeSmallPanel.visible = true;
				for(var i:int =0;i<prizeArrId.length;i++){
					_repaint_prize(i,prizeArrId[i],"mcPrizeSmallPanel")
				}
				var prize_bit:int = m_model.m_prize
				for(var k:int=0;k<_chagnciShengArr.length;k++)
				{
					var _bit:int = BitUtil.getBitByPos(prize_bit,k+2);
					if(k<6){
						if(_bit==1){
							m_prizeSmallPanel["jingJiSai_lingqu_"+k].visible = false;
							continue;
						}else{
							m_prizeSmallPanel["jingJiSai_lingqu_"+k].visible = true;
						}
					}
					if(k==0||k==3){//今天胜利 次数
						if(m_model.today_win>= _chagnciShengArr[k])
						{
							StringUtils.setEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}else{
							StringUtils.setUnEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}
					}else if(k==1){//今天参加次数
						if(m_model.today_join>= _chagnciShengArr[k])
						{
							StringUtils.setEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}else{
							StringUtils.setUnEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}
					}else if(k==2){//本周参加次数
						if(m_model.cur_week_join>= _chagnciShengArr[k])
						{
							StringUtils.setEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}else{
							StringUtils.setUnEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}
						
					}else if(k==5||k==4){//本周胜利次数
						if(m_model.cur_week_win>= _chagnciShengArr[k])
						{
							StringUtils.setEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}else{
							StringUtils.setUnEnable(m_prizeSmallPanel["jingJiSai_lingqu_"+k]);
						}
					}else{
						trace("chao chu suo yin fan wei")
					}
				}
			}
			
			
			//			m_prizeSmallPanel['item_0']['tf_num'].text = "("+m_model.num1+"/5)";
			//			m_prizeSmallPanel['item_1']['tf_num'].text = "("+m_model.num2+"/10)";
			//			m_prizeSmallPanel['item_2']['tf_num'].text = "("+m_model.num3+"/5)";
			
		}
		
		private function _addTip(mc:MovieClip,toolID:int):void
		{
			mc.visible = true;
			var _itemData:StructBagCell2=null;
			_itemData = new StructBagCell2();
			_itemData.itemid= toolID;
			Data.beiBao.fillCahceData(_itemData);
			
//			mc['uil'].source = _itemData.icon;
			ImageUtils.replaceImage(mc,mc["uil"],_itemData.icon);
			mc["data"]=_itemData;
			CtrlFactory.getUIShow().addTip(mc);
			ItemManager.instance().setEquipFace(mc,true);
		}
		
		private function _removeTip(mc:MovieClip):void
		{
			mc.visible = false;
			mc['uil'].source = null;
			CtrlFactory.getUIShow().removeTip(mc);
			ItemManager.instance().setEquipFace(mc,false);
		}
		
		
		
		
		/**
		 *	免费传送
		 *  andy 2012-09-21 
		 *  @param mapId 
		 *  @param mapX
		 *  @param mapY
		 */
		public function chuanSongFree(mapId:int,mapX:int,mapY:int):void{
			var client:PacketCSRoleChangeMap=new PacketCSRoleChangeMap();
			client.mapid=mapId;
			client.mapx=mapX;
			client.mapy=mapY;
			DataKey.instance.send(client);
		}
		
	}
	
	
}





















