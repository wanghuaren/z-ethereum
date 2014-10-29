package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCMidAutumnAct2;

	public class PacketSCMidAutumnActProcess extends PacketBaseProcess
	{
		public function PacketSCMidAutumnActProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCMidAutumnAct2=pack as PacketSCMidAutumnAct2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}