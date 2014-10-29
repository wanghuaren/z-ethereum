package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCitySignGuild2;

	public class StructCitySignGuildProcess extends PacketBaseProcess
	{
		public function StructCitySignGuildProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCitySignGuild2=pack as StructCitySignGuild2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}