package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerList2;

	public class StructServerListProcess extends PacketBaseProcess
	{
		public function StructServerListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerList2=pack as StructServerList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}