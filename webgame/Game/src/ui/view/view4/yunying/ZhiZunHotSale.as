package ui.view.view4.yunying
{
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_Vip_TypeResModel;
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	
	import model.yunying.ZhiZunVIPModel;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.vip.VipGuide;
	
	/**
	 * 至尊VIP热卖
	 * @author steven guo
	 * 
	 */	
	public class ZhiZunHotSale extends UIWindow
	{
		private static var m_instance:ZhiZunHotSale = null;
		
		private var m_model:ZhiZunVIPModel = null;
		
		
		
		public function ZhiZunHotSale()
		{
			
			super(getLink(WindowName.win_tequanka_remai));
			
			m_model = ZhiZunVIPModel.getInstance();
		}
		
		public static function getInstance():ZhiZunHotSale
		{
			if(null == m_instance)
			{
				m_instance = new ZhiZunHotSale();
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			
			
			
			var _vipconfig_1:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(1) as Pub_Vip_TypeResModel;
			Lang.addTip(mc['item_1'], "pub_param",260); 
			mc['item_1'].tipParam=[_vipconfig_1.vip_content];
			
			var _vipconfig_2:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(2) as Pub_Vip_TypeResModel;
			Lang.addTip(mc['item_2'], "pub_param",260);
			mc['item_2'].tipParam=[_vipconfig_2.vip_content];
			
			var _vipconfig_3:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(3) as Pub_Vip_TypeResModel;
			Lang.addTip(mc['item_3'], "pub_param",260);
			mc['item_3'].tipParam=[_vipconfig_3.vip_content];
			
			//mc['item_1']['tf_1'].text = _vipconfig_1.need_coin3;
			if(VipGuide.getInstance().chkVipGuideBigIcon()){
				mc['item_1']['tf_1'].text =580;
			}else{
				mc['item_1']['tf_1'].text = _vipconfig_1.need_coin3;
			}
			mc['item_1']['tf_1_0'].text = Math.round(_vipconfig_1.need_coin3 * 2 );
			
			mc['item_2']['tf_2'].text = _vipconfig_2.need_coin3;
			mc['item_2']['tf_2_0'].text = Math.round(_vipconfig_2.need_coin3 * 2 );
			
			mc['item_3']['tf_3'].text = _vipconfig_3.need_coin3;
			mc['item_3']['tf_3_0'].text = Math.round(_vipconfig_3.need_coin3 * 2 );
			
			
			
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			
			var _vipconfig_1:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(1) as Pub_Vip_TypeResModel;
			var _vipconfig_2:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(2) as Pub_Vip_TypeResModel;
			var _vipconfig_3:Pub_Vip_TypeResModel = GameData.getVipTypeXml().getResPath(3) as Pub_Vip_TypeResModel;
			
			
			switch(name)
			{
				case "btnOpen_3":    //购买至尊
					alert.ShowMsg(Lang.getLabel('40090_ZhiZun_TeQuan_3',[_vipconfig_3.need_coin3]),4,null,_vipBuy,3);
					break;
				case "btnOpen_2":    //购买紫金
					alert.ShowMsg(Lang.getLabel('40090_ZhiZun_TeQuan_2',[_vipconfig_2.need_coin3]),4,null,_vipBuy,2);
					break;
				case "btnOpen_1":    //购买白银
					alert.ShowMsg(Lang.getLabel('40090_ZhiZun_TeQuan_1',[VipGuide.getInstance().chkVipGuideBigIcon()?580:_vipconfig_1.need_coin3]),4,null,_vipBuy,1);
					break;
				default:
					break;
			}
			
		}
		
		private function _vipBuy(obj:Object):void
		{
			m_model.requestCSGameVipBuy(int(obj));
		}
		
		override public function getID():int
		{
			return 1064;
		}
		
	}
	
	
}



