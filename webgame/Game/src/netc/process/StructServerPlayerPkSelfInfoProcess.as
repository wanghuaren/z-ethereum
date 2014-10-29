package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerPlayerPkSelfInfo2;

	public class StructServerPlayerPkSelfInfoProcess extends PacketBaseProcess
	{
		public function StructServerPlayerPkSelfInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerPlayerPkSelfInfo2=pack as StructServerPlayerPkSelfInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}