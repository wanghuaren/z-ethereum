package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCampPoint2;

	public class StructCampPointProcess extends PacketBaseProcess
	{
		public function StructCampPointProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCampPoint2=pack as StructCampPoint2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}