package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBoothCheckExist2;

	public class PacketCSBoothCheckExistProcess extends PacketBaseProcess
	{
		public function PacketCSBoothCheckExistProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBoothCheckExist2=pack as PacketCSBoothCheckExist2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}