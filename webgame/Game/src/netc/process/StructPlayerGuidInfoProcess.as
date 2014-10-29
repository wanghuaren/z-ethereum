package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPlayerGuidInfo2;

	public class StructPlayerGuidInfoProcess extends PacketBaseProcess
	{
		public function StructPlayerGuidInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPlayerGuidInfo2=pack as StructPlayerGuidInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}