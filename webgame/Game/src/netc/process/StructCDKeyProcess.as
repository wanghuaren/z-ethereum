package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCDKey2;

	public class StructCDKeyProcess extends PacketBaseProcess
	{
		public function StructCDKeyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCDKey2=pack as StructCDKey2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}