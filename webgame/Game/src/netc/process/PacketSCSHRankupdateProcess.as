package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHRankupdate2;
	
	public class PacketSCSHRankupdateProcess extends PacketBaseProcess
	{
		public function PacketSCSHRankupdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHRankupdate2=pack as PacketSCSHRankupdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}