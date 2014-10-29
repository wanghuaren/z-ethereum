package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSOpenActTimeWaring2;

	public class PacketCSOpenActTimeWaringProcess extends PacketBaseProcess
	{
		public function PacketCSOpenActTimeWaringProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSOpenActTimeWaring2=pack as PacketCSOpenActTimeWaring2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}