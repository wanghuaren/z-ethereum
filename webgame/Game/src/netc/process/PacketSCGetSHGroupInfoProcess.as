package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSHGroupInfo2;

	public class PacketSCGetSHGroupInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetSHGroupInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSHGroupInfo2=pack as PacketSCGetSHGroupInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}