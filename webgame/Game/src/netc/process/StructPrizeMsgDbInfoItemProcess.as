package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPrizeMsgDbInfoItem2;

	public class StructPrizeMsgDbInfoItemProcess extends PacketBaseProcess
	{
		public function StructPrizeMsgDbInfoItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPrizeMsgDbInfoItem2=pack as StructPrizeMsgDbInfoItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}