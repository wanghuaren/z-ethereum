package ui.view.view2.rebate
{
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.rebate.ConsumeRebateModel;
	import model.rebate.ConsumeRebateRwardConfig;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;

	public class ConsumeRebateRewardItem
	{
		private var m_ConsumeRebateRwardConfig:ConsumeRebateRwardConfig = null;
		
		private var m_ui:MovieClip = null;
		
		private static const MAX_NUM:int = 10;
		
		private var m_index:int = 0;
		
		private var m_model:ConsumeRebateModel = null;
		
		public function ConsumeRebateRewardItem(ui:MovieClip,config:ConsumeRebateRwardConfig)
		{
			m_ui = ui;
			m_ConsumeRebateRwardConfig = config;
			m_model = ConsumeRebateModel.getInstance();
		}
		
		public function setIndex(i:int):void
		{
			m_index = i;
		}
		
		public function update():void
		{
			var _itemList:Vector.<StructBagCell2> = m_ConsumeRebateRwardConfig.itemList;
			var _StructBagCell2:StructBagCell2 = null;
			
			for(var i:int = 0; i<MAX_NUM; ++i)
			{
				var sprite:*= m_ui['box_'+i];
				
				if(null == _itemList || i >= _itemList.length)
				{
					sprite.visible = false;
					ItemManager.instance().setEquipFace(sprite,false);
					continue;
				}
				
				_StructBagCell2 = _itemList[i];
				if(null == _StructBagCell2)
				{
					sprite.visible = false;
					ItemManager.instance().setEquipFace(sprite,false);
					continue;
				}
				
				sprite.data = _StructBagCell2;
//				sprite['uil'].source = _StructBagCell2.icon;
				ImageUtils.replaceImage(sprite,sprite["uil"],_StructBagCell2.icon);
				sprite['txt_num'].htmlText = StringUtils.changeToTenThousand(_StructBagCell2.num);
				ItemManager.instance().setEquipFace(sprite);
				CtrlFactory.getUIShow().addTip(sprite);
			}
			
			m_ui['mc_effect'].mouseChildren = false;
			m_ui['mc_effect'].mouseEnabled = false;
			
			//处理领取按钮
			var _btnStatu:int =  m_model.getStateByIndex(m_index);
			switch(_btnStatu)
			{
				case ConsumeRebateModel.CONSUME_REBATE_CANNOT:  //不够条件，不能领
					m_ui['mc_effect'].gotoAndStop(1);
					m_ui['mc_effect'].visible = false;
					m_ui['btnLingQu'].label = Lang.getLabel("pub_bu_ke_ling");
					StringUtils.setUnEnable(m_ui['btnLingQu']);			
					m_ui['btnLingQu'].removeEventListener(MouseEvent.CLICK,_onMouseClickListener);
					break;
				case ConsumeRebateModel.CONSUME_REBATE_NO:      //可领
					m_hasClick = false;
					m_ui['mc_effect'].gotoAndPlay(1);
					m_ui['mc_effect'].visible = true;
					m_ui['btnLingQu'].label = Lang.getLabel("pub_ling_qu");
					StringUtils.setEnable(m_ui['btnLingQu']);
					m_ui['btnLingQu'].addEventListener(MouseEvent.CLICK,_onMouseClickListener);
					break;
				case ConsumeRebateModel.CONSUME_REBATE_YES:     //已经领了
					m_ui['mc_effect'].gotoAndStop(1);
					m_ui['mc_effect'].visible = false;
					m_ui['btnLingQu'].label = Lang.getLabel("pub_yi_ling");
					StringUtils.setUnEnable(m_ui['btnLingQu']);
					m_ui['btnLingQu'].removeEventListener(MouseEvent.CLICK,_onMouseClickListener);
					break;
				default:
					break;
			}
			
		}
		
		private var m_hasClick:Boolean = false;
		private function _onMouseClickListener(e:MouseEvent):void
		{
			if(m_hasClick)
			{
				return ;	
			}
			
			m_hasClick = true;
			m_ui['btnLingQu'].removeEventListener(MouseEvent.CLICK,_onMouseClickListener);
			m_model.requestCSGetCosumePrize(m_index);
		}
		
		
		
		
	}
}


