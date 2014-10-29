package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSSPKResult2;

	public class PacketCSGetSSPKResultProcess extends PacketBaseProcess
	{
		public function PacketCSGetSSPKResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSSPKResult2=pack as PacketCSGetSSPKResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}