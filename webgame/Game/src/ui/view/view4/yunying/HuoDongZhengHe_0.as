package ui.view.view4.yunying
{
	
	import common.config.GameIni;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketSCGetGift;
	
	import ui.frame.ItemManager;
	import ui.view.view2.other.ControlButton;
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	
	import world.FileManager;


	/**
	 * 活动合成 面板  -- 充值福利 ，原来“每日推荐”中的一个页签
	 * @author steven guo
	 * 
	 */	
	public class HuoDongZhengHe_0
	{
		private static var m_instance:HuoDongZhengHe_0;
		
		private static const MAX_VIP_LEVEL:int=12;
		
		private var m_ui:Sprite=null;
		
		private var m_selected:int = 0;
		
		public function HuoDongZhengHe_0()
		{
			_initVIPLevelConfig();
			
			Data.myKing.addEventListener(MyCharacterSet.COIN_UPDATE, coin_UPDATE);
		}
		
		public static function getInstance():HuoDongZhengHe_0
		{
			if (null == m_instance)
			{
				m_instance=new HuoDongZhengHe_0();
			}
			
			return m_instance;
		}
		
		private function coin_UPDATE(e:DispatchEvent=null):void
		{
			if(null != m_ui)
			{
				setUI(m_ui);
				_repaintBaseInfo();
			}
		}
		
		public function setUI(ui:Sprite):void
		{
			m_ui=ui;
			if(m_ui ==null)return;
			m_selected = _checkFirstHasReward();
			if(m_selected==0){
				_repaintBaseInfo();
			}
			mcHandler({name:"mcLItem_"+m_selected});
			
		}
		
		private function _checkFirstHasReward():int
		{
			var _ret:int = 0;
			for(var i:int = 0 ; i < MAX_VIP_LEVEL ; ++i )
			{
				var _cVIP:int = Data.myKing.VipByYB;
				var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( i + 1 );
				//var _toolConfig:Pub_ToolsResModel = null;
				if(null == _vipResConfig)
				{
					continue;
				}
				
				if(_cVIP >= _vipResConfig.vip_level)
				{
					if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
					{
						_ret = i;
						break;
					}
					
				}
			}
			
			return _ret;
		}

		
		private var vipConfigList:Vector.<Pub_VipResModel>=null;
		/**
		 *  初始化 VIP 等级配置
		 *
		 */
		private function _initVIPLevelConfig():void
		{
			
			if (null != vipConfigList)
			{
				return;
			}
			
			vipConfigList=new Vector.<Pub_VipResModel>();
			
			for (var i:int=0; i <= MAX_VIP_LEVEL; ++i)
			{
				vipConfigList.push(GameData.getVipXml().getResPath(i));
			}
		}
		
		public function mcHandler(target:Object):void
		{
			var _name:String = target.name;
			
			if(0 == _name.indexOf("mcLItem_"))
			{
				this.m_selected = int(	_name.substring(String("mcLItem_").length,_name.length) );
				_repaintReward();
				return ;
			}
			
			switch(_name)
			{
				case "btnLingQu":
					var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( m_selected  );
					VipGift.getInstance().requestGetGift(_vipResConfig.vip_level,_giftReturnCallback);
					setTimeout(ControlButton.getInstance().checkChongZhiFuLi,1000);
					break;
				case "f7_btnAddMoney":
				case "p_4_btnAddMoney":
				case "p_3_btnAddMoney":
				case "p_2_btnAddMoney":
					HuoDongZhengHe.getInstance().isOpenVipChongzhi();
					break;
				default:
					break;
			}
			
		}
		
		
		
		private function _repaintReward():void
		{
			//m_ui["mcLItem_"+i]["bg"].gotoAndStop(2);
			var _cVIP:int = Data.myKing.VipByYB;
			var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( m_selected + 1 );
			var _toolConfig:Pub_ToolsResModel = null;
			if(null == _vipResConfig)
			{
				return ;
			}

			(m_ui['btnLingQu'] as MovieClip).mouseChildren = false;
			if(_cVIP >= _vipResConfig.vip_level)
			{
				if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
				{
					(m_ui['btnLingQu'] as MovieClip).gotoAndStop(1);
					StringUtils.setEnable(m_ui['btnLingQu']);
					(m_ui['btnLingQu'] as MovieClip).mouseEnabled = true;
					
				}
				else
				{
					(m_ui['btnLingQu'] as MovieClip).gotoAndStop(2);
					StringUtils.setUnEnable(m_ui['btnLingQu']);
					(m_ui['btnLingQu'] as MovieClip).mouseEnabled = false;
				}
			}
			else
			{
				(m_ui['btnLingQu'] as MovieClip).gotoAndStop(3);
				StringUtils.setUnEnable(m_ui['btnLingQu']);
				(m_ui['btnLingQu'] as MovieClip).mouseEnabled = false;
			}
				
			//当前选中的奖励列表
			var _cSelectedRewardList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(_vipResConfig.gift_item);
			var _cSelectedRewardListLength:int = _cSelectedRewardList.length;
			var _cSelectedRewardListItem:Pub_ToolsResModel = null;
			var _cString:String = null;
			var _sprite:*= null; //
			for(var i:int = 0 ; i<_cSelectedRewardListLength ; ++i)
			{
				_cSelectedRewardListItem = GameData.getToolsXml().getResPath(_cSelectedRewardList[i].drop_item_id);
				
				_sprite = m_ui.getChildByName("mcRItem_"+i);
				_sprite["data"] = null;
				CtrlFactory.getUIShow().removeTip(_sprite);
				CtrlFactory.getUIShow().closeCurrentTip();
				ItemManager.instance().setEquipFace(_sprite,false);
				_sprite.mouseChildren = false;
				var _bagCell:StructBagCell2 = null;
				if(null != _cSelectedRewardListItem)
				{
					_cString = "<font color='#"+ResCtrl.instance().arrColor[_cSelectedRewardListItem.tool_color]+"' >"+ _cSelectedRewardListItem.tool_name +"</font>" ;
					m_ui["mcRItem_"+i]["txt_name"].htmlText = _cString;
//					m_ui["mcRItem_"+i]["uil"].source = FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon);
					ImageUtils.replaceImage(m_ui["mcRItem_"+i],m_ui["mcRItem_"+i]["uil"],FileManager.instance.getIconSById(_cSelectedRewardListItem.tool_icon));
					m_ui["mcRItem_"+i]["txt_num"].htmlText = String(_cSelectedRewardList[i].drop_num);
					_bagCell = new StructBagCell2();
					_bagCell.itemid = _cSelectedRewardListItem.tool_id;
					Data.beiBao.fillCahceData(_bagCell);
					_sprite["data"] = _bagCell;
					CtrlFactory.getUIShow().addTip(_sprite);
					ItemManager.instance().setEquipFace(_sprite,true);
				}
			}
	
			
			var _cSelectedToolConfig:Pub_ToolsResModel=GameData.getToolsXml().getResPath(_vipResConfig.show_item);
			m_ui["f7_txt_valuedes"].htmlText=//_cSelectedToolConfig.tool_name +
				Lang.getLabel("400610_RewardOfAddMoney_4") + "(" //+
				//_cSelectedToolConfig.tool_desc 
				+ ")";

			_repaintSelected();
			
			
		}
		
		private function _repaintSelected():void
		{
			for(var i:int = 0 ; i < 12 ; ++i )
			{
				if(m_selected == i)
				{
					m_ui['mcLItem_'+i]['mcSelected'].gotoAndStop(2);
				}
				else
				{
					m_ui['mcLItem_'+i]['mcSelected'].gotoAndStop(1);
				}
				m_ui["mcLItem_"+i]["mc_get"].visible= BitUtil.getBitByPos(Data.myKing.GiftStatus,(i+1))==0;
				Lang.addTip(m_ui['mcLItem_'+i],"HuoDongZhengHe_"+i,140);
					
				
				var _cVIP:int = Data.myKing.VipByYB;
				var _vipResConfig:Pub_VipResModel = XmlManager.localres.VipXml.getResPath( i + 1 );
				var _toolConfig:Pub_ToolsResModel = null;
				if(null == _vipResConfig)
				{
					return ;
				}
				
				if(_cVIP >= _vipResConfig.vip_level)
				{
					if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
					{
//						/StringUtils.setEnable(m_ui['btnLingQu']);
//						m_ui['mcLItem_'+i]['mcLight'].visible = true;
					}
					else
					{
						//StringUtils.setUnEnable(m_ui['btnLingQu']);
//						m_ui['mcLItem_'+i]['mcLight'].visible = false;
					}
				}
				else
				{
//					StringUtils.setUnEnable(m_ui['btnLingQu']);
//					m_ui['mcLItem_'+i]['mcLight'].visible = false;
				}
				
			}
		}
		
		
		public function repaint():void
		{
			if(null == m_ui)
			{
				return ;
			}
			
			var _vipResConfig:Pub_VipResModel = null
			var _toolConfig:Pub_ToolsResModel = null;
			for(var i:int = 0; i<12 ; ++i)
			{
				_vipResConfig = XmlManager.localres.VipXml.getResPath( i + 1 );
				if(null != _vipResConfig)
				{
					_toolConfig =GameData.getToolsXml().getResPath(_vipResConfig.show_item);
					
					if(null != _toolConfig)
					{
						var _url:String = FileManager.instance.getIconXById(_toolConfig.tool_icon);
						if(_url != m_ui["mcLItem_"+i]["uil"].source)
						{
							m_ui["mcLItem_"+i]["uil"].source = _url;
						}
						m_ui["mcLItem_"+i].mouseChildren = false;
					}
				}
			}
			_repaintReward();
			_repaintBaseInfo();
			
			if(GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
			{
				m_ui['huang_lan'].gotoAndStop(2);
			}
			else
			{
				m_ui['huang_lan'].gotoAndStop(1);
			}
		}
		
		
		private function _repaintBaseInfo():void
		{
			if(null == m_ui)
			{
				return ;
			}
			//当前累计元宝
			var _cYB:int = Data.myKing.Pay;
			
			//当前VIP等级
			var _cVIP:int = Data.myKing.VipByYB;
			
			var _vipResConfig:Pub_VipResModel = null;

		//	var _toolConfig:Pub_ToolsResModel = null;
			
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
				_vipResConfig = XmlManager.localres.VipXml.getResPath(_cVIP + 1);
				//_toolConfig = GameData.getToolsXml().getResPath(_vipResConfig.show_item);
				_nYB = _vipResConfig.add_coin3;
				
				if(_cYB <= 0)
				{
//					m_ui["f7_txt_name"].text = Lang.getLabel("40068_RewardOfAddMoney_2")+1+ Lang.getLabel("40069_RewardOfAddMoney_3")//+ _toolConfig.tool_name ;
				}
				else
				{
//					m_ui["f7_txt_name"].text =  Lang.getLabel("40068_RewardOfAddMoney_2")+(_nYB - _cYB)+Lang.getLabel("40069_RewardOfAddMoney_3")//+ _toolConfig.tool_name ;
				}
				
				_percent = _cYB / _nYB * 100;
				
			}
			
			//  ===================== 元宝经验条 ===================== 
			
			if(_nYB <= 0)
			{
				_nYB = _cYB;
			}
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
			var _time:Number = StringUtils.changeStringTimeToDate(_starServerTime).time;
			
			if(m_nowTime < 0 && m_nowTimeX < 0)
			{
				//m_nowTime = new Date().time;
				m_nowTime = Data.date.nowDate.time;
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
		 * 领取礼包的返回消息处理
		 * @param p
		 * 
		 */		
		private function _giftReturnCallback(p:PacketSCGetGift):void
		{
			m_selected =  _checkFirstHasReward();
			_repaintReward();
		}
		
		
		
	}
	
	
}