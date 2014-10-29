package model.rebate
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;

	public class ConsumeRebateRwardConfig
	{
		public var YBNum:int = 0;
		public var DropID:int = 0;
		public var itemList:Vector.<StructBagCell2> = null;
		
		public function ConsumeRebateRwardConfig(ybnum:int,dropID:int)
		{
			YBNum = ybnum;
			DropID = dropID;
			itemList = new Vector.<StructBagCell2>();
			
			_getToolConfigList(DropID,itemList);
		}
		
		/**
		 * 通过掉落ID获得道具配置文件列表  
		 * @param dropID
		 * 
		 */		
		private function _getToolConfigList(dropID:int,itemList:Vector.<StructBagCell2>):void
		{
			var _DropResModelList:Vector.<Pub_DropResModel> = XmlManager.localres.getDropXml.getResPath2(dropID) as Vector.<Pub_DropResModel>;
			var _dropLength:int = _DropResModelList.length;
			var _DropResModel:Pub_DropResModel = null;
			//var _ToolsResModel:Pub_ToolsResModel = null;
			var _StructBagCell2:StructBagCell2 = null; //new StructBagCell2();
			
			for(var i:int = 0; i<_dropLength; ++i)
			{
				_DropResModel = _DropResModelList[i];
				if(null != _DropResModel)
				{
//					 = XmlManager.localres.getToolsXml.getResPath(_DropResModel.drop_item_id);
//					
//					if(null != _ToolsResModel)
//					{
//						_StructBagCell2 = new _ToolsResModel
//					}
//					
					_StructBagCell2 = new StructBagCell2();
					_StructBagCell2.itemid = _DropResModel.drop_item_id;
					_StructBagCell2.num = _DropResModel.drop_num;
					Data.beiBao.fillCahceData(_StructBagCell2);
					
					itemList.push(_StructBagCell2);
				}
			}
			
		}
	}
}