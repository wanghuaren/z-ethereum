package ui.view.view4.yunying
{
	
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.frame.ItemManager;
	
	import world.FileManager;

	/**
	 *洪福齐天 
	 * @author hpt
	 * 
	 */
	public class HongFuQiTian_frame2
	{
		private static var m_instance:HongFuQiTian_frame2;
		private var mc:MovieClip;
		public function HongFuQiTian_frame2()
		{
		}
		public static function getInstance():HongFuQiTian_frame2
		{
			if (null == m_instance)
			{
				m_instance=new HongFuQiTian_frame2();
			}
			
			return m_instance;
		}
		
		public function setMc(v:MovieClip):void
		{
			mc = v;
			
			_initCom();
		}
		
		//private var m_hasInitCom:Boolean = false;
		private function _initCom():void
		{
			if(null == mc)
			{
				return ;
			}
			var _length:int = 0;
			var _arrDesc:Array = Lang.getLabelArr('arrChong_zhi_fu_li_MoWen_Desc');
			var _arrID:Array = Lang.getLabelArr('arrChong_zhi_fu_li_MoWen_ID');
			var _arrNum:Array = Lang.getLabelArr('arrChong_zhi_fu_li_MoWen_Num');
			
			_length = _arrDesc.length;
			
			var _ToolsResModel:Pub_ToolsResModel = null;
			var _sprite:*= null; //
			var _cString:String = null;
			var _bagCell:StructBagCell2 = null;
			for(var i:int = 0; i < _length; ++i)
			{
				_ToolsResModel = GameData.getToolsXml().getResPath(_arrID[i]);
				_sprite = mc['mcItem_'+i]['mcIcon'];
				_sprite.mouseChildren = false;
				
				_cString = "<font color='#"+ResCtrl.instance().arrColor[_ToolsResModel.tool_color]+"' >"+ _ToolsResModel.tool_name+"</font>" ;
				mc['mcItem_'+i]['tf_desc'].htmlText = _arrDesc[i];
				mc['mcItem_'+i]['tf_name'].htmlText = _cString;
				mc['mcItem_'+i]['mcIcon']['txt_num'].htmlText = _arrNum[i];
//				mc["mcItem_"+i]['mcIcon']["uil"].source = FileManager.instance.getIconSById(_ToolsResModel.tool_icon);
				ImageUtils.replaceImage(mc["mcItem_"+i]['mcIcon'],mc["mcItem_"+i]['mcIcon']["uil"],FileManager.instance.getIconSById(_ToolsResModel.tool_icon));
				mc['chongzhiboxTxt'].htmlText = Lang.getLabel("chongzhiboxTxt");
				_bagCell = new StructBagCell2();
				_bagCell.itemid = _ToolsResModel.tool_id;
				Data.beiBao.fillCahceData(_bagCell);
				_sprite["data"] = _bagCell;
				CtrlFactory.getUIShow().addTip(_sprite);
				ItemManager.instance().setEquipFace(_sprite,true);
			}
			
		}
		
	}
	
	
}









