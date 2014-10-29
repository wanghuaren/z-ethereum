package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructNextList2;

	public class StructNextListProcess extends PacketBaseProcess
	{
		public function StructNextListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructNextList2=pack as StructNextList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}