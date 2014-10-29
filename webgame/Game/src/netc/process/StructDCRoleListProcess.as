package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDCRoleList2;

	public class StructDCRoleListProcess extends PacketBaseProcess
	{
		public function StructDCRoleListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDCRoleList2=pack as StructDCRoleList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}