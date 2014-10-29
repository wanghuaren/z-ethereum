package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDropList2;

	public class StructDropListProcess extends PacketBaseProcess
	{
		public function StructDropListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDropList2=pack as StructDropList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}