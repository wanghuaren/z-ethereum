package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructItemAttr2;

	public class StructItemAttrProcess extends PacketBaseProcess
	{
		public function StructItemAttrProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructItemAttr2=pack as StructItemAttr2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}