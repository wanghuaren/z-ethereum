package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructAr_Point2;

	public class StructAr_PointProcess extends PacketBaseProcess
	{
		public function StructAr_PointProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructAr_Point2=pack as StructAr_Point2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}