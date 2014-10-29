package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCOpenActTimeWaring2;

	public class PacketWCOpenActTimeWaringProcess extends PacketBaseProcess
	{
		public function PacketWCOpenActTimeWaringProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCOpenActTimeWaring2=pack as PacketWCOpenActTimeWaring2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}