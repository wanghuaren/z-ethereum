package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetAttTarget2;

	public class PacketCSPetAttTargetProcess extends PacketBaseProcess
	{
		public function PacketCSPetAttTargetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetAttTarget2=pack as PacketCSPetAttTarget2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}