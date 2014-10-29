package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPayChangeMoney2;

	public class PacketCSPayChangeMoneyProcess extends PacketBaseProcess
	{
		public function PacketCSPayChangeMoneyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPayChangeMoney2=pack as PacketCSPayChangeMoney2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}