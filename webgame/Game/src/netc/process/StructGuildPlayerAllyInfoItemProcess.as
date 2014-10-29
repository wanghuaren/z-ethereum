package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildPlayerAllyInfoItem2;

	public class StructGuildPlayerAllyInfoItemProcess extends PacketBaseProcess
	{
		public function StructGuildPlayerAllyInfoItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildPlayerAllyInfoItem2=pack as StructGuildPlayerAllyInfoItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}