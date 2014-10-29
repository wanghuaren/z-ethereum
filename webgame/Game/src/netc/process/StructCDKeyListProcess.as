package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCDKeyList2;

	public class StructCDKeyListProcess extends PacketBaseProcess
	{
		public function StructCDKeyListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCDKeyList2=pack as StructCDKeyList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}