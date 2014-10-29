package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStarEquipOff2;

	public class PacketCSStarEquipOffProcess extends PacketBaseProcess
	{
		public function PacketCSStarEquipOffProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStarEquipOff2=pack as PacketCSStarEquipOff2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}