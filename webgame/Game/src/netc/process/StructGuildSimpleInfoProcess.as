package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildSimpleInfo2;

	public class StructGuildSimpleInfoProcess extends PacketBaseProcess
	{
		public function StructGuildSimpleInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildSimpleInfo2=pack as StructGuildSimpleInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}