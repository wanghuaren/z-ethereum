package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQShareSuccess2;

	public class PacketCSQQShareSuccessProcess extends PacketBaseProcess
	{
		public function PacketCSQQShareSuccessProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQShareSuccess2=pack as PacketCSQQShareSuccess2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}