package ui.view.view4.yunying
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import netc.DataKey;
	import netc.packets2.StructPrizeStateData2;
	
	import nets.packets.PacketCSGetVipLevelData;
	import nets.packets.PacketCSGetVipLevelPrize;
	import nets.packets.PacketCSGetVipLevelPrizeState;
	import nets.packets.PacketSCGameVipPrize;
	import nets.packets.PacketSCGetVipLevelData;
	import nets.packets.PacketSCGetVipLevelPrize;
	import nets.packets.PacketSCGetVipLevelPrizeState;
	import nets.packets.PacketSCPickUpCoin3;
	
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	import ui.base.vip.ChongZhi;
	import ui.view.view8.YBExtractWindow;
	
	/**
	 * 至尊VIP
	 * @author steven guo
	 * 
	 */	
	public class ZhiZunVIP_New extends UIPanel
	{
		//最高等级
		private static const MAX_LEVEL:int = 10;
		
		private static var m_instance:ZhiZunVIP_New = null;
		
		/** 
		 *至尊VIP等级
		 */
		private var m_level:int;
		/** 
		 *已充元宝数
		 */
		private var m_curCoin3:int;
		/**
		 *下一级需要元宝数量 
		 */		
		private var m_nextCoin3:int;
		
		/** 
		 *第0~9个，所有等级的一次性奖励；10~18 已经领取每日奖励的VIP等级
		 */
		public var m_arrItemprize_state:Vector.<StructPrizeStateData2> = null;
		
		
		
		public function ZhiZunVIP_New(DO:DisplayObject=null)
		{
			super(getLink(WindowName.win_ZhiZunVIP_New));
			
			DataKey.instance.register(PacketSCGetVipLevelData.id,_responseSCGetVipLevelData); 
			DataKey.instance.register(PacketSCGetVipLevelPrizeState.id,_responseSCGetVipLevelPrizeState); 
			DataKey.instance.register(PacketSCGetVipLevelPrize.id,_responseSCGetVipLevelPrize); 
			DataKey.instance.register(PacketSCPickUpCoin3.id, _responseSCPickUpCoin3);

		}
		
		public static function getInstance():ZhiZunVIP_New
		{
			if(null == m_instance)
			{
				m_instance = new ZhiZunVIP_New();
			}
			return m_instance;
		}
		
		override public function init():void
		{
			super.init();
			
			sysAddEvent(mc["tf_current"], TextEvent.LINK, _textLinkListener);
			sysAddEvent(mc["tf_next"], TextEvent.LINK, _textLinkListener);
			
			requestCSGetVipLevelData();
			
		}
		
		private function _repaint():void
		{
			var _currentVipResModel:Pub_VipResModel = XmlManager.localres.VipXml.getResPath(m_level) as Pub_VipResModel;
			var _nextVipResModel:Pub_VipResModel = XmlManager.localres.VipXml.getResPath(m_level+1) as Pub_VipResModel;
			
			var _cVipResModel:Pub_VipResModel = _currentVipResModel;
			var _nVipResModel:Pub_VipResModel = _nextVipResModel;
			//最高等级
			var _mVipResModel:Pub_VipResModel = XmlManager.localres.VipXml.getResPath(MAX_LEVEL) as Pub_VipResModel;
			
			
			//不是至尊会员
			if(m_level <= 0 )
			{
				mc['tf_desc'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_1",[0]) ;
				mc['tf_next_need'].htmlText =
					Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_2",[(_nVipResModel.add_coin3 - this.m_curCoin3),(m_level+1)]);
				_cVipResModel = _nextVipResModel;
				_nVipResModel = XmlManager.localres.VipXml.getResPath(m_level+1) as Pub_VipResModel;
				mc['mcBar']['mcMask'].scaleX = 0;
			}
			//已经达到最高等级
			else if(null == _nextVipResModel)
			{
				mc['tf_desc'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_3",[m_level]);
				mc['tf_next_need'].htmlText ="";
				mc['mcBar']['mcMask'].scaleX = 1;
			}
			//是至尊会员，但是还没到最高等级
			else
			{
				mc['tf_desc'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_1",[m_level,]) 
				mc['tf_next_need'].htmlText =
					Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_2",[(_nVipResModel.add_coin3 - this.m_curCoin3),(m_level+1)]);
				
				mc['mcBar']['mcMask'].scaleX = (this.m_curCoin3 - _cVipResModel.add_coin3) / 
					(_nVipResModel.add_coin3 - _cVipResModel.add_coin3);
			}
			
			
			
			//mc['mcBar'].gotoAndStop(m_level+1) //= this.m_curCoin3 / _mVipResModel.add_coin3;
			(mc['tf_current'] as TextField).mouseWheelEnabled = false;
			(mc['tf_next'] as TextField).mouseWheelEnabled = false;
			
			
			//不是至尊会员
			if(m_level <= 0 )
			{
				mc['tf_current'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_6");
			}
			else
			{
				mc['tf_current'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_4",[m_level,m_level]);
				mc['tf_current'].htmlText += _replaceContent(_cVipResModel.vip_content);
			}
			
			
			if(null == _nVipResModel)
			{
				mc['tf_next'].htmlText = "";
			}
			else
			{
				mc['tf_next'].htmlText = Lang.getLabel("40101_ZhiZunVIP_New_tf_desc_5",[(_nVipResModel.add_coin3 - this.m_curCoin3),(m_level+1),(m_level+1)]);     
				mc['tf_next'].htmlText += _replaceContent(_nVipResModel.vip_content);
				
			}
			mc['tf_current'].height = mc['tf_current'].textHeight + 10;    
			mc['spCurrent'].source = mc['tf_current'];   
			mc['tf_next'].height = mc['tf_next'].textHeight + 10;    
			mc['spNext'].source = mc['tf_next'];    
			
		}
		
		
		// 面板双击事件
		override public function mcDoubleClickHandler(target:Object):void
		{
			
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;
			
			switch(name)
			{
				case "btnChongZhi":
					ChongZhi.getInstance().open();    
					break;
				case "btnTiQuYuanBao":
					if (!YBExtractWindow.getInstance().isOpen)
					{
						YBExtractWindow.getInstance().open();
					}
					else
					{
						YBExtractWindow.getInstance().winClose();
					}
					break;
				default:
					break;
			}
			
		}
		
		//-----------------------------------------------------
		/*
		
		技术部-李恪荣 09:23:10
		<packet id="53600" name="CSGetVipLevelData" desc="至尊VIP信息" sort="1">
		</packet>
		<packet id="53601" name="SCGetVipLevelData" desc="至尊VIP信息返回" sort="2">
		<prop name="level" type="3" length="0" desc="至尊VIP等级"/>
		<prop name="curCoin3" type="3" length="0" desc="已充元宝数"/>
		<prop name="tag" type="3" length="0" desc="错误码"/>
		</packet>
		
		<packet id="53602" name="CSGetVipLevelPrizeState" desc="至尊VIP奖励状态" sort="1">
		</packet>
		<packet id="53603" name="SCGetVipLevelPrizeState" desc="至尊VIP奖励状态返回" sort="2">
		<prop name="prize_state" type="5100"  length="1" desc="第0~11个，所有等级的一次性奖励；12~20 已经领取每日奖励的VIP等级"/>
		<prop name="tag" type="3" length="0" desc="错误码"/>
		</packet>
		
		<packet id="53604" name="CSGetVipLevelPrize" desc="领取至尊VIP奖励" sort="1">
		<prop name="event_id" type="3" length="0" desc="格式XXNN， XX VIP等级， NN奖励序号"/>
		</packet>
		<packet id="53605" name="SCGetVipLevelPrize" desc="领取至尊VIP奖励返回" sort="2">
		<prop name="event_id" type="3" length="0" desc="格式XXNN， XX VIP等级， NN奖励序号"/>
		<prop name="tag" type="3" length="0" desc="错误码"/>
		</packet>
		
		<struct id="5100" name="PrizeStateData" desc="奖励状态" sort="1">
		<prop name="prize_id" type="3"  length="0" desc="奖励序号"/>
		<prop name="state" type="3"  length="0" desc="状态，0，未领取； 1已经领取"/>
		</struct>
		
		*/
		
		public function requestCSGetVipLevelData():void
		{
			var _p:PacketCSGetVipLevelData=new PacketCSGetVipLevelData();
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCGetVipLevelData(p:IPacket):void
		{
			var _p:PacketSCGetVipLevelData=p as PacketSCGetVipLevelData;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			m_level = _p.level;
			m_curCoin3 = _p.curCoin3;   
			requestCSGetVipLevelPrizeState();
			//_repaint();
		}
		
		public function requestCSGetVipLevelPrizeState():void
		{
			var _p:PacketCSGetVipLevelPrizeState=new PacketCSGetVipLevelPrizeState();
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCGetVipLevelPrizeState(p:IPacket):void
		{
			var _p:PacketSCGetVipLevelPrizeState=p as PacketSCGetVipLevelPrizeState;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			m_arrItemprize_state = _p.arrItemprize_state;
			_repaint();
		}
		
		public function requestCSGetVipLevelPrize(event_id:int):void
		{
			var _p:PacketCSGetVipLevelPrize = new PacketCSGetVipLevelPrize();
			_p.event_id = event_id;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetVipLevelPrize(p:IPacket):void
		{
			var _p:PacketSCGetVipLevelPrize=p as PacketSCGetVipLevelPrize;
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			
			//状态，0，未领取； 1已经领取
			var _data:StructPrizeStateData2 = _getPrizeStateData(_p.event_id);
			_data.state = 1;
		}
		
		
		
		private function _getPrizeStateData(event_id:int):StructPrizeStateData2
		{
			var _ret:StructPrizeStateData2 = null;
			if(null == m_arrItemprize_state)
			{
				return _ret;
			}
			
			for each(var item:StructPrizeStateData2 in m_arrItemprize_state)
			{
				if(item.prize_id == event_id)
				{
					_ret = item;
					break;
				}
			}
			
			return _ret;
		}
		
		
		
		private function _replaceContent(sourceContent:String):String
		{
			var _ret:String = sourceContent;
			
			var _arr:Array = [];
			var _indexOf0:int = 0;
			var _indexOf1:int = 0;
			var i:int = 0;
			for(i = 0; i < 100 ; ++i)
			{
				if(_indexOf0>=0 && _indexOf1>=0)
				{
					_indexOf0 = sourceContent.indexOf("{",_indexOf1);
					_indexOf1 = sourceContent.indexOf("}",_indexOf1);
					if(_indexOf0>=0 && _indexOf1>=0)
					{
						_arr.push([_indexOf0,_indexOf1]);
					}
					
					if(_indexOf1 > 0)
					{
						_indexOf1 ++;
					}
				}
				else
				{
					break;
				}
			}
			
			var _event:String = null;
			var _eventID:int = 0;
			var _newSub:String = sourceContent;
			var _replace:String = null;
			var _data:StructPrizeStateData2 = null;
			
			for(i = 0; i < _arr.length ; ++i)
			{
				_event = sourceContent.substring(_arr[i][0],_arr[i][1]+1);
				_eventID = int(sourceContent.substring(_arr[i][0]+10,_arr[i][1]));
				//状态，0，未领取； 1已经领取
				_data = _getPrizeStateData(_eventID);
				if(null == _data || 0 == _data.state)
				{
					_replace = "<font><u><a href='event:"+_eventID+"'>"+"领取"+"</a></u></font>";
					_newSub = _newSub.replace(_event,_replace);
				}
				else
				{
					_replace = "<font><u>已领取</u></font>";
					_newSub = _newSub.replace(_event,_replace);
				}
				
								
				_ret = _newSub;
			}
			
						return _ret;
		}
		
		private function _textLinkListener(e:TextEvent):void
		{
//			switch (e.text)
//			{
//				case "0@click":   //领取
//					
//					break;
//				default:
//					break;
//			}
			
			var _eventId:int = int(e.text);
			if(_eventId <= 0)
			{
				return ;
			}
			
			requestCSGetVipLevelPrize(_eventId);
		}
		
		private function _responseSCPickUpCoin3(p:IPacket):void
		{
			var _p:PacketSCPickUpCoin3=p as PacketSCPickUpCoin3;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
			}
			
			requestCSGetVipLevelData();
		}
		
		
	}
		
		
}
	
	
	
	