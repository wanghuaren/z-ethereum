package netc.packets2
{
	import common.config.xmlres.XmlManager;
	
	import nets.packets.PacketWCActTimeWaring;
	
	public class PacketWCActTimeWaring2 extends PacketWCActTimeWaring
	{
		public function PacketWCActTimeWaring2()
		{
			super();
		}
		
		public function get groupid():int
		{
			return XmlManager.localres.ActionDescXml.getResPath(this.act_id)["action_group"];
		}
	}
}