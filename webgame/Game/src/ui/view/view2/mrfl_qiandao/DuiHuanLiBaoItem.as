package ui.view.view2.mrfl_qiandao
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.utils.CtrlFactory;
	
	import flash.display.*;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	
	import world.FileManager;
	
	public class DuiHuanLiBaoItem extends Sprite
	{
		private var m_ui:Sprite = null;
		private var m_index:int = 0;
		private var m_struct:StructCDKey2;
		private var m_desc:String ;
		public var m_id:int;
		private var m_name:String;
		private var m_resid:int;
		public function DuiHuanLiBaoItem(ui:Sprite,struct:StructCDKey2)
		{
			super();
			m_ui = ui;
			m_struct = struct;
			m_desc = struct.desc;
			m_id = struct.id;
			m_name = struct.name;
			m_resid = struct.resid;
			
			addChild(m_ui);
			inititem();
		}
		private function linkHandler(e:TextEvent):void
		{
//			playMP3(linkEvent.text);
			flash.net.navigateToURL(new URLRequest(e.text),"_blank");
		}
		private function inititem():void
		{
//			m_ui['item'+1]['uil'].source = FileManager.instance.getIconDuiHuanById(m_resid);
			ImageUtils.replaceImage(m_ui['item'+1],m_ui['item'+1]["uil"],FileManager.instance.getIconDuiHuanById(m_resid));
			m_ui['title_txt'].htmlText = m_name;
			m_ui['desc'].htmlText =m_desc;
			addEventListener(TextEvent.LINK, linkHandler);

			var itemxml:MovieClip;
			var structCDkeyItem:StructCDKeyItem2;
			for(var i:int = 2;i<=7;i++){
				
				itemxml = m_ui['item'+i];
				if(i>(m_struct.arrItemitems.length+1))
				{
					itemxml.visible = false;
					continue;
				}
				structCDkeyItem = m_struct.arrItemitems[i-2];
				if(structCDkeyItem!=null) {
					
					itemxml.visible = true;
					
					var dropNum:int  = structCDkeyItem.ItemNum;
					var xml:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(structCDkeyItem.ItemId) as Pub_ToolsResModel;
					if(xml!=null){
//						itemxml['uil'].source = FileManager.instance.getIconSById(xml.tool_icon);
						ImageUtils.replaceImage(itemxml,itemxml["uil"],FileManager.instance.getIconSById(xml.tool_icon));
						itemxml["txt_num"].text = structCDkeyItem.ItemNum;
					}else{
						itemxml["uil"].unload();
						itemxml["txt_num"].text = "";
						itemxml.visible = false;
					}
					
					//----------------
					var tool_id:int =structCDkeyItem.ItemId;					
					var child:MovieClip = m_ui['item'+i];
					
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=tool_id;
					Data.beiBao.fillCahceData(bag);
					
					child.data=bag;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
					
					//-----------------------------------------
					
				}
			}
		}
		public function setIndex(index:int):void
		{
			m_index = index;
			
//			_repaint();
		}
		
		public function getIndex():int 
		{
			return m_index;
		}
		
		
		
	}
}