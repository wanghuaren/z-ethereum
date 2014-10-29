package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCXinWuAttrActive2;

	public class PacketSCXinWuAttrActiveProcess extends PacketBaseProcess
	{
		public function PacketSCXinWuAttrActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCXinWuAttrActive2=pack as PacketSCXinWuAttrActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}