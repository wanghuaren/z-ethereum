package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRoleGemInfo2;

	public class StructRoleGemInfoProcess extends PacketBaseProcess
	{
		public function StructRoleGemInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRoleGemInfo2=pack as StructRoleGemInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}