package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerPosVerify2;

	public class PacketCSPlayerPosVerifyProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerPosVerifyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerPosVerify2=pack as PacketCSPlayerPosVerify2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}