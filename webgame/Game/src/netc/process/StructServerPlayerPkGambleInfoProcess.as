package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerPlayerPkGambleInfo2;

	public class StructServerPlayerPkGambleInfoProcess extends PacketBaseProcess
	{
		public function StructServerPlayerPkGambleInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerPlayerPkGambleInfo2=pack as StructServerPlayerPkGambleInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}