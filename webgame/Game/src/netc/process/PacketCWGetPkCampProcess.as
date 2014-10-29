package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWGetPkCamp2;

	public class PacketCWGetPkCampProcess extends PacketBaseProcess
	{
		public function PacketCWGetPkCampProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWGetPkCamp2=pack as PacketCWGetPkCamp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}