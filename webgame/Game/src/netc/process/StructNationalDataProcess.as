package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructNationalData2;

	public class StructNationalDataProcess extends PacketBaseProcess
	{
		public function StructNationalDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructNationalData2=pack as StructNationalData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}