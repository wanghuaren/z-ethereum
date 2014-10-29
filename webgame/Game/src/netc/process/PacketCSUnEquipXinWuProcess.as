package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSUnEquipXinWu2;

	public class PacketCSUnEquipXinWuProcess extends PacketBaseProcess
	{
		public function PacketCSUnEquipXinWuProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSUnEquipXinWu2=pack as PacketCSUnEquipXinWu2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}