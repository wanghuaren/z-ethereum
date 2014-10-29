package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEquipXinWu2;

	public class PacketSCEquipXinWuProcess extends PacketBaseProcess
	{
		public function PacketSCEquipXinWuProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEquipXinWu2=pack as PacketSCEquipXinWu2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}