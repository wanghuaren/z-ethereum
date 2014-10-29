package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWPlayerLookInfo2;

	public class PacketSWPlayerLookInfoProcess extends PacketBaseProcess
	{
		public function PacketSWPlayerLookInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWPlayerLookInfo2=pack as PacketSWPlayerLookInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}