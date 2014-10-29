package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainDisAssamble2;

	public class PacketCSEvilGrainDisAssambleProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainDisAssambleProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainDisAssamble2=pack as PacketCSEvilGrainDisAssamble2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}