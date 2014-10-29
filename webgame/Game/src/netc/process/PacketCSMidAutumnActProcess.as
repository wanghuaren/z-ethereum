package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMidAutumnAct2;

	public class PacketCSMidAutumnActProcess extends PacketBaseProcess
	{
		public function PacketCSMidAutumnActProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMidAutumnAct2=pack as PacketCSMidAutumnAct2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}