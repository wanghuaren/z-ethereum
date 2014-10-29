package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildArea1MapOpen2;

	public class PacketCSGetGuildArea1MapOpenProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildArea1MapOpenProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildArea1MapOpen2=pack as PacketCSGetGuildArea1MapOpen2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}