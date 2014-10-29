package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSServerRmbBuff2;

	public class PacketCSServerRmbBuffProcess extends PacketBaseProcess
	{
		public function PacketCSServerRmbBuffProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSServerRmbBuff2=pack as PacketCSServerRmbBuff2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}