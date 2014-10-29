package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPrizeMsgMemInfo2;

	public class StructPrizeMsgMemInfoProcess extends PacketBaseProcess
	{
		public function StructPrizeMsgMemInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPrizeMsgMemInfo2=pack as StructPrizeMsgMemInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}