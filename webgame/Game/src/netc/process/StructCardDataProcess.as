package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCardData2;

	public class StructCardDataProcess extends PacketBaseProcess
	{
		public function StructCardDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCardData2=pack as StructCardData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}