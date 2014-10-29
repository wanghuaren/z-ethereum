package ui.view.view4.qq
{
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_YellowResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	
	import world.FileManager;
	
	public class LevelScrollPanelItem extends Sprite
	{
		private var m_ui:Sprite;
		
		private var m_showIndex:int = 0;
		
		private var m_model:YellowDiamond;
		
		public function LevelScrollPanelItem(ui:Sprite)
		{
			super();
			
			m_model = YellowDiamond.getInstance();
			
			m_ui = ui;
			m_ui['btn_ling_qu'].label = Lang.getLabel("40065_QQ_Yellow_1"); //"已经领取";
			addChild(m_ui);
		}
		
		public function setShowIndex(_index:int):void
		{
			m_showIndex = _index;
		}
		
		
		public function update():void
		{
			var _list:Array = m_model.getConfigGiftsLevelListByShowIndex();
			var _YellowResModel:Pub_YellowResModel = _list[m_showIndex][0] as Pub_YellowResModel;

			m_ui['txt_need_level'].htmlText = _YellowResModel.king_level;
			
			var _dropID:int = _YellowResModel.drop_id;
			var _DropResModelList:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(_dropID) as Vector.<Pub_DropResModel>;
			var _DropResModel:Pub_DropResModel = null;
			var _ToolsResModel:Pub_ToolsResModel = null;
			
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
						//m_ui['item'+i]['uil'].source = FileManager.instance.getIconXById(_ToolsResModel.tool_icon);
						_addTip(m_ui['item'+i],_ToolsResModel.tool_id);
					}
					else
					{
						//m_ui['item'+i]['uil'].source = null;
						_removeTip(m_ui['item'+i]);
					}
				}
				else 
				{
					//m_ui['item'+i]['uil'].source = null;
					_removeTip(m_ui['item'+i]);
				}
				
			}
			
			
			// 处理领取奖励按钮
			// 是否已经领取
			var _isReceive:int = _list[m_showIndex][1];
			
			//已经领取
			if(1 == _isReceive)
			{
				m_ui['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
				m_ui['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_1"); //"已经领取";
				StringUtils.setUnEnable(m_ui['btn_ling_qu']);
			}
			//等级不足
			else if(Data.myKing.level < _YellowResModel.king_level)
			{
				m_ui['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
				m_ui['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_2"); //"等级不足";
				StringUtils.setUnEnable(m_ui['btn_ling_qu']);
			}
			//黄钻可领
			else if(YellowDiamond.QQ_YELLOW_NULL == YellowDiamond.getInstance().getQQYellowType())
			{
				m_ui['btn_ling_qu'].removeEventListener(MouseEvent.CLICK,_onMouseEventListener);
				m_ui['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_4"); //"黄钻可领";
				StringUtils.setUnEnable(m_ui['btn_ling_qu']);
			}
			//可以领取
			else
			{
				m_ui['btn_ling_qu'].addEventListener(MouseEvent.CLICK,_onMouseEventListener);
				m_ui['btn_ling_qu'].label =  Lang.getLabel("40065_QQ_Yellow_3"); //"可以领取";
				StringUtils.setEnable(m_ui['btn_ling_qu']);
			}
		}
		
		
		private function _onMouseEventListener(e:MouseEvent):void
		{
			m_model.requestCSQQYellowLevelGift(m_showIndex);
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





