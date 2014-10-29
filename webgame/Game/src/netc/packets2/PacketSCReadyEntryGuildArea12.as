package netc.packets2
{
	import common.config.xmlres.XmlManager;
	
	import nets.packets.PacketSCReadyEntryGuildArea1;

	public class PacketSCReadyEntryGuildArea12 extends PacketSCReadyEntryGuildArea1
	{

		public function get action_name():String
		{
			return XmlManager.localres.ActionDescXml.getResPath(action_id)["action_name"];
			
		}
		
		public function get action_group():int
		{
			return XmlManager.localres.ActionDescXml.getResPath(action_id)["action_group"];
			
		}
		
	}
}