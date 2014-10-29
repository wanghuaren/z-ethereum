package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainHoleOpen2;

	public class PacketCSEvilGrainHoleOpenProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainHoleOpenProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainHoleOpen2=pack as PacketCSEvilGrainHoleOpen2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}