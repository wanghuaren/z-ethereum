package model.jingjie
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import display.components.CmbArrange;
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.UIWindowManager;
	import ui.view.view2.liandanlu.LianDanLu;
	
	import world.FileManager;
	
	
	/**
	 * 境界功能中所需要的丹药不足的对话框
	 * 
	 * @author steven guo
	 * 
	 */	
	public class DanyaobuzuWindow extends UIWindow
	{
		private static var m_instance:DanyaobuzuWindow;
		
		//丹药的下来菜单
		//private var m_cmbArrange:CmbArrange = null; // mc["mc_cmb"] as CmbArrange;
		
		//丹药数量组件 
		//private var m_MoreLess:MoreLess = null;
		
		//丹药的最大值
		private var m_MaxNum:int = 99;
		
		public function DanyaobuzuWindow()
		{
			super(getLink("win_bu_zu"));
			//_init();
			
			//this.winClose();
			
		}
		
		public static function getInstance():DanyaobuzuWindow
		{
			//UIMovieClip.currentObjName=null;
			if(null == m_instance)
			{
				m_instance = new DanyaobuzuWindow();
				
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			
			//m_cmbArrange = mc["mc_cmb"] as CmbArrange;
			
			//m_MoreLess = mc["ui_count"] as MoreLess;
			mc["ui_count"].min = 0;
			mc["ui_count"].max = 99;
			super.sysAddEvent(mc["ui_count"],MoreLess.CHANGE,_moreLessChangeHandle);
			
			
			//添加下拉菜单的事件监听
			if (null != mc   && !(mc["mc_cmb"].hasEventListener(DispatchEvent.EVENT_COMB_CLICK)))
			{
				sysAddEvent(mc["mc_cmb"], DispatchEvent.EVENT_COMB_CLICK, _cmbClickHandler);
				//mc["mc_cmb"].changeSelected(ssl.entertype);
			}
			
			//当药列表
			var _items:Array = null;
			
			if(null != mc["mc_cmb"].getItems && mc["mc_cmb"].getItems.length <= 0)
			{
				_items = _getDanYaoConfigList();
				mc["mc_cmb"].addItems = _items;
			}
			
		}
		
		private function _moreLessChangeHandle(e:DispatchEvent):void 
		{
			var _price:int = _countTotalPrice();
			
			if(_price <= 0)
			{
				mc['txt_price_all'].text = 0 + Lang.getLabel("pub_yuan_bao");
				StringUtils.setUnEnable(mc['btnBuyAndUse']);
			}
			else
			{
				mc['txt_price_all'].text = _countTotalPrice() + Lang.getLabel("pub_yuan_bao");
				StringUtils.setEnable(mc['btnBuyAndUse']);
			}
			
			
		}
		
		private var m_structBag:StructBagCell2 = null;
		private function _cmbClickHandler(e:DispatchEvent):void
		{
			if(null == m_structBag)
			{
				m_structBag = new StructBagCell2();
				
			}
			
			var _Pub_ToolsResModel:Pub_ToolsResModel = mc["mc_cmb"].curData as Pub_ToolsResModel;
			if(null == _Pub_ToolsResModel)
			{
				return ;
			}
			
			m_structBag.itemid = _Pub_ToolsResModel.tool_id;
			
			Data.beiBao.fillCahceData(m_structBag);
			
			//更新icon图标
//			mc['mcIcon']['uil'].source = m_structBag.icon;
			ImageUtils.replaceImage(mc['mcIcon'],mc['mcIcon']["uil"],m_structBag.icon);
			
			mc['mcIcon']["data"] = m_structBag;
			CtrlFactory.getUIShow().addTip(mc['mcIcon']);
			
			ItemManager.instance().setEquipFace(mc['mcIcon']);
			
			m_MaxNum = _countMaxNum(_Pub_ToolsResModel);
			
			mc["ui_count"].max = m_MaxNum;
			if(m_MaxNum<=0 )
			{
				mc["ui_count"].showCount(0);
			}
			else
			{
				mc["ui_count"].showCount(1);
			}
			
		}
		
		
		/**
		 * 获得丹药道具列表 
		 * @return 
		 * 
		 */		
		private function _getDanYaoConfigList():Array
		{
			var _ret:Array = [];
			
			//10701001 = 10701010
			var _Pub_ToolsResModel:Pub_ToolsResModel = null; //XmlManager.localres.getToolsXml.getResPath(10701001);
			for(var id:int = 10701001 ; id<=10701010 ; ++id)
			{
				_Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(id);
				if(null != _Pub_ToolsResModel)
				{
					_ret.push({label:_Pub_ToolsResModel.tool_name,data:_Pub_ToolsResModel});
				}
			}
			
			return _ret;
		}
		
		//private function _init():void
		//{
			//mc["_buy"].addEventListener(MouseEvent.CLICK,_onBuyClickListener);
			//mc["_cancel"].addEventListener(MouseEvent.CLICK,_onCancelClickListener);

			
		//}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnBuyAndUse": // 购买并服用。 点击【购买并服用】按钮，关闭该提示界面并服用丹药。如果购买多颗丹药，只服用一颗。
					var _Pub_ToolsResModel:Pub_ToolsResModel = mc["mc_cmb"].curData as Pub_ToolsResModel;
					
					JingjieController.getInstance().requestCSBuyPill(_Pub_ToolsResModel.tool_id,
						mc["ui_count"].value,JingjieModel.getInstance().getIndex());
					this.winClose();
					break;
				case "_cancel":
					break;
				case "_box":
					mc["_box"].selected = !mc["_box"].selected;
					
					JingjieModel.getInstance().setIsTishi(mc["_box"].selected);
					
					break;
				case "btn_do_now":  // 立即炼制   
					LianDanLu.instance().setType(3);
					this.winClose();
					break;
				case "btnMax":
					mc["ui_count"].showCount(m_MaxNum);
					break;
				default:
					break;
			}
		}
		
		override public function open(must:Boolean=false,type:Boolean=true):void
		{
		
			addObjToStage(mc);
			
			repaint();
			//replace();
			
			//默认选择当前自己
		}
		
		
		private function _onBuyClickListener(event:MouseEvent):void
		{
			var _pillID:int = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
			JingjieController.getInstance().requestCSBuyPill(_pillID,1,JingjieModel.getInstance().getIndex());
			
		}
		
		
		private function _onCancelClickListener(event:MouseEvent):void
		{
			this.winClose();
		}
		
		public function repaint():void
		{
			var _pillID:int = JingjieModel.getInstance().selectPillId(JingjieModel.getInstance().getIndex());
			//通过 _pillID 在表中找到对应的 元宝
			var _ToolsResModel:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(_pillID);
			
			var _index:int = (_pillID % 100) - 1;
			
			if(_index < 0 )
			{
				_index = 0;
			}
			else if(_index>10)
			{
				_index = 10;
			}
			
			//mc["txt_msg"].text = Lang.getLabel("40021_jingjie_danyaobuzu" , [_ToolsResModel.tool_coin3] );
			if(null != mc["mc_cmb"])
			{
				mc["mc_cmb"].changeSelected(_index);
			}
		
			
			
		}
		
		/**
		 * 计算当前选中丹药的最大购买数量。 
		 * @return 
		 * 
		 */		
		private function _countMaxNum(config:Pub_ToolsResModel):int
		{
			var _ret:int = 0;
			
			//当前玩家的元宝数量
			var _hasYB:int = Data.myKing.yuanBao;
			_ret = _hasYB / config.tool_coin3;
			
			if(_ret < 0)
			{
				_ret = 0;
			}
			else if(_ret > 99)
			{
				_ret = 99;
			}
			
			return _ret;
		}
		
		/**
		 * 计算总计需要花费多少元宝  
		 * @return 
		 * 
		 */		
		private function _countTotalPrice():int
		{
			var _Pub_ToolsResModel:Pub_ToolsResModel = mc["mc_cmb"].curData as Pub_ToolsResModel;
			var _value:int = mc["ui_count"].value;
			
			var _ret:int;
			
			_ret = _Pub_ToolsResModel.tool_coin3 * _value;
			
			return _ret;
		}
		
	}
}



