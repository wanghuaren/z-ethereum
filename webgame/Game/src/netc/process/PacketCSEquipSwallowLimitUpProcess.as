package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipSwallowLimitUp2;

	public class PacketCSEquipSwallowLimitUpProcess extends PacketBaseProcess
	{
		public function PacketCSEquipSwallowLimitUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipSwallowLimitUp2=pack as PacketCSEquipSwallowLimitUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}