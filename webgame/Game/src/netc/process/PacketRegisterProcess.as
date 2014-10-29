package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketRegister2;

	public class PacketRegisterProcess extends PacketBaseProcess
	{
		public function PacketRegisterProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketRegister2=pack as PacketRegister2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}