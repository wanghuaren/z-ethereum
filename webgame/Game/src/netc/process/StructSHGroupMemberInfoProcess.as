package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSHGroupMemberInfo2;

	public class StructSHGroupMemberInfoProcess extends PacketBaseProcess
	{
		public function StructSHGroupMemberInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSHGroupMemberInfo2=pack as StructSHGroupMemberInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}