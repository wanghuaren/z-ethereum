package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTameDragonData2;

	public class PacketCSGetTameDragonDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetTameDragonDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTameDragonData2=pack as PacketCSGetTameDragonData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}