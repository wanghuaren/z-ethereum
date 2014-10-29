package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructShortKeyList2;

	public class StructShortKeyListProcess extends PacketBaseProcess
	{
		public function StructShortKeyListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructShortKeyList2=pack as StructShortKeyList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}