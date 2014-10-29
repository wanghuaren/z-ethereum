package view.view4.qq
{
	import cache.GameData;
	import cache.inside.xmls.Pub_DropResModel;
	import cache.inside.xmls.Pub_ToolsResModel;
	import cache.inside.xmls.Pub_YellowResModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import utils.CtrlFactory;
	import utils.StringUtils;
	
	public class BlueDiamondEDScrollPanelItem extends Sprite
	{
		private var m_ui:Sprite;
		
		private var m_model:YellowDiamond;
		
		//蓝钻等级
		private var m_level:int = 0;
		
		
		public function BlueDiamondEDScrollPanelItem(ui:Sprite)
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
			var _DropResModelList:Vector.<Pub_DropResModel> = GameData.getDropXml().getResPath2(_dropID);
			var _DropResModel:Pub_DropResModel = null;
			var _ToolsResModel:Pub_ToolsResModel = null;
			
			m_ui['mcIconHuangZuan'].gotoAndStop(m_level);
			
			for(var i:int = 1 ; i<= 4 ; ++i)
			{
				_DropResModel = null;
				_ToolsResModel = null;
				
				if(i <= _DropResModelList.length)
				{
					_DropResModel = _DropResModelList[i - 1];
					if(null != _DropResModel)
					{
						_ToolsResModel = GameData.getToolsXml().getResPath(_DropResModel.drop_item_id);
						//m_ui['item'+i]['r_num'].text = StringUtils.changeToTenThousand(_DropResModel.drop_num);
						m_ui['tf_item'+i].text = "×"+StringUtils.changeToTenThousand(_DropResModel.drop_num);
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
			
			var _QQYellowLevel:int = m_model.getQQYellowLevel();
			
			if(m_model.getQQYellowType() == YellowDiamond.QQ_YELLOW_NULL)
			{
				m_ui['mcBtn'].visible = false;
			}
			else
			{
				if(m_level == _QQYellowLevel)
				{
					m_ui['mcBtn'].visible = true;
					m_ui['mcBg'].gotoAndStop(2);
					if(0 == m_model.getQQYellowGiftsCommon())
					{
						m_ui['mcBtn'].gotoAndStop(1);
					}
					else
					{
						m_ui['mcBtn'].gotoAndStop(3);
					}
				}
				else
				{
					m_ui['mcBtn'].visible = false;
					m_ui['mcBg'].gotoAndStop(1);
				}
			}
			
			
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
		}
		
		private function _removeTip(mc:MovieClip):void
		{
			mc.visible = false;
			mc['uil'].source = null;
			CtrlFactory.getUIShow().removeTip(mc);
		}
		
		
		
		
	}
}