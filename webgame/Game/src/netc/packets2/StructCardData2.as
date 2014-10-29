package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import nets.packets.StructCardData;
	public class StructCardData2 extends StructCardData
	{
		//private var _mc_iconNew_clicked:Boolean = false;
		public function StructCardData2()
		{
			//_mc_iconNew_clicked = false;
		}
		public function get pos():int
		{
			var len:int = this.card_id.toString().length;
			var pos_str:String = this.card_id.toString().substr(len-2,2);
			var pos_num:int = parseInt(pos_str);
			return pos_num;
		}
		public function get tool_desc():String
		{		
			var tool:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(this.card_id) as Pub_ToolsResModel;
			return tool.tool_desc;
		}
		public function get tool_name():String
		{		
			var tool:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(this.card_id) as Pub_ToolsResModel;
			return tool.tool_name;
		}
		public function get tool_id():int
		{		
			return this.card_id;
		}
	}
}