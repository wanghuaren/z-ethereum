package ui.view.view4.qq
{

	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_YellowResModel;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	
	import world.FileManager;
	
	public class EDScrollPanelItem extends Sprite
	{
		private var m_ui:Sprite;
		
		private var m_model:YellowDiamond;
		
		//黄钻等级
		private var m_level:int = 0;
		
		public function EDScrollPanelItem(ui:Sprite)
		{
			super();
			
			m_model = YellowDiamond.getInstance();
			m_ui = ui;
			addChild(m_ui);
		}
		
		public function setLevel(_level:int):void
		{
			m_level = _level;
		}
		
		public function update():void
		{
			var _list:Array = m_model.getConfigGiftsList();
			var _YellowResModel:Pub_YellowResModel = _list[m_level] as Pub_YellowResModel;
			
			var _dropID:int = _YellowResModel.drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(_dropID) as Vector.<Pub_DropResModel>;
			var _DropResModel:Pub_DropResModel = null;
			var _ToolsResModel:Pub_ToolsResModel = null;
			
			m_ui['mcIconHuangZuan'].gotoAndStop(m_level);
			
			for(var i:int = 1 ; i<= 5 ; ++i)
			{
				_DropResModel = null;
				_ToolsResModel = null;
				
				if(i <= _DropResModelList.length)
				{
					_DropResModel = _DropResModelList[i - 1];
					if(null != _DropResModel)
					{
						_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_DropResModel.drop_item_id) as Pub_ToolsResModel;
						m_ui['item'+i]['r_num'].text = StringUtils.changeToTenThousand(_DropResModel.drop_num);
					}
					
					if(null != _ToolsResModel)
					{
						_addTip(m_ui['item'+i],_ToolsResModel.tool_id);
					}
					else
					{
						CtrlFactory.getUIShow().removeTip(m_ui['item'+i]);
					}
				}
				else 
				{
					_removeTip(m_ui['item'+i]);
				}
				
			}
		}
		
		
		
		private function _addTip(mc:MovieClip,toolID:int):void
		{
			var _itemData:StructBagCell2=null;
			_itemData = new StructBagCell2();
			_itemData.itemid= toolID;
			Data.beiBao.fillCahceData(_itemData);
			
//			mc['uil'].source = _itemData.icon;
			ImageUtils.replaceImage(mc,mc["uil"],_itemData.icon);
			mc["data"]=_itemData;
			CtrlFactory.getUIShow().addTip(mc);
			
			ItemManager.instance().setEquipFace(mc);
		}
		
		private function _removeTip(mc:MovieClip):void
		{
			mc['uil'].source = null;
			CtrlFactory.getUIShow().removeTip(mc);
		}
		
	}
}









