package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPrizeMsgDbInfoItems2;

	public class StructPrizeMsgDbInfoItemsProcess extends PacketBaseProcess
	{
		public function StructPrizeMsgDbInfoItemsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPrizeMsgDbInfoItems2=pack as StructPrizeMsgDbInfoItems2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}