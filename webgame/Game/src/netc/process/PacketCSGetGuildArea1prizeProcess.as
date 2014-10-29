package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildArea1prize2;

	public class PacketCSGetGuildArea1prizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildArea1prizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildArea1prize2=pack as PacketCSGetGuildArea1prize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}