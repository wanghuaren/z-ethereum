package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWSelectPkCamp2;

	public class PacketCWSelectPkCampProcess extends PacketBaseProcess
	{
		public function PacketCWSelectPkCampProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWSelectPkCamp2=pack as PacketCWSelectPkCamp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}