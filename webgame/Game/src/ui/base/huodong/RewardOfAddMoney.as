package ui.base.huodong
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.res.ResCtrl;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketSCGetGift;
	
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	
	import world.FileManager;

	/**
	 * 运营活动中的充值奖励,需要活动主窗口传进来UI
	 *
	 * @author steven guo
	 * 
	 */	
	public class RewardOfAddMoney
	{
		private static var m_instance:RewardOfAddMoney;
		
		private static const MAX_VIP_LEVEL:int = 12;

		private var m_ui:Sprite = null;
		
		public function get is_m_ui_null():Boolean
		{
			if(null == m_ui)
			{
				return true;
			}
			
			return false;
		}
		
		private var m_cSelectedIndex:int ; 
		
		public function RewardOfAddMoney()
		{
			
		}
		
		

		public static function getInstance():RewardOfAddMoney
		{
			if(null == m_instance)
			{
				m_instance = new RewardOfAddMoney();
			}
			
			return m_instance;
		}
		
		public function setUI(ui:Sprite):void
		{
			m_ui = ui;
		}
		
		
		private var m_timer:Timer;
		public function starTimer():void
		{
			if(null == m_timer)
			{
				m_timer = new Timer(1000,0);
				m_timer.addEventListener(TimerEvent.TIMER,_timerListener);
			}
			
			m_timer.reset();
			m_timer.start();
		}
		
		private function _timerListener(event:TimerEvent):void
		{
			_repaintConutleftTime();
		}
		
		public function stopTimer():void
		{
			if(null != m_timer)
			{
				m_timer.stop();
			}
			
		}
		
		public function repaint():void
		{
//			if (5 != (m_ui as MovieClip).currentFrame)
//			{
//				return;
//			}
			
			_handleLeftAndRightBtn(m_listOffSetIndex);
			
			// ===================== 充值 XX 元宝 ， 您就能领取  XX 礼包  ============================
			
			//当前累计元宝
			var _cYB:int = Data.myKing.Pay;
			
			//当前VIP等级
			var _cVIP:int = Data.myKing.Vip;
			
			var _vipResConfig:Pub_VipResModel = null;
			
			var _toolConfig:Pub_ToolsResModel = null;
			
			//升级到下一个 VIP需要多少元宝
			var _nYB:int = 0;
			
			var _percent:int = 100;
			
			//达到最高等级
			if(_cVIP >= MAX_VIP_LEVEL)
			{
				_percent = 100;
				
				m_ui["f7_txt_name"].text = Lang.getLabel("40067_RewardOfAddMoney_1");
			}
			else
			{
				_vipResConfig = XmlManager.localres.getVipXml.getResPath(_cVIP + 1) as Pub_VipResModel;
				_toolConfig = XmlManager.localres.getToolsXml.getResPath(1) as Pub_ToolsResModel;
				_nYB = _vipResConfig.add_coin3;
				
				if(_cYB <= 0)
				{
					m_ui["f7_txt_name"].text = Lang.getLabel("40068_RewardOfAddMoney_2")+1+ Lang.getLabel("40069_RewardOfAddMoney_3")+ _toolConfig.tool_name ;
				}
				else
				{
					m_ui["f7_txt_name"].text =  Lang.getLabel("40068_RewardOfAddMoney_2")+(_nYB - _cYB)+Lang.getLabel("40069_RewardOfAddMoney_3")+ _toolConfig.tool_name ;
				}
				
				_percent = _cYB / _nYB * 100;
				
			}

			//  ===================== 元宝经验条 ===================== 
			
			if(_nYB <= 0)
			{
				_nYB = _cYB;
			}
			m_ui["f7_bar_txt"].text = _cYB+"/"+_nYB;
			
			m_ui["f7_bar"].gotoAndStop(_percent);
			
			//  ===================== 活动剩余时间 ===================== 
			_repaintConutleftTime();
			
			//  ===================== 礼包列表 ===================== 
			_repaintList(m_listOffSetIndex);
			
			//  ===================== xxx 元礼包内容 (价值 XXX 元宝) ===================== 
			
			//当前选中礼包
			var _cSelectedVipResConfig:Pub_VipResModel = XmlManager.localres.getVipXml.getResPath( m_listOffSetIndex + m_cSelectedIndex + 1) as Pub_VipResModel;
			var _cSelectedToolConfig:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(1) as Pub_ToolsResModel;
			m_ui["f7_txt_value"].text = _cSelectedToolConfig.tool_name + Lang.getLabel("400610_RewardOfAddMoney_4")+"(" + _cSelectedToolConfig.tool_desc + ")";
			
			//  ===================== 对应礼包奖励内容列表 ===================== 
			
			//当前选中的奖励列表
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(1) as Vector.<Pub_DropResModel>;//_cSelectedVipResConfig.gift_item);
			var _cSelectedRewardListLength:int = _cSelectedRewardList.length;
			var _cSelectedRewardListItem:Pub_ToolsResModel = null;
			var _cString:String = null;
			var _sprite:*= null; //
			for(var i:int = 0 ; i<_cSelectedRewardListLength ; ++i)
			{
				_cSelectedRewardListItem = XmlManager.localres.getToolsXml.getResPath(_cSelectedRewardList[i].drop_item_id) as Pub_ToolsResModel;
				
				_sprite = m_ui.getChildByName("f7_pic"+i);
				_sprite["data"] = null;
				CtrlFactory.getUIShow().removeTip(_sprite);
				CtrlFactory.getUIShow().closeCurrentTip();
				ItemManager.instance().setEquipFace(_sprite,false);
				_sprite.mouseChildren = false;
				var _bagCell:StructBagCell2 = null;
				
				if(null != _cSelectedRewardListItem)
				{
					_cString = "<font color='#"+ResCtrl.instance().arrColor[_cSelectedRewardListItem.tool_color]+"' >"+ _cSelectedRewardListItem.tool_name +"×"+_cSelectedRewardList[i].drop_num +"</font>" ;
					m_ui["f7_pic"+i]["txt_name"].htmlText = _cString;
//					m_ui["f7_pic"+i]["uil"].source = FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon);
					ImageUtils.replaceImage(m_ui["f7_pic"+i],m_ui["f7_pic"+i]["uil"],FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon));

					_bagCell = new StructBagCell2();
					_bagCell.itemid = _cSelectedRewardListItem.tool_id;
					Data.beiBao.fillCahceData(_bagCell);
					_sprite["data"] = _bagCell;
					CtrlFactory.getUIShow().addTip(_sprite);
					ItemManager.instance().setEquipFace(_sprite,true);
				}
				
				
				
			}
			
		}
		
		
		private var m_listOffSetIndex:int = 0;   //列表数据显示偏移
		private static const MAX_LIST_N:int = 6;      //列表显示最大个数
		
		// 打印礼包列表
		private function _repaintList(offSet:int):void
		{
			m_listOffSetIndex = offSet;
			
			if(offSet <0 )
			{
				m_listOffSetIndex = 0;
			}
			else if(offSet > (MAX_VIP_LEVEL - MAX_LIST_N))
			{
				m_listOffSetIndex = (MAX_LIST_N );
			}
			
			//当前VIP等级
			var _cVIP:int = Data.myKing.Vip;
			
			var _vipResConfig:Pub_VipResModel = null; // = XmlManager.localres.getVipXml.getResPath(_cVIP + 1);
			var _toolConfig:Pub_ToolsResModel = null;
			//var sprite:*= null; //
			for(var i:int = 0; i<MAX_LIST_N ; ++i)
			{
				_vipResConfig = XmlManager.localres.getVipXml.getResPath(i + m_listOffSetIndex + 1) as Pub_VipResModel;
				if(null != _vipResConfig)
				{
					_toolConfig = XmlManager.localres.getToolsXml.getResPath(1) as Pub_ToolsResModel;
					m_ui["f7_item"+i]["btn"].mouseEnabled = false;
					
					if(_cVIP >= _vipResConfig.vip_level)
					{
						//StringUtils.setEnable(m_ui["f7_item"+i]["btn"]);
						if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
						{
							m_ui["f7_item"+i]["btn"].gotoAndStop(1);
							m_ui["f7_item"+i]["btn"].mouseEnabled = true;
						}
						else
						{
							m_ui["f7_item"+i]["btn"].gotoAndStop(3);
						}
					}
					else
					{
						m_ui["f7_item"+i]["btn"].gotoAndStop(2);
						//StringUtils.setUnEnable(m_ui["f7_item"+i]["btn"]);
						
					}
				}
				
				//new Sprite().mouseChildren;
				m_ui["f7_item"+i]["txt_name"].mouseEnabled = false;
				m_ui["f7_item"+i]["uil"].mouseEnabled = false;
				m_ui["f7_item"+i]["bg"].gotoAndStop(1);
				m_ui["f7_item"+i]["btn"].mouseChildren = false;
				
				//m_ui["f7_item"+i]["txt_name"].mouseChildren = false;
				m_ui["f7_item"+i]["uil"].mouseChildren = false;
				m_ui["f7_item"+i]["bg"].mouseChildren = false;
				m_ui["f7_item"+i]["bg"].mouseEnabled = false;

				if(null != _toolConfig)
				{
					//sprite = m_ui.getChildByName("f7_item"+i);
					//sprite["data"] = _toolConfig;
					//ItemManager.instance().setEquipFace(sprite,true);
					
					m_ui["f7_item"+i]["txt_name"].htmlText = _toolConfig.tool_name;
//					m_ui["f7_item"+i]["uil"].source = FileManager.instance.getIconXById(_toolConfig.tool_icon);
					ImageUtils.replaceImage(m_ui["f7_item"+i],m_ui["f7_item"+i]["uil"],FileManager.instance.getIconXById(_toolConfig.tool_icon));
				}
				
				if(i == m_cSelectedIndex)
				{
					m_ui["f7_item"+i]["bg"].gotoAndStop(2);
				}
				
				
			}
		}
		
		private function _repaintConutleftTime():void
		{
			m_ui["f7_txt_time"].text = _conutleftTime();
		}
		
		//5天的毫秒值
		private static const FIVE_DAY_MILLISECOND:int = 60*60*24*5*1000; 
		private var m_nowTime:Number = -1; // 第一次创建 本地时间对象的时间
		private var m_nowTimeX:Number = -1;  // 第一次创建本地时间对象的时间差值
		
		/**
		 * 计算活动剩余时间，返回一个时间字符串 
		 * @return 
		 * 
		 */	
		private function _conutleftTime():String
		{
			var _ret:String;
			var _starServerTime:String = GameIni.starServerTime();
			var _time:Number = StringUtils.changeStringTimeToDate(_starServerTime).getTime();
			
			if(m_nowTime < 0 && m_nowTimeX < 0)
			{
				m_nowTime = new Date().getTime();
				m_nowTimeX = getTimer();
				_time = m_nowTime - _time;
			}
			else
			{
				_time = m_nowTime - _time - (getTimer() - m_nowTimeX);
			}

			_time %= FIVE_DAY_MILLISECOND;
			
			_ret = StringUtils.getStringDayTime(_time,false);
			
			return _ret;
			
		}
		
		/**
		 * 处理鼠标点击事件 
		 * @param target
		 * 
		 */		
		public function mcHandler(target:Object):void
		{
			var _name:String = target.name;
			var _selectedIndex:int = m_cSelectedIndex;
			
			if(_name.indexOf("cbtn7") >= 0)
			{
				starTimer();
			}
			else if(_name.indexOf("cbtn")>=0)
			{
				stopTimer();
			}
			
			//快速充值
			if(_name.indexOf("f7_btnAddMoney")>=0)
			{
				Vip.getInstance().pay();
			}
			//第1个礼包ITEM
			else if(_name.indexOf("f7_item0")>=0)
			{
				_selectedIndex =  0;
			}
			//第2个礼包ITEM
			else if(_name.indexOf("f7_item1")>=0)
			{
				_selectedIndex =  1;
			}
			//第3个礼包ITEM
			else if(_name.indexOf("f7_item2")>=0)
			{
				_selectedIndex =  2;
			}
			//第4个礼包ITEM
			else if(_name.indexOf("f7_item3")>=0)
			{
				_selectedIndex =  3;
			}
			//第5个礼包ITEM
			else if(_name.indexOf("f7_item4")>=0)
			{
				_selectedIndex =  4;
			}
			//第6个礼包ITEM
			else if(_name.indexOf("f7_item5")>=0)
			{
				_selectedIndex =  5;
			}
			else if(_name.indexOf("btn")>=0)
			{
				var _parent:Object = target.parent;
				
				if(null != _parent)
				{
					var _parentName:String = _parent.name;
					var _sendVip:int = 0;
					
					if(_parentName.indexOf("f7_item0")>=0)
					{
						_sendVip = m_listOffSetIndex + 0 + 1;
						m_currentGiftIndex = 0;
					}
					else if(_parentName.indexOf("f7_item1")>=0)
					{
						_sendVip = m_listOffSetIndex + 1 + 1;
						m_currentGiftIndex = 1;
					}
					else if(_parentName.indexOf("f7_item2")>=0)
					{
						_sendVip = m_listOffSetIndex + 2 + 1;
						m_currentGiftIndex = 2;
					}
					else if(_parentName.indexOf("f7_item3")>=0)
					{
						_sendVip = m_listOffSetIndex + 3 + 1;
						m_currentGiftIndex = 3;
					}
					else if(_parentName.indexOf("f7_item4")>=0)
					{
						_sendVip = m_listOffSetIndex + 4 + 1;
						m_currentGiftIndex = 4;
					}
					else if(_parentName.indexOf("f7_item5")>=0)
					{
						_sendVip = m_listOffSetIndex + 5 + 1;
						m_currentGiftIndex = 5;
					}
					
					VipGift.getInstance().requestGetGift(_sendVip,_giftReturnCallback);
					
					
				}
				
				
			}
			
			if(_selectedIndex != m_cSelectedIndex)
			{
				m_cSelectedIndex = _selectedIndex;
				
				repaint();
			}
			
			
			if(_name.indexOf("f7_tx_l")>=0)
			{
				--m_listOffSetIndex;
				if(m_listOffSetIndex < 0 )
				{
					m_listOffSetIndex = 0;
				}
//				else if(0 == m_listOffSetIndex)
//				{
//					StringUtils.setUnEnable(m_ui["f7_tx_l"]);
//					
//				}
//				else
//				{
//					StringUtils.setEnable(m_ui["f7_tx_l"]);
//				}
				
				
				repaint();
			}
			else if(_name.indexOf("f7_tx_r")>=0)
			{
				++m_listOffSetIndex;
				if(m_listOffSetIndex > MAX_LIST_N)
				{
					m_listOffSetIndex = MAX_LIST_N;
				}
				
				
				
//				else if(MAX_LIST_N == m_listOffSetIndex)
//				{
//					StringUtils.setUnEnable(m_ui["f7_tx_r"]);
//					
//				}
//				else
//				{
//					StringUtils.setEnable(m_ui["f7_tx_r"]);
//				}
				
				
				
				repaint();
			}
			

			
			
		}
		
		/**
		 * 处理左右翻页键的状态 
		 * @param offSetIndex
		 * 
		 */		
		private function _handleLeftAndRightBtn(offSetIndex:int):void
		{
			if(offSetIndex <= 0)
			{
				//StringUtils.setUnEnable(m_ui["f7_tx_l"]);
				
				m_ui["f7_tx_l"].mouseEnabled = false;
				m_ui["f7_tx_l"].gotoAndStop(2);
			}
			else 
			{
				//StringUtils.setEnable(m_ui["f7_tx_l"]);
				
				m_ui["f7_tx_l"].mouseEnabled = true;
				m_ui["f7_tx_l"].gotoAndStop(1);
			}
			
			if(offSetIndex >= MAX_LIST_N)
			{
				//StringUtils.setUnEnable(m_ui["f7_tx_r"]);
				
				m_ui["f7_tx_r"].mouseEnabled = false;
				m_ui["f7_tx_r"].gotoAndStop(2);
			}
			else
			{
				//StringUtils.setEnable(m_ui["f7_tx_r"]);
				
				m_ui["f7_tx_r"].mouseEnabled = true;
				m_ui["f7_tx_r"].gotoAndStop(1);
			}
		}
		
		
		private var m_currentGiftIndex:int = -1;
		
		/**
		 * 领取礼包的返回消息处理
		 * @param p
		 * 
		 */		
		private function _giftReturnCallback(p:PacketSCGetGift):void
		{
			if(0 != p.tag)
			{
				m_currentGiftIndex = -1;
				return ;
			}
			
			if(m_currentGiftIndex >= 0)
			{
				m_ui["f7_item"+m_currentGiftIndex]["btn"].gotoAndStop(3);
			}
			
			
			m_currentGiftIndex = -1;
			
		}
			
			
	}
	
}