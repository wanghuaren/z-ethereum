package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSuperCutOffData2;

	public class PacketCSGetSuperCutOffDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetSuperCutOffDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSuperCutOffData2=pack as PacketCSGetSuperCutOffData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}