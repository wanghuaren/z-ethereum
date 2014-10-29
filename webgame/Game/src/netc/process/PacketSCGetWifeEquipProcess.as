package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetWifeEquip2;

	public class PacketSCGetWifeEquipProcess extends PacketBaseProcess
	{
		public function PacketSCGetWifeEquipProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetWifeEquip2=pack as PacketSCGetWifeEquip2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}