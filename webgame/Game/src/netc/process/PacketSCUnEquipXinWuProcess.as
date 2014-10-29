package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCUnEquipXinWu2;

	public class PacketSCUnEquipXinWuProcess extends PacketBaseProcess
	{
		public function PacketSCUnEquipXinWuProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCUnEquipXinWu2=pack as PacketSCUnEquipXinWu2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}