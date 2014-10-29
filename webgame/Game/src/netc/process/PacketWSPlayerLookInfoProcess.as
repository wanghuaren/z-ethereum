package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSPlayerLookInfo2;

	public class PacketWSPlayerLookInfoProcess extends PacketBaseProcess
	{
		public function PacketWSPlayerLookInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSPlayerLookInfo2=pack as PacketWSPlayerLookInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}