package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCRefleshArrow2;

	public class PacketSCRefleshArrowProcess extends PacketBaseProcess
	{
		public function PacketSCRefleshArrowProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCRefleshArrow2=pack as PacketSCRefleshArrow2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}