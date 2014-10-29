package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSXinWuChange2;

	public class PacketCSXinWuChangeProcess extends PacketBaseProcess
	{
		public function PacketCSXinWuChangeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSXinWuChange2=pack as PacketCSXinWuChange2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}