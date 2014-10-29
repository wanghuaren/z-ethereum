package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQInstallSuccess2;

	public class PacketCSQQInstallSuccessProcess extends PacketBaseProcess
	{
		public function PacketCSQQInstallSuccessProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQInstallSuccess2=pack as PacketCSQQInstallSuccess2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}