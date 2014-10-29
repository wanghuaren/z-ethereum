package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCSelectPkCamp2;

	public class PacketWCSelectPkCampProcess extends PacketBaseProcess
	{
		public function PacketWCSelectPkCampProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCSelectPkCamp2=pack as PacketWCSelectPkCamp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}