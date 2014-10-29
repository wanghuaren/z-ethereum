package ui.base.npc
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Shop_NormalResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class NpcHotShop extends UIWindow
	{
		private static var _instance:NpcHotShop;
		//技能书商店ID
		public static const JINENG_BOOK_SHOP_ID:int = 70200005;
		//技能书碎片商店 ID 
		public static const JINENG_BOOK_SUIPIAN_SHOP_ID:int = 70100019;
		
		public function NpcHotShop()
		{
//			super(getLink(WindowName.win_hot_sall2));
		}
		
		public static function getInstance():NpcHotShop
		{
			if(_instance==null)
			{
				_instance=new NpcHotShop();
			}
			return _instance;
		}
		
		override protected function init():void
		{
			var arr:Array=XmlManager.localres.getPubShopNormalXml.getResPath2(NpcHotShop.JINENG_BOOK_SUIPIAN_SHOP_ID,1) as Array;
			var _Pub_Shop_NormalResModel:Pub_Shop_NormalResModel = null;
			
			if(null == arr || arr.length <= 0)
			{
				return ;
			}
			
			_Pub_Shop_NormalResModel = arr[0];
			
			var sprite:MovieClip= null;
			var item:StructBagCell2 = null;
			if(null != _Pub_Shop_NormalResModel)
			{
				item = new StructBagCell2();
				item.itemid = _Pub_Shop_NormalResModel.tool_id;
				
				Data.beiBao.fillCahceData(item);
				
				sprite = mc['item_0'] as MovieClip;
//				sprite["uil"].source = item.icon;
				ImageUtils.replaceImage(sprite,sprite["uil"],item.icon);
				sprite["data"] = item;
				
				sprite.visible = true;
				mc['tf_0'].visible = true;
				
				if(1 == _Pub_Shop_NormalResModel.need_sort)
				{
					mc['tf_0'].text = item.buyprice3 + Lang.getLabel("pub_yuan_bao");
				}
				else
				{
					mc['tf_0'].text = item.buyprice3 + Lang.getLabel("pub_yin_liang");
				}
				
				ItemManager.instance().setEquipFace(sprite);
				CtrlFactory.getUIShow().addTip(sprite);
			}
			else
			{
				sprite = mc['item_0'] as MovieClip;
				sprite["uil"].source = null;
				mc['tf_0'].text = "";
				sprite.visible = false;
				mc['tf_0'].visible = false;
				
				ItemManager.instance().setEquipFace(sprite,false);
				CtrlFactory.getUIShow().removeTip(sprite);
			}
			
			sprite.mouseChildren = false;
		}
		
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			
			var _name:String =  target.name;
			var _data:StructBagCell2 = null;
			if(0 == _name.indexOf("item_"))
			{
				_data = target.data as StructBagCell2;
				NpcBuy.instance().setType(4,_data,true,NpcHotShop.JINENG_BOOK_SUIPIAN_SHOP_ID);
			}
		}
		
		override public function getID():int
		{
			return 1053;
		}
		
	}
}




