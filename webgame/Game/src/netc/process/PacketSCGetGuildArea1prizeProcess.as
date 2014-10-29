package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildArea1prize2;

	public class PacketSCGetGuildArea1prizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildArea1prizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildArea1prize2=pack as PacketSCGetGuildArea1prize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}