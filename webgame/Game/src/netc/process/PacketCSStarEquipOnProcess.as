package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStarEquipOn2;

	public class PacketCSStarEquipOnProcess extends PacketBaseProcess
	{
		public function PacketCSStarEquipOnProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStarEquipOn2=pack as PacketCSStarEquipOn2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}