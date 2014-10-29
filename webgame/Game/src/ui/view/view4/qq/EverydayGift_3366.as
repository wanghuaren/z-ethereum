package view.view4.qq
{
	import cache.GameData;
	import cache.inside.xmls.Pub_DropResModel;
	import cache.inside.xmls.Pub_ToolsResModel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	import model.qq.YellowDiamond;
	import model.qq.YellowDiamondEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import utils.AsToJs;
	import utils.CtrlFactory;
	import utils.StringUtils;
	
	import view.UIWindow;
	import view.WindowName;
	
	import world.FileManager;
	import world.Lang;
	
	/**
	 * 3366 每日礼包
	 * @author steven guo
	 * 
	 */	
	public class EverydayGift_3366 extends UIWindow
	{
		private static var m_instance:EverydayGift_3366;
		
		private var m_model:YellowDiamond = null;
		
		private static const m_url:String = "http://www.3366.com/info/grow_daily.shtml";
		
		public function EverydayGift_3366(DO:DisplayObject=null, arrayData:Object=null, layer:int=1, addLayer:Boolean=true)
		{
			var _url:String = WindowName.win_EverydayGift_3366;
			super(getLink(_url));
			
			m_model = YellowDiamond.getInstance();
		}
		
		public static function getInstance():EverydayGift_3366
		{
			if (null == m_instance)
			{
				m_instance= new EverydayGift_3366();
			}
			
			return m_instance;
		}
		
		override protected function init():void 
		{
			super.init();

			mc['item_jiangli0']['mcLevel'].gotoAndStop(1);
			mc['item_jiangli1']['mcLevel'].gotoAndStop(2);
			mc['item_jiangli2']['mcLevel'].gotoAndStop(3);
			mc['item_jiangli3']['mcLevel'].gotoAndStop(4);
			mc['item_jiangli4']['mcLevel'].gotoAndStop(5);
			mc['item_jiangli5']['mcLevel'].gotoAndStop(6);
			
			m_model.addEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT,_processEvent);
			_repaint();
			
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			m_model.removeEventListener(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT,_processEvent);
		}
		
		private function _processEvent(e:YellowDiamondEvent):void
		{
			var _sort:int = e.sort;
			
			_repaint();
		}
		
		private function _repaint():void
		{
			_repaintTitle();
			_repaintBtn();
			_repaintItems();
		}
		
		private function _repaintTitle():void
		{
			mc['tf_zhuangtai'].htmlText = Lang.getLabel("QQ_3366_EverydayGift_Tile",[m_model.get3366RealLevel()]);
			
		}
		
		private function _repaintBtn():void
		{
			//已经领取了
			if(1 == m_model.get3366Gifts())
			{
				mc['btnLingJiang'].visible = false;
				mc['btnHasLingJiang'].visible = true;
				//StringUtils.setUnEnable(mc['btnLingJiang']);
			}
			else
			{
				//StringUtils.setEnable(mc['btnLingJiang']);
				mc['btnLingJiang'].visible = true;
				mc['btnHasLingJiang'].visible = false;
			}
		}
		
		private function _repaintItems():void
		{
			for(var i:int = 0 ; i < 6 ; ++i)
			{
				_repaintItem(i);
			}
		}
		
		private function _repaintItem(index:int):void
		{
			var _dorpList:Array =  Lang.getLabelArr("arrQQ_EverydayGift_3366");
			var _dorpID:int = _dorpList[index];
			
			var _dropItemList:Vector.<Pub_DropResModel> = GameData.getDropXml().getResPath2(_dorpID);
			var _ToolsResModel:Pub_ToolsResModel = null;
			
			var _item:* = mc['item_jiangli'+index] ;
			for(var i:int = 0; i < 5 ; ++i)
			{
				_item['item'+i].visible = false;
				_item['item'+i]['uil'].source = null;
				_item['tf_'+i].text = "";
				_removeTip(_item['item'+i]);
				
				if(i >= _dropItemList.length)
				{
					continue;
				}
				
				_ToolsResModel = GameData.getToolsXml().getResPath(_dropItemList[i].drop_item_id);
				if(null == _ToolsResModel)
				{
					continue;
				}

				_item['item'+i].visible = true;
				_item['item'+i]['uil'].source = FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
				_item['tf_'+i].text ="×"+StringUtils.changeToTenThousand(_dropItemList[i].drop_num);
				_addTip(_item['item'+i],_ToolsResModel.tool_id);
				
			}
			
			if( (m_model.get3366Level() - 1 ) == index)
			{
				_item['mcSelected'].gotoAndStop(2);
			}
			else
			{
				_item['mcSelected'].gotoAndStop(1);
			}
		}
		
		private function _addTip(mc:MovieClip,toolID:int,isBagIcon:Boolean = false):void
		{
			var _itemData:StructBagCell2=null;
			_itemData = new StructBagCell2();
			_itemData.itemid= toolID;
			Data.beiBao.fillCahceData(_itemData);
			
			if(isBagIcon)
			{
				mc['uil'].source = _itemData.iconBig;
			}
			else
			{
				mc['uil'].source = _itemData.icon;
			}
			
			
			mc["data"]=_itemData;
			CtrlFactory.getUIShow().addTip(mc);
		}
		
		private function _removeTip(mc:MovieClip):void
		{
			mc['uil'].source = null;
			CtrlFactory.getUIShow().removeTip(mc);
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnLingJiang":
					m_model.requestCSQQYellowGift(4); //领取3366每日登录礼包
					break;
				case "BtnGoTo":
					//AsToJs.instance.callJS("openvip");
					flash.net.navigateToURL(new URLRequest(m_url),"_blank");
					
					break;
				default:
					break;
			}
			
		}
	}
	
	
}











