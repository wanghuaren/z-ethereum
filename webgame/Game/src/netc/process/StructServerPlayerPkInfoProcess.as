package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerPlayerPkInfo2;

	public class StructServerPlayerPkInfoProcess extends PacketBaseProcess
	{
		public function StructServerPlayerPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerPlayerPkInfo2=pack as StructServerPlayerPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}