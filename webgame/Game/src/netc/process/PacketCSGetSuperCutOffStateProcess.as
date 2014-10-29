package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSuperCutOffState2;

	public class PacketCSGetSuperCutOffStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetSuperCutOffStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSuperCutOffState2=pack as PacketCSGetSuperCutOffState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}