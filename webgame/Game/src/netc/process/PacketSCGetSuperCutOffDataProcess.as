package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSuperCutOffData2;

	public class PacketSCGetSuperCutOffDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetSuperCutOffDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSuperCutOffData2=pack as PacketSCGetSuperCutOffData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}