package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWCurServerPkInfo2;

	public class PacketCWCurServerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketCWCurServerPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWCurServerPkInfo2=pack as PacketCWCurServerPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}