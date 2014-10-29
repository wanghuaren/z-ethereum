package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructShortKey2;

	public class StructShortKeyProcess extends PacketBaseProcess
	{
		public function StructShortKeyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructShortKey2=pack as StructShortKey2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}