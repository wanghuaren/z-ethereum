package ui.view.view4.yunying
{
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	
	import flash.display.Sprite;
	
	import netc.Data;
	
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	
	import world.FileManager;
	
	
	public class HuoDongZhengHeItem extends Sprite
	{
		private var m_ui:Sprite = null;
		private var m_index:int = 0;
		
		
		public function HuoDongZhengHeItem(ui:Sprite)
		{
			super();
			
			m_ui = ui;
			addChild(m_ui);
		}
		
		public function setIndex(index:int):void
		{
			m_index = index;
			
			_repaint();
		}
		
		public function getIndex():int 
		{
			return m_index;
		}
			
		private function _repaint():void
		{
			m_ui['txt_name'].htmlText = Lang.getLabelArr('arrChong_zhi_fu_li_list')[m_index];
//			m_ui['mcIcon']['uil'].source = FileManager.instance.getIconHuoDongZhengHe(m_index+1);
			ImageUtils.replaceImage(m_ui['mcIcon'],m_ui['mcIcon']["uil"],FileManager.instance.getIconHuoDongZhengHe(m_index+1));
			showLight();
		}
		
		public function setSelected(b:Boolean):void
		{
			if(b)
			{
				m_ui['mcSelected'].gotoAndStop(2);
			}
			else
			{
				m_ui['mcSelected'].gotoAndStop(1);
			}
		}
		
		private function _vipchongzhi(kingvip:int):int
		{
			var _cVIP:int = kingvip;
			var _vipResConfig:Pub_VipResModel = null;
			//当前累计元宝
			var _cYB:int = Data.myKing.Pay;
			//这里不能根据服务器发过来的VIP确定，客户端自己根据已经充值的元宝计算。
			for(var i:int = 1; i < 12 ; ++i)
			{
				_vipResConfig = XmlManager.localres.VipXml.getResPath(i) as Pub_VipResModel;
				if(_vipResConfig.add_coin3 > _cYB)
				{
					break;
				}
				_cVIP = i;
			}
			
			return _cVIP;
		}
		
		/**
		 * 显示有奖励的光效 
		 * 
		 */		
		public function showLight():void
		{
			var _cVIP:int  = 0;
			var _vipResConfig:Pub_VipResModel = null;
			var _toolConfig:Pub_ToolsResModel= null;
			
			if(m_index >= 2)
			{
				m_ui['mcIcon']['mcLight'].visible = false;
			}
			else if(0 == m_index)
			{
				_cVIP = _vipchongzhi(Data.myKing.Vip);
				_vipResConfig = XmlManager.localres.VipXml.getResPath( m_index + 1 ) as Pub_VipResModel;
				
				if(null == _vipResConfig)
				{
					return ;
				}
				
				if(_cVIP >= _vipResConfig.vip_level)
				{
					if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
					{
						///StringUtils.setEnable(m_ui['btnLingQu']);
						m_ui['mcIcon']['mcLight'].visible = true;
					}
					else
					{
						///StringUtils.setUnEnable(m_ui['btnLingQu']);
						m_ui['mcIcon']['mcLight'].visible = false;
					}
				}
				else
				{
					//StringUtils.setUnEnable(m_ui['btnLingQu']);
					m_ui['mcIcon']['mcLight'].visible = false;
				}
			}
			else if(1 == m_index)
			{
				for(var i:int = 1; i <= 12; ++i)
				{
					_cVIP = _vipchongzhi(Data.myKing.Vip);
					_vipResConfig = XmlManager.localres.VipXml.getResPath(i) as Pub_VipResModel;
					
					if(null == _vipResConfig)
					{
						return ;
					}
					
					if(_cVIP >= _vipResConfig.vip_level)
					{
						if(VipGift.getInstance().isGetVipGift(_vipResConfig.vip_level))
						{
							///StringUtils.setEnable(m_ui['btnLingQu']);
							m_ui['mcIcon']['mcLight'].visible = true;
							break;
						}
						else
						{
							///StringUtils.setUnEnable(m_ui['btnLingQu']);
							m_ui['mcIcon']['mcLight'].visible = false;
						}
					}
					else
					{
						//StringUtils.setUnEnable(m_ui['btnLingQu']);
						m_ui['mcIcon']['mcLight'].visible = false;
					}
				}
			}
			
		}
		
		
	}
	
}




