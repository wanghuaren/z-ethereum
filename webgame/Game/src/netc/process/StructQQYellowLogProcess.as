package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructQQYellowLog2;

	public class StructQQYellowLogProcess extends PacketBaseProcess
	{
		public function StructQQYellowLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructQQYellowLog2=pack as StructQQYellowLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}