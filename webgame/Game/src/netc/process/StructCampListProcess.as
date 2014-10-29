package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCampList2;

	public class StructCampListProcess extends PacketBaseProcess
	{
		public function StructCampListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCampList2=pack as StructCampList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}