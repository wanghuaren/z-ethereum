package ui.view.view2.NewMap
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.packets2.StructDoubleExpInfo2;
	import netc.packets2.StructMapSeek2;
	import netc.packets2.StructNpcTrans2;
	
	import nets.packets.PacketCSMapSeek;
	import nets.packets.PacketCSMapSend;
	import nets.packets.PacketCSNpcSend;
	import nets.packets.PacketSCMapSeek;
	import nets.packets.PacketSCMapSend;
	import nets.packets.PacketSCNpcSend;
	
	import scene.utils.MapData;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	public class DiGongMap extends UIWindow
	{
		private var sp_source : Sprite = new Sprite();
		
		private var currData:Object=null;
		
		private static var _doubleExpData:StructDoubleExpInfo2;
				
		private static var _instance:DiGongMap=null;
		

		public static function instance():DiGongMap
		{
			if (_instance == null)
			{
				_instance=new DiGongMap();
			}
			return _instance;
		}
		
		public function DiGongMap()
		{
//			super(getLink(WindowName.win_digong_chuan_song));
		}
		
		/**
		 * 20200011 地宫一层 
		    20200012 地宫二层 
			20200013 地宫三层
			
			 地图寻径表(map_seek) seek_id

			地宫一层 80401138
			地宫二层 80401139
			地宫三层 80401140
		 */ 
		
		public static function get MAP_LIST():Array
		{
			//20200011、20200012、20200013
			
			return [
				
				{map_id:20200011,send_id:80401138},
				{map_id:20200012,send_id:80401139},
				{map_id:20200013,send_id:80401140}
			];
			
		}
		
		override protected function init() : void 
		{
		
			mc["sp"].position=0;
			
			while(sp_source.numChildren>0)
			{
				sp_source.removeChildAt(0);
			}
			
//			var mapList:Array = [
//				{map_id:20200011,send_id:80401138},
//				{map_id:20200012,send_id:80401139},
//				{map_id:20200013,send_id:80401140}
//			];
			
			var mapList:Array = MAP_LIST;
				
			mapList.forEach(callBack);
			
			CtrlFactory.getUIShow().showList2(sp_source,1,415,82);
			mc["sp"].source = sp_source;
			sp_source.x=0;//10
			sp_source.y = 0;
			
			//
			if(sp_source.getChildByName("item0")!=null)
			{
				itemSelected(sp_source.getChildByName("item0"));
				currData = (sp_source.getChildByName("item0") as MovieClip).data;	
				
			}else{
				currData = null;
			}
			
		}
		
		
		private function callBack(valueObj:Object,index:int,arr:Array):void{
			
			var itemDO:MovieClip = ItemManager.instance().getDiGongItem(index) as MovieClip;
				
			var itemData:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(valueObj.map_id) as Pub_MapResModel;
//			var itemData:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(valueObj.map_id);
			super.itemEvent(itemDO,itemData,false);
			//	if(itemData.min_level<=DataCenter.myKing.level){
			
			//itemDO["uil"].source = FileManager.instance.getSendSmallMapById(itemData.map_id);
			
//			itemDO["uil"].source = FileManager.instance.getSendSmallMapById(itemData.res_id);
			ImageUtils.replaceImage(itemDO,itemDO["uil"],FileManager.instance.getSendSmallMapById(itemData.res_id));
			var color:String="";
			if(Data.myKing.coin1<itemData.send_coin){
				color="ff0000";
			}else{
				color="fff5d2";
			}
			itemDO["txt_fei_yong"].htmlText ="<font color='#"+color+"'>"+ itemData.send_coin+Lang.getLabel("pub_yin_liang")+"</font>";
			if(Data.myKing.level<itemData.min_level){
				color="ff0000";
			}else{
				color="fff5d2";
			}
			itemDO["txt_level1"].htmlText = "<font color='#"+color+"'>"+ itemData.min_level+Lang.getLabel("pub_ji")+"</font>";
			itemDO["txt_level2"].htmlText = itemData.pk_mode;
			itemDO["txt_level3"].htmlText = itemData.monster_level;
			
			itemDO.name = "item"+index;
			itemDO.data = {map_id:itemData.map_id,send_id:valueObj.send_id,min_level:itemData.min_level};
			
			//itemDO.y = (itemDO.height-10)*index;
//			itemDO.y = (itemDO.height+20)*index;
			itemDO.mouseChildren = true;
			itemDO["btnChuanSong"].mouseEnabled = true;
			sp_source.addChild(itemDO);
		}
		
		
		
		// 鼠标点击事件
		override public function mcHandler(target : Object) : void {
			super.mcHandler(target);
//			if(target.name.indexOf("item")==0){
//				currData = target.data;
//				itemSelected(target);
//			}
			if(target.name.indexOf("item")==0){
				currData = target.data;
				itemSelected(target);
			}else if (target.parent.name.indexOf("item")==0){
				var obj:Object = target.parent;
				currData = obj.data;
				itemSelected(obj);
			}
			switch(target.name) {
				case "btnChuanSong":
					if(currData!=null){
						if(currData.min_level<=Data.myKing.level){
							var vo:PacketCSMapSend = new PacketCSMapSend();
							vo.sendid = currData.send_id;
							uiSend(vo);
							winClose();	
						}else{
							Lang.showMsg(Lang.getClientMsg("20068_TransMap"));
						}
					}
					break;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}