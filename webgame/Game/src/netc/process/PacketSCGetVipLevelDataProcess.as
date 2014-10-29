package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import netc.packets2.PacketSCGetVipLevelData2;
	
	public class PacketSCGetVipLevelDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetVipLevelDataProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetVipLevelData2=pack as PacketSCGetVipLevelData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
		
	}
}