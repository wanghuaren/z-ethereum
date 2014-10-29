package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTianDaoLunHuiUpdate2;

	public class PacketSCTianDaoLunHuiUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCTianDaoLunHuiUpdateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTianDaoLunHuiUpdate2=pack as PacketSCTianDaoLunHuiUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}