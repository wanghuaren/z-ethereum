package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWifeEquip2;

	public class PacketCSGetWifeEquipProcess extends PacketBaseProcess
	{
		public function PacketCSGetWifeEquipProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWifeEquip2=pack as PacketCSGetWifeEquip2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}