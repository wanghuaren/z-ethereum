package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPlayerInstanceInfo2;

	public class StructPlayerInstanceInfoProcess extends PacketBaseProcess
	{
		public function StructPlayerInstanceInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPlayerInstanceInfo2=pack as StructPlayerInstanceInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}