package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPrizeMsgInfo2;

	public class StructPrizeMsgInfoProcess extends PacketBaseProcess
	{
		public function StructPrizeMsgInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPrizeMsgInfo2=pack as StructPrizeMsgInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}