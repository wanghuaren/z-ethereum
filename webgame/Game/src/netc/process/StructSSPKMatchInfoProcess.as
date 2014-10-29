package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSSPKMatchInfo2;

	public class StructSSPKMatchInfoProcess extends PacketBaseProcess
	{
		public function StructSSPKMatchInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSSPKMatchInfo2=pack as StructSSPKMatchInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}