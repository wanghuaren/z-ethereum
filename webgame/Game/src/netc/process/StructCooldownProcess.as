package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCooldown2;

	public class StructCooldownProcess extends PacketBaseProcess
	{
		public function StructCooldownProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCooldown2=pack as StructCooldown2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}