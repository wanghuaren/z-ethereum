package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildArea1MapOpen2;

	public class PacketSCGetGuildArea1MapOpenProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildArea1MapOpenProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildArea1MapOpen2=pack as PacketSCGetGuildArea1MapOpen2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}