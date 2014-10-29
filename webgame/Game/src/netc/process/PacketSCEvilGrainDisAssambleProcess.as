package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEvilGrainDisAssamble2;

	public class PacketSCEvilGrainDisAssambleProcess extends PacketBaseProcess
	{
		public function PacketSCEvilGrainDisAssambleProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEvilGrainDisAssamble2=pack as PacketSCEvilGrainDisAssamble2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}