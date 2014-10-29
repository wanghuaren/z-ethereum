package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainPure2;

	public class PacketCSEvilGrainPureProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainPureProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainPure2=pack as PacketCSEvilGrainPure2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}