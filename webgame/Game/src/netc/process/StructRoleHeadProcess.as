package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRoleHead2;

	public class StructRoleHeadProcess extends PacketBaseProcess
	{
		public function StructRoleHeadProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRoleHead2=pack as StructRoleHead2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}