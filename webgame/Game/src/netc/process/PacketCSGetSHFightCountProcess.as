package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSHFightCount2;

	public class PacketCSGetSHFightCountProcess extends PacketBaseProcess
	{
		public function PacketCSGetSHFightCountProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSHFightCount2=pack as PacketCSGetSHFightCount2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}