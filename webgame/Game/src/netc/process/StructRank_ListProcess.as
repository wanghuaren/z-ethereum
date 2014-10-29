package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRank_List2;

	public class StructRank_ListProcess extends PacketBaseProcess
	{
		public function StructRank_ListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRank_List2=pack as StructRank_List2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}