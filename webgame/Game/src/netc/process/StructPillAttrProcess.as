package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPillAttr2;

	public class StructPillAttrProcess extends PacketBaseProcess
	{
		public function StructPillAttrProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPillAttr2=pack as StructPillAttr2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}