package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDevilGetValue2;

	public class PacketCSDevilGetValueProcess extends PacketBaseProcess
	{
		public function PacketCSDevilGetValueProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDevilGetValue2=pack as PacketCSDevilGetValue2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}