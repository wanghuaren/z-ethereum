package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSuperCutOffGift2;

	public class PacketCSGetSuperCutOffGiftProcess extends PacketBaseProcess
	{
		public function PacketCSGetSuperCutOffGiftProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSuperCutOffGift2=pack as PacketCSGetSuperCutOffGift2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}