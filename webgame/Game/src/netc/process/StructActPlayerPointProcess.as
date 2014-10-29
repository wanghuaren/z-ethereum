package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructActPlayerPoint2;

	public class StructActPlayerPointProcess extends PacketBaseProcess
	{
		public function StructActPlayerPointProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructActPlayerPoint2=pack as StructActPlayerPoint2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}