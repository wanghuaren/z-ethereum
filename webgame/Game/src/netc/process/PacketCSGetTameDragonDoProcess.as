package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTameDragonDo2;

	public class PacketCSGetTameDragonDoProcess extends PacketBaseProcess
	{
		public function PacketCSGetTameDragonDoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTameDragonDo2=pack as PacketCSGetTameDragonDo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}