package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPrizeMsgDbInfo2;

	public class StructPrizeMsgDbInfoProcess extends PacketBaseProcess
	{
		public function StructPrizeMsgDbInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPrizeMsgDbInfo2=pack as StructPrizeMsgDbInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}