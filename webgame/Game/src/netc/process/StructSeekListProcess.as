package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSeekList2;

	public class StructSeekListProcess extends PacketBaseProcess
	{
		public function StructSeekListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSeekList2=pack as StructSeekList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}