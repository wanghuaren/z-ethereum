package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructActCharRecInfoList2;

	public class StructActCharRecInfoListProcess extends PacketBaseProcess
	{
		public function StructActCharRecInfoListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructActCharRecInfoList2=pack as StructActCharRecInfoList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}