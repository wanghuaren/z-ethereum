package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSXinWuAttrActive2;

	public class PacketCSXinWuAttrActiveProcess extends PacketBaseProcess
	{
		public function PacketCSXinWuAttrActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSXinWuAttrActive2=pack as PacketCSXinWuAttrActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}