package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainSeal2;

	public class PacketCSEvilGrainSealProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainSealProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainSeal2=pack as PacketCSEvilGrainSeal2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}